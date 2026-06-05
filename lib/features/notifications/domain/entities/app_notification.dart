import 'package:flutter/material.dart';
import 'package:learn_hub/core/theme/app_theme.dart';

enum NotificationType {
  paymentSuccess,
  enrollmentConfirmed,
  classReminder,
  newCourse,
  courseCompleted,
  system,
}

class AppNotification {
  final String id;
  final String title;
  final String message;
  final NotificationType type;
  final DateTime createdAt;
  bool isRead;

  AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.createdAt,
    this.isRead = false,
  });

  // ── Derived UI properties ──────────────────────────────────────────────

  IconData get icon {
    switch (type) {
      case NotificationType.paymentSuccess:
        return Icons.payment_rounded;
      case NotificationType.enrollmentConfirmed:
        return Icons.verified_rounded;
      case NotificationType.classReminder:
        return Icons.alarm_rounded;
      case NotificationType.newCourse:
        return Icons.school_rounded;
      case NotificationType.courseCompleted:
        return Icons.emoji_events_rounded;
      case NotificationType.system:
        return Icons.notifications_rounded;
    }
  }

  Color get color {
    switch (type) {
      case NotificationType.paymentSuccess:
        return AppTheme.successColor;
      case NotificationType.enrollmentConfirmed:
        return AppTheme.successColor;
      case NotificationType.classReminder:
        return AppTheme.primaryColor;
      case NotificationType.newCourse:
        return AppTheme.secondaryColor;
      case NotificationType.courseCompleted:
        return const Color(0xFFF59E0B);
      case NotificationType.system:
        return AppTheme.mediumGrey;
    }
  }

  String get timeAgo {
    final diff = DateTime.now().difference(createdAt);
    if (diff.inSeconds < 60) return 'เมื่อกี้';
    if (diff.inMinutes < 60) return '${diff.inMinutes} นาทีที่แล้ว';
    if (diff.inHours < 24) return '${diff.inHours} ชั่วโมงที่แล้ว';
    if (diff.inDays == 1) return 'เมื่อวาน';
    return '${diff.inDays} วันที่แล้ว';
  }

  // ── Factory constructors for common events ────────────────────────────

  factory AppNotification.paymentSuccess({
    required String courseName,
    required double amount,
  }) {
    return AppNotification(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: '✅ ชำระเงินสำเร็จ',
      message: 'ชำระเงิน ฿${amount.toStringAsFixed(0)} สำหรับคอส "$courseName" เรียบร้อยแล้ว',
      type: NotificationType.paymentSuccess,
      createdAt: DateTime.now(),
    );
  }

  factory AppNotification.enrollmentConfirmed({required String courseName}) {
    return AppNotification(
      id: '${DateTime.now().millisecondsSinceEpoch}_enroll',
      title: '🎓 ลงทะเบียนสำเร็จ',
      message: 'คุณได้รับสิทธิ์เรียน "$courseName" แล้ว เริ่มเรียนได้เลย!',
      type: NotificationType.enrollmentConfirmed,
      createdAt: DateTime.now(),
    );
  }

  factory AppNotification.courseCompleted({required String courseName}) {
    return AppNotification(
      id: '${DateTime.now().millisecondsSinceEpoch}_complete',
      title: '🏆 เรียนจบแล้ว!',
      message: 'ยินดีด้วย! คุณเรียนจบคอส "$courseName" เรียบร้อยแล้ว',
      type: NotificationType.courseCompleted,
      createdAt: DateTime.now(),
    );
  }

  factory AppNotification.classReminder({
    required String courseName,
    required String time,
  }) {
    return AppNotification(
      id: '${DateTime.now().millisecondsSinceEpoch}_reminder',
      title: '⏰ เตือนความจำ',
      message: 'คลาส "$courseName" จะเริ่มใน $time',
      type: NotificationType.classReminder,
      createdAt: DateTime.now(),
    );
  }

  factory AppNotification.newCourse({required String courseName}) {
    return AppNotification(
      id: '${DateTime.now().millisecondsSinceEpoch}_new',
      title: '🆕 คอสใหม่มาแล้ว!',
      message: '"$courseName" พร้อมให้เรียนแล้ว สมัครได้เลย',
      type: NotificationType.newCourse,
      createdAt: DateTime.now(),
    );
  }
}
