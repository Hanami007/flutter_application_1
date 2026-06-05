import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learn_hub/features/booking/domain/providers/booking_provider.dart';
import 'package:learn_hub/features/auth/domain/providers/auth_provider.dart';
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
            padding: EdgeInsets.all(AppTheme.spacingMd),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Success Icon
                Container(
                  width: 120.w,
                  height: 120.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.successColor.withOpacity(0.1),
                  ),
                  child: Icon(
                    Icons.check_circle,
                    size: 60.sp,
                    color: AppTheme.successColor,
                  ),
                ),

                SizedBox(height: 24.h),

                // Success Message
                Text(
                  AppStrings.bookingSuccess,
                  style: Theme.of(context).textTheme.displaySmall,
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 12.h),

                Text(
                  AppStrings.bookingSuccessMessage,
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 32.h),

                // Booking Details
                _buildDetailsCard(context, ref),

                SizedBox(height: 32.h),

                // Next Steps
                _buildNextSteps(context),

                SizedBox(height: 40.h),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.all(AppTheme.spacingMd),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              PrimaryButton(
                text: 'View My Bookings',
                onPressed: () => context.go('/home/schedule'),
              ),
              SizedBox(height: 12.h),
              OutlineButton(
                text: 'Continue Shopping',
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
    final currentUser = ref.watch(currentUserProvider);
    final userId = currentUser?.id ?? '1';

    if (payloadBooking != null) {
      final branchId = payload!['branchId'] as String?;
      final dateIso = payload!['date'] as String?;
      final time = payload!['time'] as String?;
      final dateStr = dateIso != null ? DateTime.parse(dateIso) : null;

      final branchesAsync = ref.watch(branchesProvider);
      String branchName = 'Online';
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

      return Container(
        padding: EdgeInsets.all(AppTheme.spacingMd),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          color: AppTheme.surfaceColor,
          boxShadow: AppTheme.softShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Booking Details',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 16.h),
            _buildDetailRow('Booking ID', '#${payloadBooking.id}'),
            _buildDetailRow('Course', courseId),
            _buildDetailRow('Instructor', 'Instructor'),
            _buildDetailRow('Branch', branchName),
            _buildDetailRow('Date', dateStr != null ? '${dateStr.day} ${dateStr.month} ${dateStr.year}' : 'Not specified'),
            _buildDetailRow('Time', time ?? 'Not specified'),
            _buildDetailRow('Amount Paid', '₹5,999'),
          ],
        ),
      );
    }

    // Fallback: fetch user's bookings and show the latest one
    final bookingsAsync = ref.watch(userBookingsProvider(userId));
    return bookingsAsync.when(
      data: (bookings) {
        if (bookings.isEmpty) {
          return Container(
            padding: EdgeInsets.all(AppTheme.spacingMd),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppTheme.radiusMd),
              color: AppTheme.surfaceColor,
              boxShadow: AppTheme.softShadow,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Booking Details', style: Theme.of(context).textTheme.titleMedium),
                SizedBox(height: 16.h),
                Text('No booking data available'),
              ],
            ),
          );
        }
        final b = bookings.last;
        return Container(
          padding: EdgeInsets.all(AppTheme.spacingMd),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            color: AppTheme.surfaceColor,
            boxShadow: AppTheme.softShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Booking Details', style: Theme.of(context).textTheme.titleMedium),
              SizedBox(height: 16.h),
              _buildDetailRow('Booking ID', '#${b.id}'),
              _buildDetailRow('Course', courseId),
              _buildDetailRow('Instructor', 'Instructor'),
              _buildDetailRow('Branch', 'Online'),
              _buildDetailRow('Date', b.bookingDate != null ? '${b.bookingDate!.day}/${b.bookingDate!.month}/${b.bookingDate!.year}' : 'Not specified'),
              _buildDetailRow('Time', '-'),
              _buildDetailRow('Amount Paid', '₹5,999'),
            ],
          ),
        );
      },
      loading: () => LoadingWidget(),
      error: (e, s) => Text('Error: $e'),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                color: AppTheme.mediumGrey,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(width: 12.w),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: AppTheme.darkGrey,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNextSteps(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppTheme.spacingMd),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        color: AppTheme.primaryColor.withOpacity(0.05),
        border: Border.all(
          color: AppTheme.primaryColor.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Next Steps',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(height: 12.h),
          _buildStepItem('1', 'Check your email for confirmation'),
          _buildStepItem('2', 'Join the class on scheduled date and time'),
          _buildStepItem('3', 'Start learning and complete the course'),
        ],
      ),
    );
  }

  Widget _buildStepItem(String number, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        children: [
          Container(
            width: 28.w,
            height: 28.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.primaryColor,
            ),
            child: Center(
              child: Text(
                number,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                color: AppTheme.darkGrey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
