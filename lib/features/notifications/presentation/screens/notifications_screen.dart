import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learn_hub/core/theme/app_theme.dart';
import '../../domain/entities/app_notification.dart';
import '../../domain/providers/notification_provider.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifications = ref.watch(notificationProvider);
    final unread = ref.watch(unreadCountProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Row(
          children: [
            Text('การแจ้งเตือน'),
            if (unread > 0) ...[
              SizedBox(width: 8.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  '$unread',
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ],
        ),
        actions: [
          if (notifications.isNotEmpty)
            TextButton(
              onPressed: () {
                ref.read(notificationProvider.notifier).markAllRead();
              },
              child: Text(
                'อ่านทั้งหมด',
                style: TextStyle(
                  fontSize: 13.sp,
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
      body: notifications.isEmpty
          ? _buildEmpty(context)
          : Column(
              children: [
                // Unread summary banner
                if (unread > 0) _buildUnreadBanner(context, unread, ref),

                // List
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.all(AppTheme.spacingMd),
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      final notification = notifications[index];
                      return _NotificationCard(
                        notification: notification,
                        onTap: () => ref
                            .read(notificationProvider.notifier)
                            .markRead(notification.id),
                        onDismiss: () => ref
                            .read(notificationProvider.notifier)
                            .dismiss(notification.id),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100.w,
            height: 100.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.veryLightGrey,
            ),
            child: Icon(
              Icons.notifications_off_rounded,
              size: 48.sp,
              color: AppTheme.lightGrey,
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            'ยังไม่มีการแจ้งเตือน',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppTheme.darkGrey,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'การแจ้งเตือนต่างๆ จะปรากฏที่นี่',
            style: TextStyle(
              fontSize: 13.sp,
              color: AppTheme.mediumGrey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUnreadBanner(BuildContext context, int unread, WidgetRef ref) {
    return Container(
      margin: EdgeInsets.fromLTRB(
          AppTheme.spacingMd, AppTheme.spacingMd, AppTheme.spacingMd, 0),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryColor.withOpacity(0.12),
            AppTheme.secondaryColor.withOpacity(0.08),
          ],
        ),
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        border: Border.all(color: AppTheme.primaryColor.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(Icons.circle_notifications_rounded,
              color: AppTheme.primaryColor, size: 20.sp),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              'คุณมี $unread การแจ้งเตือนที่ยังไม่ได้อ่าน',
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: AppTheme.primaryColor,
              ),
            ),
          ),
          GestureDetector(
            onTap: () =>
                ref.read(notificationProvider.notifier).markAllRead(),
            child: Text(
              'อ่านทั้งหมด',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
                color: AppTheme.primaryColor,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Single Notification Card
// ─────────────────────────────────────────────

class _NotificationCard extends StatelessWidget {
  final AppNotification notification;
  final VoidCallback onTap;
  final VoidCallback onDismiss;

  const _NotificationCard({
    required this.notification,
    required this.onTap,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Dismissible(
        key: Key(notification.id),
        direction: DismissDirection.endToStart,
        onDismissed: (_) => onDismiss(),
        background: Container(
          alignment: Alignment.centerRight,
          padding: EdgeInsets.only(right: 20.w),
          decoration: BoxDecoration(
            color: AppTheme.errorColor.withOpacity(0.15),
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.delete_outline_rounded,
                  color: AppTheme.errorColor, size: 24.sp),
              SizedBox(height: 4.h),
              Text(
                'ลบ',
                style: TextStyle(
                  fontSize: 11.sp,
                  color: AppTheme.errorColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        child: GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.all(14.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppTheme.radiusMd),
              color: notification.isRead
                  ? AppTheme.surfaceColor
                  : notification.color.withOpacity(0.05),
              border: notification.isRead
                  ? null
                  : Border.all(
                      color: notification.color.withOpacity(0.2),
                      width: 1,
                    ),
              boxShadow: AppTheme.softShadow,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon
                Container(
                  width: 46.w,
                  height: 46.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    color: notification.color.withOpacity(0.12),
                  ),
                  child: Icon(
                    notification.icon,
                    color: notification.color,
                    size: 22.sp,
                  ),
                ),
                SizedBox(width: 12.w),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              notification.title,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: notification.isRead
                                    ? FontWeight.w500
                                    : FontWeight.w700,
                                color: AppTheme.darkGrey,
                              ),
                            ),
                          ),
                          // Unread dot
                          if (!notification.isRead)
                            Container(
                              width: 8.w,
                              height: 8.w,
                              margin: EdgeInsets.only(left: 8.w, top: 4.h),
                              decoration: BoxDecoration(
                                color: notification.color,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        notification.message,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: AppTheme.mediumGrey,
                          height: 1.4,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        notification.timeAgo,
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: AppTheme.lightGrey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
