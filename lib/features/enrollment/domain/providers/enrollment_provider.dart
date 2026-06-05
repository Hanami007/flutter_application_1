import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase_core;
import '../../data/enrollment_repository.dart';
import '../../domain/entities/enrollment.dart';
import '../../domain/use_cases/purchase_course_use_case.dart';
import '../../../courses/domain/entities/course.dart';
import '../../../auth/domain/providers/auth_provider.dart';

// ─────────────────────────────────────────────
// Repository Provider
// ─────────────────────────────────────────────

final enrollmentRepositoryProvider = Provider<EnrollmentRepository>((ref) {
  return EnrollmentRepository();
});

// ─────────────────────────────────────────────
// Current User ID helper
// ─────────────────────────────────────────────

/// UUID v4 pattern validator
bool _isValidUuid(String id) {
  final uuidRegex = RegExp(
    r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$',
    caseSensitive: false,
  );
  return uuidRegex.hasMatch(id);
}

/// Returns the current authenticated user's ID from Supabase or mock.
/// Only returns the Supabase user ID if it is a valid UUID (prevents 400 errors
/// on UUID-typed columns when a numeric/test user ID is returned).
final currentUserIdProvider = Provider<String>((ref) {
  // First try Supabase auth session — only accept UUID-formatted IDs
  try {
    final session = supabase_core.Supabase.instance.client.auth.currentSession;
    if (session != null && _isValidUuid(session.user.id)) {
      return session.user.id;
    }
  } catch (_) {}

  // Fall back to auth state provider
  final authState = ref.watch(authStateProvider);
  return authState.maybeMap(
    authenticated: (s) => _isValidUuid(s.user.id)
        ? s.user.id
        : '9999ee9d-ff46-4cb4-972c-f68482bf4f17',
    orElse: () => '9999ee9d-ff46-4cb4-972c-f68482bf4f17', // dev mock user
  );
});

// ─────────────────────────────────────────────
// Enrollment Status (per course)
// ─────────────────────────────────────────────

/// Watches whether the current user is enrolled in [courseId].
final enrollmentStatusProvider =
    FutureProvider.family<Enrollment?, String>((ref, courseId) async {
  final repo = ref.watch(enrollmentRepositoryProvider);
  final userId = ref.watch(currentUserIdProvider);
  return repo.checkEnrollment(userId, courseId);
});

// ─────────────────────────────────────────────
// Course Progress (per course)
// ─────────────────────────────────────────────

final courseProgressForCourseProvider =
    FutureProvider.family<CourseProgress?, String>((ref, courseId) async {
  final repo = ref.watch(enrollmentRepositoryProvider);
  final userId = ref.watch(currentUserIdProvider);
  return repo.getCourseProgress(userId, courseId);
});

// ─────────────────────────────────────────────
// Enrolled Courses (My Learning)
// ─────────────────────────────────────────────

final enrolledCoursesProvider = FutureProvider<List<Course>>((ref) async {
  final repo = ref.watch(enrollmentRepositoryProvider);
  final userId = ref.watch(currentUserIdProvider);
  return repo.getEnrolledCourses(userId);
});

/// Derived from [enrolledCoursesProvider] — returns only the IDs as a Set for
/// fast O(1) look-up per course without issuing per-card async requests.
final enrolledCourseIdsProvider = FutureProvider<Set<String>>((ref) async {
  final courses = await ref.watch(enrolledCoursesProvider.future);
  return courses.map((c) => c.id).toSet();
});

// ─────────────────────────────────────────────
// Favorite Course IDs
// ─────────────────────────────────────────────

final favoriteCourseIdsProvider = StateNotifierProvider<FavoriteCoursesNotifier, Set<String>>((ref) {
  final repo = ref.watch(enrollmentRepositoryProvider);
  final userId = ref.watch(currentUserIdProvider);
  return FavoriteCoursesNotifier(repo, userId);
});

