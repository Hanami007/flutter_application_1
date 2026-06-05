import 'package:supabase_flutter/supabase_flutter.dart' as supabase_core;
import 'package:uuid/uuid.dart';
import '../../../../core/constants/app_constants.dart';
import '../domain/entities/enrollment.dart';
import '../domain/use_cases/check_enrollment_use_case.dart';
import '../domain/use_cases/purchase_course_use_case.dart';
import '../../courses/domain/entities/course.dart';
import '../../courses/data/mock_course_data.dart';
import 'mock_enrollment_data.dart';

/// Concrete implementation of enrollment data operations.
///
/// Follows the same Supabase-first + mock fallback pattern as [CourseRepository].
class EnrollmentRepository
    implements CheckEnrollmentRepository, PurchaseCourseRepository {
  // ─────────── helpers ───────────

  bool get _isSupabaseActive {
    try {
      // Only check that Supabase is initialized with a real (non-placeholder) URL.
      // No session is required — RLS policies allow anon key access for enrollment
      // operations (see supabase_rls_migration.sql).
      return AppConstants.supabaseUrl.isNotEmpty &&
          !AppConstants.supabaseUrl.contains('your-project');
    } catch (_) {
      return false;
    }
  }

  supabase_core.SupabaseClient get _client =>
      supabase_core.Supabase.instance.client;

  Map<String, dynamic> _mapCourseDbToModel(Map<String, dynamic> dbJson) {
    return {
      'id': dbJson['id']?.toString() ?? '',
      'name': dbJson['name']?.toString() ?? '',
      'description': dbJson['description']?.toString() ?? '',
      'categoryId':
          dbJson['category_id']?.toString() ?? dbJson['categoryId']?.toString() ?? '',
      'instructorId':
          dbJson['instructor_id']?.toString() ?? dbJson['instructorId']?.toString() ?? '',
      'thumbnailUrl':
          dbJson['thumbnail_url']?.toString() ?? dbJson['thumbnailUrl']?.toString(),
      'price': dbJson['price'] != null
          ? double.parse(dbJson['price'].toString())
          : 0.0,
      'duration': dbJson['duration'] != null
          ? int.parse(dbJson['duration'].toString())
          : 0,
      'level': dbJson['level']?.toString() ?? 'Beginner',
      'rating': dbJson['rating'] != null
          ? double.parse(dbJson['rating'].toString())
          : 0.0,
      'totalStudents': dbJson['total_students'] != null
          ? int.parse(dbJson['total_students'].toString())
          : 0,
      'createdAt': dbJson['created_at'] ?? dbJson['createdAt'],
      'updatedAt': dbJson['updated_at'] ?? dbJson['updatedAt'],
    };
  }

  // ─────────── CheckEnrollmentRepository ───────────

  @override
  Future<Enrollment?> checkEnrollment(String userId, String courseId) async {
    if (_isSupabaseActive) {
      try {
        final response = await _client
            .from('enrollments')
            .select()
            .eq('user_id', userId)
            .eq('course_id', courseId)
            .maybeSingle();
        if (response != null) {
          return Enrollment.fromJson(response as Map<String, dynamic>);
        }
        return null;
      } catch (e) {
        // Fall through to mock
      }
    }
    return MockEnrollmentData.findByUserAndCourse(userId, courseId);
  }

  // ─────────── PurchaseCourseRepository ───────────

  /// Ensures the Supabase `users` table has a row for [userId] before we try
  /// to insert an enrollment (which has a FK → users.id).
  Future<void> _ensureUserExists(String userId) async {
    try {
      await _client.from('users').upsert(
        {
          'id': userId,
          'email': '${userId.substring(0, 8)}@anonymous.local',
          'full_name': 'Anonymous User',
        },
        onConflict: 'id',
        ignoreDuplicates: true,
      );
    } catch (e) {
      // Non-fatal: if users table rejects the upsert (e.g., RLS), the
      // enrollment insert will surface the FK error and we fall back to mock.
      supabase_core.Supabase.instance.client; // keep import alive
    }
  }

  @override
  Future<Enrollment> createEnrollment(String userId, String courseId) async {
    if (_isSupabaseActive) {
      try {
        // Guarantee the user row exists before inserting enrollment
        await _ensureUserExists(userId);

        final data = {
          'user_id': userId,
          'course_id': courseId,
          'payment_status': 'completed',
          'enrolled_at': DateTime.now().toIso8601String(),
        };

        // upsert so re-purchasing an already-enrolled course doesn't fail
        final response = await _client
            .from('enrollments')
            .upsert(data, onConflict: 'user_id,course_id')
            .select()
            .single();
        return Enrollment.fromJson(response as Map<String, dynamic>);
      } catch (e) {
        // Log the real error before falling back to mock so issues are visible
        // ignore: avoid_print
        print('[EnrollmentRepository] createEnrollment failed → mock: $e');
      }
    }
    // Mock fallback: create in-memory enrollment
    final newEnrollment = Enrollment(
      id: const Uuid().v4(),
      userId: userId,
      courseId: courseId,
      paymentStatus: 'completed',
      enrolledAt: DateTime.now(),
      createdAt: DateTime.now(),
    );
    MockEnrollmentData.mockEnrollments.add(newEnrollment);
    return newEnrollment;
  }

  // ─────────── Additional operations ───────────

  /// Returns all courses the user is enrolled in.
  Future<List<Course>> getEnrolledCourses(String userId) async {
    if (_isSupabaseActive) {
      try {
        // Fetch enrollment rows, then course details
        final enrollments = await _client
            .from('enrollments')
            .select('course_id')
            .eq('user_id', userId)
            .eq('payment_status', 'completed');

        final courseIds = (enrollments as List)
            .map((e) => e['course_id'].toString())
            .toList();

        if (courseIds.isEmpty) return [];

        final coursesResp = await _client
            .from('courses')
            .select()
            .in_('id', courseIds);

        return (coursesResp as List)
            .map((c) => Course.fromJson(_mapCourseDbToModel(c)))
            .toList();
      } catch (_) {
        // Fall through
      }
    }
    // Mock fallback
    final userEnrollments = MockEnrollmentData.forUser(userId);
    final enrolledIds = userEnrollments.map((e) => e.courseId).toSet();
    return MockCourseData.mockCourses
        .where((c) => enrolledIds.contains(c.id))
        .toList();
  }

  /// Updates the last_accessed_at timestamp for an enrollment.
  Future<void> updateLastAccessed(String userId, String courseId) async {
    if (_isSupabaseActive) {
      try {
        await _client
            .from('enrollments')
            .update({'last_accessed_at': DateTime.now().toIso8601String()})
            .eq('user_id', userId)
            .eq('course_id', courseId);
        return;
      } catch (_) {}
    }
    // Mock: update in list
    final idx = MockEnrollmentData.mockEnrollments
        .indexWhere((e) => e.userId == userId && e.courseId == courseId);
    if (idx != -1) {
      MockEnrollmentData.mockEnrollments[idx] =
          MockEnrollmentData.mockEnrollments[idx]
              .copyWith(lastAccessedAt: DateTime.now());
    }
  }

  // ─────────── Certificates ───────────

  Future<Certificate?> getCertificate(String userId, String courseId) async {
    if (_isSupabaseActive) {
      try {
        final resp = await _client
            .from('certificates')
            .select()
            .eq('user_id', userId)
            .eq('course_id', courseId)
            .maybeSingle();
        if (resp != null) return Certificate.fromJson(resp as Map<String, dynamic>);
      } catch (_) {}
    }
    return null;
  }

  Future<Certificate> createCertificate(String userId, String courseId) async {
    final now = DateTime.now();
    if (_isSupabaseActive) {
      try {
        final resp = await _client.from('certificates').insert({
          'user_id': userId,
          'course_id': courseId,
          'issued_at': now.toIso8601String(),
        }).select().single();
        return Certificate.fromJson(resp as Map<String, dynamic>);
      } catch (_) {}
    }
    return Certificate(
      id: const Uuid().v4(),
      userId: userId,
      courseId: courseId,
      issuedAt: now,
    );
  }

  // ─────────── Favorites ───────────

  Future<Set<String>> getFavoriteCourseIds(String userId) async {
    if (_isSupabaseActive) {
      try {
        final resp = await _client
            .from('favorite_courses')
            .select('course_id')
            .eq('user_id', userId);
        return (resp as List).map((r) => r['course_id'].toString()).toSet();
      } catch (_) {}
    }
    return {};
  }

  Future<void> addFavorite(String userId, String courseId) async {
    if (_isSupabaseActive) {
      try {
        await _client.from('favorite_courses').insert({
          'user_id': userId,
          'course_id': courseId,
        });
        return;
      } catch (_) {}
    }
  }

  Future<void> removeFavorite(String userId, String courseId) async {
    if (_isSupabaseActive) {
      try {
        await _client
            .from('favorite_courses')
            .delete()
            .eq('user_id', userId)
            .eq('course_id', courseId);
        return;
      } catch (_) {}
    }
  }

  // ─────────── Course Progress ───────────

  Future<CourseProgress?> getCourseProgress(
      String userId, String courseId) async {
    if (_isSupabaseActive) {
      try {
        final resp = await _client
            .from('course_progress')
            .select()
            .eq('user_id', userId)
            .eq('course_id', courseId)
            .maybeSingle();
        if (resp != null) {
          return CourseProgress.fromJson(_mapProgressDbToModel(resp as Map<String, dynamic>));
        }
      } catch (_) {}
    }
    // Mock fallback
    try {
      return MockCourseData.mockProgresses.firstWhere(
        (p) => p.userId == userId && p.courseId == courseId,
      );
    } catch (_) {
      return null;
    }
  }

  Future<CourseProgress> upsertCourseProgress({
    required String userId,
    required String courseId,
    required int videosWatched,
    required int videosTotal,
  }) async {
    final percentage = videosTotal > 0
        ? (videosWatched / videosTotal * 100).clamp(0.0, 100.0)
        : 0.0;

    if (_isSupabaseActive) {
      try {
        final resp = await _client.from('course_progress').upsert({
          'user_id': userId,
          'course_id': courseId,
          'videos_watched': videosWatched,
          'videos_total': videosTotal,
          'progress_percentage': percentage,
          if (percentage >= 100)
            'completed_at': DateTime.now().toIso8601String(),
        }, onConflict: 'user_id,course_id').select().single();

        return CourseProgress.fromJson(
            _mapProgressDbToModel(resp as Map<String, dynamic>));
      } catch (_) {}
    }

    // Mock: update in-list
    final existing = MockCourseData.mockProgresses.indexWhere(
      (p) => p.userId == userId && p.courseId == courseId,
    );
    final updated = CourseProgress(
      id: existing >= 0
          ? MockCourseData.mockProgresses[existing].id
          : const Uuid().v4(),
      userId: userId,
      courseId: courseId,
      videosWatched: videosWatched,
      videosTotal: videosTotal,
      progressPercentage: percentage / 100, // stored as 0.0–1.0 in mock
    );
    if (existing >= 0) {
      MockCourseData.mockProgresses[existing] = updated;
    } else {
      MockCourseData.mockProgresses.add(updated);
    }
    return updated;
  }

  Map<String, dynamic> _mapProgressDbToModel(Map<String, dynamic> db) => {
        'id': db['id']?.toString() ?? '',
        'userId': db['user_id']?.toString() ?? '',
        'courseId': db['course_id']?.toString() ?? '',
        'videosWatched': db['videos_watched'] ?? 0,
        'videosTotal': db['videos_total'] ?? 0,
        'progressPercentage': db['progress_percentage'] != null
            ? double.parse(db['progress_percentage'].toString()) / 100
            : 0.0,
        'completedAt': db['completed_at'],
      };
}
