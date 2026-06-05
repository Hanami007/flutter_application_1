import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../entities/app_notification.dart';

// ─────────────────────────────────────────────
// Notification StateNotifier
// ─────────────────────────────────────────────

class NotificationNotifier extends StateNotifier<List<AppNotification>> {
  NotificationNotifier() : super(_defaultNotifications());

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
  (ref) => NotificationNotifier(),
);

/// Total unread count — drives the badge in the bottom nav / app bar.
final unreadCountProvider = Provider<int>((ref) {
  return ref.watch(notificationProvider).where((n) => !n.isRead).length;
});
