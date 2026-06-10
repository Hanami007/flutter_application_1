import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/entities/app_notification.dart';
import '../../domain/providers/notification_provider.dart';

class NotificationDropdownButton extends ConsumerStatefulWidget {
  const NotificationDropdownButton({super.key});

  @override
  ConsumerState<NotificationDropdownButton> createState() =>
      _NotificationDropdownButtonState();
}

class _NotificationDropdownButtonState
    extends ConsumerState<NotificationDropdownButton> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;

  void _toggleDropdown() {
    if (_isOpen) {
      _closeDropdown();
    } else {
      _showDropdown();
    }
  }

  void _showDropdown() {
    final overlay = Overlay.of(context);
    _overlayEntry = _createOverlayEntry();
    overlay.insert(_overlayEntry!);
    setState(() {
      _isOpen = true;
    });
  }

  void _closeDropdown() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
      if (mounted) {
        setState(() {
          _isOpen = false;
        });
      }
    }
  }

  OverlayEntry _createOverlayEntry() {
    return OverlayEntry(
      builder: (context) => Stack(
        children: [
          // Fullscreen transparent barrier to dismiss popup when clicking outside
          GestureDetector(
            onTap: _closeDropdown,
            behavior: HitTestBehavior.translucent,
            child: Container(
              color: Colors.transparent,
            ),
          ),
          Positioned(
            width: 320.w,
            child: CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: Offset(-282.w, 44.h), // Align the right edge of dropdown with the right edge of button
              child: Material(
                elevation: 12,
                shadowColor: Colors.black.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(16.r),
                color: Colors.white,
                clipBehavior: Clip.antiAlias,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(
                      color: const Color(0xFF2DC9A8).withValues(alpha: 0.12),
                      width: 1,
                    ),
                  ),
                  child: _DropdownContent(
                    onClose: _closeDropdown,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _closeDropdown();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final unread = ref.watch(unreadCountProvider);
    const textDark = Color(0xFF1A1F36);

    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: _toggleDropdown,
        child: Container(
          width: 38.w,
          height: 38.w,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.07),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(
                _isOpen ? Icons.notifications : Icons.notifications_outlined,
                color: _isOpen ? const Color(0xFF2DC9A8) : textDark,
                size: 20.sp,
              ),
              if (unread > 0)
                Positioned(
                  top: 8.h,
                  right: 8.w,
                  child: Container(
                    width: 7.w,
                    height: 7.w,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFF4B4B),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DropdownContent extends ConsumerWidget {
  final VoidCallback onClose;

  const _DropdownContent({required this.onClose});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifications = ref.watch(notificationProvider);
    final unread = ref.watch(unreadCountProvider);

    const textDark = Color(0xFF1A1F36);
    const textMid = Color(0xFF6E7A9A);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Header Section
        Padding(
          padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 12.h),
          child: Row(
            children: [
              Text(
                'การแจ้งเตือน',
                style: GoogleFonts.notoSansThai(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: textDark,
                ),
              ),
              if (unread > 0) ...[
                SizedBox(width: 6.w),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF4B4B),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Text(
                    '$unread',
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        const Divider(height: 1, color: Color(0xFFEDF2F7)),

        // Notification List Section
        Container(
          constraints: BoxConstraints(maxHeight: 350.h),
          child: notifications.isEmpty
              ? _buildEmptyState(textMid)
              : ListView.separated(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(vertical: 4.h),
                  itemCount: notifications.length,
                  separatorBuilder: (context, index) =>
                      const Divider(height: 1, color: Color(0xFFF7F9FC)),
                  itemBuilder: (context, index) {
                    final notification = notifications[index];
                    return _NotificationDropdownItem(
                      notification: notification,
                      onTap: () {
                        ref
                            .read(notificationProvider.notifier)
                            .markRead(notification.id);
                      },
                      onDismiss: () {
                        ref
                            .read(notificationProvider.notifier)
                            .dismiss(notification.id);
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(Color textMid) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 40.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: const BoxDecoration(
              color: Color(0xFFF7F9FC),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.notifications_off_outlined,
              size: 32.sp,
              color: const Color(0xFFA0AEC0),
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            'ไม่มีการแจ้งเตือนใหม่',
            style: GoogleFonts.notoSansThai(
              fontSize: 12.sp,
              color: textMid,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationDropdownItem extends StatelessWidget {
  final AppNotification notification;
  final VoidCallback onTap;
  final VoidCallback onDismiss;

  const _NotificationDropdownItem({
    required this.notification,
    required this.onTap,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    const textDark = Color(0xFF1A1F36);
    const textMid = Color(0xFF6E7A9A);

    return InkWell(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        color: notification.isRead
            ? Colors.white
            : notification.color.withValues(alpha: 0.04),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Leading Icon
            Container(
              width: 36.w,
              height: 36.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: notification.color.withValues(alpha: 0.12),
              ),
              child: Icon(
                notification.icon,
                color: notification.color,
                size: 18.sp,
              ),
            ),
            SizedBox(width: 10.w),

            // Content Column
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          style: GoogleFonts.notoSansThai(
                            fontSize: 12.sp,
                            fontWeight: notification.isRead
                                ? FontWeight.w500
                                : FontWeight.w700,
                            color: textDark,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (!notification.isRead) ...[
                        SizedBox(width: 6.w),
                        Container(
                          width: 6.w,
                          height: 6.w,
                          margin: EdgeInsets.only(top: 4.h),
                          decoration: BoxDecoration(
                            color: notification.color,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ],
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    notification.message,
                    style: GoogleFonts.notoSansThai(
                      fontSize: 11.sp,
                      color: textMid,
                      height: 1.35,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    notification.timeAgo,
                    style: GoogleFonts.poppins(
                      fontSize: 9.sp,
                      color: const Color(0xFFA0AEC0),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            // Dismiss Button
            SizedBox(width: 6.w),
            GestureDetector(
              onTap: onDismiss,
              child: Container(
                padding: EdgeInsets.all(4.w),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.close_rounded,
                  size: 14.sp,
                  color: const Color(0xFFA0AEC0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