class FavoriteCoursesNotifier extends StateNotifier<Set<String>> {
  final EnrollmentRepository _repo;
  final String _userId;

  FavoriteCoursesNotifier(this._repo, this._userId) : super({}) {
    _load();
  }

  Future<void> _load() async {
    final ids = await _repo.getFavoriteCourseIds(_userId);
    state = ids;
  }

  Future<void> toggle(String courseId) async {
    if (state.contains(courseId)) {
      await _repo.removeFavorite(_userId, courseId);
      state = Set.from(state)..remove(courseId);
    } else {
      await _repo.addFavorite(_userId, courseId);
      state = Set.from(state)..add(courseId);
    }
  }

  bool isFavorite(String courseId) => state.contains(courseId);
}

// ─────────────────────────────────────────────
// Purchase Course Notifier
// ─────────────────────────────────────────────

class PurchaseCourseNotifier extends StateNotifier<AsyncValue<Enrollment?>> {
  final EnrollmentRepository _repo;
  final Ref _ref;

  PurchaseCourseNotifier(this._repo, this._ref)
      : super(const AsyncValue.data(null));

  Future<bool> purchase(String courseId) async {
    state = const AsyncValue.loading();
    try {
      final userId = _ref.read(currentUserIdProvider);
      final useCase = PurchaseCourseUseCase(_repo);
      final enrollment = await useCase.call(userId: userId, courseId: courseId);
      state = AsyncValue.data(enrollment);

      // Invalidate providers so UI refreshes
      _ref.invalidate(enrollmentStatusProvider(courseId));
      _ref.invalidate(enrolledCoursesProvider);
      _ref.invalidate(enrolledCourseIdsProvider);
      _ref.invalidate(courseProgressForCourseProvider(courseId));

      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }
}

final purchaseCourseProvider =
    StateNotifierProvider<PurchaseCourseNotifier, AsyncValue<Enrollment?>>(
        (ref) {
  final repo = ref.watch(enrollmentRepositoryProvider);
  return PurchaseCourseNotifier(repo, ref);
});

// ─────────────────────────────────────────────
// Progress Update Notifier
// ─────────────────────────────────────────────

class ProgressUpdateNotifier extends StateNotifier<AsyncValue<CourseProgress?>> {
  final EnrollmentRepository _repo;
  final Ref _ref;

  ProgressUpdateNotifier(this._repo, this._ref)
      : super(const AsyncValue.data(null));

  Future<void> updateProgress({
    required String courseId,
    required int videosWatched,
    required int videosTotal,
  }) async {
    state = const AsyncValue.loading();
    try {
      final userId = _ref.read(currentUserIdProvider);
      final progress = await _repo.upsertCourseProgress(
        userId: userId,
        courseId: courseId,
        videosWatched: videosWatched,
        videosTotal: videosTotal,
      );
      state = AsyncValue.data(progress);
      _ref.invalidate(courseProgressForCourseProvider(courseId));

      // Issue certificate if 100%
      if (progress.progressPercentage >= 1.0 ||
          (progress.videosTotal > 0 &&
              progress.videosWatched >= progress.videosTotal)) {
        final cert = await _repo.getCertificate(userId, courseId);
        if (cert == null) {
          await _repo.createCertificate(userId, courseId);
        }
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final progressUpdateProvider =
    StateNotifierProvider<ProgressUpdateNotifier, AsyncValue<CourseProgress?>>(
        (ref) {
  final repo = ref.watch(enrollmentRepositoryProvider);
  return ProgressUpdateNotifier(repo, ref);
});

// ─────────────────────────────────────────────
// Certificate Provider (per course)
// ─────────────────────────────────────────────

final certificateProvider =
    FutureProvider.family<Certificate?, String>((ref, courseId) async {
  final repo = ref.watch(enrollmentRepositoryProvider);
  final userId = ref.watch(currentUserIdProvider);
  return repo.getCertificate(userId, courseId);
});
