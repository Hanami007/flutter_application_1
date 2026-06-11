import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learn_hub/features/booking/domain/providers/booking_provider.dart';
import 'package:learn_hub/features/enrollment/domain/providers/enrollment_provider.dart';
import 'package:learn_hub/features/auth/domain/providers/auth_provider.dart';
import 'package:learn_hub/features/courses/domain/providers/course_provider.dart';
import '../../domain/entities/booking.dart' as booking_entity;
import 'package:learn_hub/core/theme/app_theme.dart';
import '../../../../shared/constants/app_strings.dart';
import '../../../../shared/widgets/common_widgets.dart';

class BookingSuccessScreen extends ConsumerWidget {
  final String courseId;
  final Map<String, dynamic>? payload;

  const BookingSuccessScreen({
    required this.courseId,
    this.payload,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        body: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.all(AppTheme.spacingMd),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 16.h),
                // Celebratory Gradient Success Icon
                Container(
                  width: 100.w,
                  height: 100.w,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF10B981), Color(0xFF34D399)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF10B981).withOpacity(0.25),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      Icons.check_rounded,
                      size: 50.sp,
                      color: Colors.white,
                    ),
                  ),
                ),

                SizedBox(height: 20.h),

                // Success Message
                Text(
                  'สมัครเรียนสำเร็จแล้ว!',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    fontSize: 22.sp,
                    color: AppTheme.darkGrey,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 8.h),

                Text(
                  'การชำระเงินและลงทะเบียนเรียนเสร็จสมบูรณ์ ระบบได้รับการยืนยันเรียบร้อยแล้ว',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.mediumGrey,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 28.h),

                // Booking Details (Ticket receipt card)
                _buildDetailsCard(context, ref),

                SizedBox(height: 24.h),

                // Next Steps Card
                _buildNextSteps(context),

                SizedBox(height: 24.h),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 20.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              PrimaryButton(
                text: 'ดูรายการจองของฉัน / View Bookings',
                onPressed: () => context.go('/home/schedule'),
              ),
              SizedBox(height: 10.h),
              OutlineButton(
                text: 'เลือกซื้อคอร์สเรียนเพิ่ม / Browse Courses',
                onPressed: () => context.go('/home/courses'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailsCard(BuildContext context, WidgetRef ref) {
    // Try payload booking first
    final payloadBooking = payload != null ? payload!['booking'] as booking_entity.Booking? : null;
    final userId = ref.watch(currentUserIdProvider);
    final courseAsync = ref.watch(courseDetailsProvider(courseId));

    final courseName = courseAsync.maybeWhen(
      data: (course) => course.name,
      orElse: () => 'Loading...',
    );

    final amountPaid = courseAsync.maybeWhen(
      data: (course) => '฿${course.price.toStringAsFixed(0)}',
      orElse: () => 'Loading...',
    );

    String bookingId = 'N/A';
    String branchName = 'Online';
    String dateStr = 'Not specified';
    String timeStr = 'Not specified';

    if (payloadBooking != null) {
      bookingId = payloadBooking.id;
      final branchId = payload!['branchId'] as String?;
      final dateIso = payload!['date'] as String?;
      timeStr = payload!['time'] as String? ?? 'Not specified';
      final dateParsed = dateIso != null ? DateTime.parse(dateIso) : null;
      if (dateParsed != null) {
        dateStr = '${dateParsed.day}/${dateParsed.month}/${dateParsed.year}';
      }

      final branchesAsync = ref.watch(branchesProvider);
      if (branchId != null) {
        branchesAsync.maybeWhen(
          data: (branches) {
            final b = branches.firstWhere(
              (br) => br.id == branchId,
              orElse: () => branches.isNotEmpty ? branches.first : booking_entity.Branch(id: '0', name: 'Branch', address: '', city: '', state: ''),
            );
            branchName = b.name;
          },
          orElse: () {},
        );
      }
    } else {
      // Fallback: fetch user's bookings and show the latest one
      final bookingsAsync = ref.watch(userBookingsProvider(userId));
      return bookingsAsync.when(
        data: (bookings) {
          if (bookings.isEmpty) {
            return const SizedBox.shrink();
          }
          final b = bookings.last;
          bookingId = b.id;
          if (b.bookingDate != null) {
            dateStr = '${b.bookingDate!.day}/${b.bookingDate!.month}/${b.bookingDate!.year}';
          }
          return _ticketLayout(context, bookingId, courseName, branchName, dateStr, timeStr, amountPaid);
        },
        loading: () => LoadingWidget(),
        error: (e, s) => Text('Error: $e'),
      );
    }

    return _ticketLayout(context, bookingId, courseName, branchName, dateStr, timeStr, amountPaid);
  }

  Widget _ticketLayout(
    BuildContext context,
    String bookingId,
    String courseName,
    String branchName,
    String dateStr,
    String timeStr,
    String amountPaid,
  ) {
    return Stack(
      children: [
        // Main Ticket Container
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.015),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Part of Ticket
              Padding(
                padding: EdgeInsets.fromLTRB(18.w, 18.h, 18.w, 14.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'ใบเสร็จการจองคอร์ส / Receipt',
                          style: TextStyle(
                            fontSize: 12.5.sp,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                          decoration: BoxDecoration(
                            color: AppTheme.successColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          child: Text(
                            'ชำระสำเร็จ',
                            style: TextStyle(
                              fontSize: 9.sp,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.successColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 14.h),
                    _buildDetailRow('หมายเลขการจอง (Booking ID)', '#$bookingId'),
                    _buildDetailRow('คอร์สเรียน (Course)', courseName),
                    _buildDetailRow('ผู้ดูแล (Instructor)', 'Lumina Learn'),
                  ],
                ),
              ),

              // Dashed Separator
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 18.w),
                child: const TicketSeparator(),
              ),

              // Bottom Part of Ticket
              Padding(
                padding: EdgeInsets.fromLTRB(18.w, 14.h, 18.w, 18.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow('สาขาที่เรียน (Branch)', branchName),
                    _buildDetailRow('วันที่เรียน (Date)', dateStr),
                    _buildDetailRow('เวลาเรียน (Time)', timeStr),
                    SizedBox(height: 8.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'ยอดชำระสุทธิ (Amount Paid)',
                          style: TextStyle(
                            fontSize: 12.5.sp,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.darkGrey,
                          ),
                        ),
                        Text(
                          amountPaid,
                          style: TextStyle(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.successColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Left Notch Cutout
        Positioned(
          left: -10.w,
          top: 130.h, // Aligned with separator
          child: Container(
            width: 20.w,
            height: 20.w,
            decoration: const BoxDecoration(
              color: AppTheme.backgroundColor,
              shape: BoxShape.circle,
            ),
          ),
        ),

        // Right Notch Cutout
        Positioned(
          right: -10.w,
          top: 130.h, // Aligned with separator
          child: Container(
            width: 20.w,
            height: 20.w,
            decoration: const BoxDecoration(
              color: AppTheme.backgroundColor,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 5,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: AppTheme.mediumGrey,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            flex: 5,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: AppTheme.darkGrey,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNextSteps(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: const Color(0xFFEDF2F7),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.015),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ขั้นตอนถัดไป / Next Steps',
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.bold,
              color: AppTheme.darkGrey,
            ),
          ),
          SizedBox(height: 12.h),
          _buildStepItem(
            icon: Icons.mail_outline_rounded,
            color: const Color(0xFF3B82F6),
            title: 'ตรวจสอบกล่องจดหมายอีเมล',
            subtitle: 'รับรายละเอียดการจองคอร์สและใบเสร็จการชำระเงิน',
          ),
          SizedBox(height: 10.h),
          _buildStepItem(
            icon: Icons.calendar_month_rounded,
            color: const Color(0xFF10B981),
            title: 'เข้าเรียนตามเวลาการจอง',
            subtitle: 'เปิดเรียนตามเวลา ณ สาขาที่คุณได้ทำการลงทะเบียนไว้',
          ),
          SizedBox(height: 10.h),
          _buildStepItem(
            icon: Icons.emoji_events_rounded,
            color: const Color(0xFFF59E0B),
            title: 'รับใบประกาศนียบัตรเมื่อเรียนจบ',
            subtitle: 'สะสมบทเรียนเพื่อรับใบรับรองจบหลักสูตรอย่างเป็นทางการ',
          ),
        ],
      ),
    );
  }

  Widget _buildStepItem({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(6.w),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 16.sp, color: color),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.darkGrey,
                ),
              ),
              SizedBox(height: 1.h),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.mediumGrey,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class TicketSeparator extends StatelessWidget {
  final double height;
  final Color color;

  const TicketSeparator({
    this.height = 1,
    this.color = const Color(0xFFE2E8F0),
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        const dashWidth = 6.0;
        final dashHeight = height;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(color: color),
              ),
            );
          }),
        );
      },
    );
  }
}
