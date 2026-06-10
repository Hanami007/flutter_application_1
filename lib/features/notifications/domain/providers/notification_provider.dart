import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../entities/app_notification.dart';
import 'package:learn_hub/features/booking/domain/providers/booking_provider.dart';
import 'package:learn_hub/features/enrollment/domain/providers/enrollment_provider.dart';

// ─────────────────────────────────────────────
// Notification StateNotifier
// ─────────────────────────────────────────────

class NotificationNotifier extends StateNotifier<List<AppNotification>> {
  final Ref ref;
  NotificationNotifier(this.ref) : super(_defaultNotifications()) {
    _listenToUpcomingClasses();
  }

  void _listenToUpcomingClasses() {
    ref.listen(allClassSessionsProvider, (previous, next) {
      _checkAndAddUpcomingReminders();
    });
    ref.listen(enrolledCoursesProvider, (previous, next) {
      _checkAndAddUpcomingReminders();
    });
    Future.microtask(() => _checkAndAddUpcomingReminders());
  }

  void _checkAndAddUpcomingReminders() {
    final classSessions = ref.read(allClassSessionsProvider).value ?? [];
    final enrolledCourses = ref.read(enrolledCoursesProvider).value ?? [];
    if (classSessions.isEmpty || enrolledCourses.isEmpty) return;

    final enrolledCourseIds = enrolledCourses.map((c) => c.id).toSet();
    final enrolledSessions = classSessions.where((s) => enrolledCourseIds.contains(s.courseId)).toList();

    final now = DateTime.now();
    final upcomingSessions = enrolledSessions.where((s) => s.startTime.isAfter(now)).toList();

    var updatedState = [...state];
    var changed = false;

    for (final session in upcomingSessions) {
      final course = enrolledCourses.firstWhere((c) => c.id == session.courseId);
      final reminderId = 'upcoming_session_${session.id}';
      
      final exists = state.any((n) => n.id == reminderId);
      if (!exists) {
        final startTime = session.startTime;
        final timeStr = '${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}';
        final dateStr = '${startTime.day}/${startTime.month}/${startTime.year}';
        
        final reminder = AppNotification(
          id: reminderId,
          title: '⏰ เตือนความจำ',
          message: 'คลาส "${course.name}" จะเริ่มในวันที่ $dateStr เวลา $timeStr น.',
          type: NotificationType.classReminder,
          createdAt: DateTime.now(),
          isRead: false,
        );
        updatedState.insert(0, reminder);
        changed = true;
      }
    }

    if (changed) {
      state = updatedState;
    }
  }

  /// Prepopulate a few sample notifications on first launch.
  static List<AppNotification> _defaultNotifications() {
    return [
      AppNotification(
        id: 'demo_1',
        title: '⏰ เตือนความจำ',
        message: 'คลาส "Flutter Basics" จะเริ่มใน 1 ชั่วโมง',
        type: NotificationType.classReminder,
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        isRead: false,
      ),
      AppNotification(
        id: 'demo_2',
        title: '🆕 คอสใหม่มาแล้ว!',
        message: '"Advanced Dart Programming" พร้อมให้เรียนแล้ว',
        type: NotificationType.newCourse,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        isRead: true,
      ),
    ];
  }

  // ── Mutation methods ─────────────────────────────────────────────────

  void add(AppNotification notification) {
    state = [notification, ...state];
  }

  void markRead(String id) {
    state = [
      for (final n in state)
        if (n.id == id)
          AppNotification(
            id: n.id,
            title: n.title,
            message: n.message,
            type: n.type,
            createdAt: n.createdAt,
            isRead: true,
          )
        else
          n,
    ];
  }

  void markAllRead() {
    state = [
      for (final n in state)
        AppNotification(
          id: n.id,
          title: n.title,
          message: n.message,
          type: n.type,
          createdAt: n.createdAt,
          isRead: true,
        ),
    ];
  }

  void dismiss(String id) {
    state = state.where((n) => n.id != id).toList();
  }

  void clearAll() {
    state = [];
  }
}

// ─────────────────────────────────────────────
// Providers
// ─────────────────────────────────────────────

final notificationProvider =
    StateNotifierProvider<NotificationNotifier, List<AppNotification>>(
  (ref) => NotificationNotifier(ref),
);

/// Total unread count — drives the badge in the bottom nav / app bar.
final unreadCountProvider = Provider<int>((ref) {
  return ref.watch(notificationProvider).where((n) => !n.isRead).length;
});
