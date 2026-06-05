import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:learn_hub/core/theme/app_theme.dart';
import 'package:learn_hub/shared/constants/app_strings.dart';
import 'package:learn_hub/shared/widgets/common_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../booking/domain/providers/booking_provider.dart';
import '../../../auth/domain/providers/auth_provider.dart';
import '../../../enrollment/domain/providers/enrollment_provider.dart';

class PaymentScreen extends ConsumerStatefulWidget {
  final String courseId;
  final Map<String, dynamic>? bookingExtras;

  const PaymentScreen({
    required this.courseId,
    this.bookingExtras,
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  String selectedPaymentMethod = 'card';
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(AppStrings.payment),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppTheme.spacingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Summary
            _buildOrderSummary(context),

            SizedBox(height: 24.h),

            // Payment Methods
            Text(
              AppStrings.paymentMethod,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 12.h),

            _buildPaymentMethodOption(
              'Card Payment',
              Icons.credit_card,
              'card',
            ),
            SizedBox(height: 12.h),
            _buildPaymentMethodOption(
              'UPI',
              Icons.payment,
              'upi',
            ),
            SizedBox(height: 12.h),
            _buildPaymentMethodOption(
              'Wallet',
              Icons.account_balance_wallet,
              'wallet',
            ),

            SizedBox(height: 24.h),

            // Card Details (if card is selected)
            if (selectedPaymentMethod == 'card')
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.cardDetails,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  SizedBox(height: 12.h),
                  TextInputField(
                    label: 'Card Number',
                    hint: '1234 5678 9012 3456',
                    prefixIcon: Icon(Icons.credit_card),
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    children: [
                      Expanded(
                        child: TextInputField(
                          label: 'Expiry Date',
                          hint: 'MM/YY',
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: TextInputField(
                          label: 'CVV',
                          hint: '***',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  TextInputField(
                    label: 'Cardholder Name',
                    hint: 'John Doe',
                  ),
                  SizedBox(height: 24.h),
                ],
              ),

            // Terms & Conditions
            Row(
              children: [
                Checkbox(
                  value: true,
                  onChanged: (_) {},
                ),
                Expanded(
                  child: Text(
                    'I agree to the terms and conditions',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),

            SizedBox(height: 32.h),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(AppTheme.spacingMd),
        child: PrimaryButton(
          text: 'Pay ₹5,999',
          isLoading: _isProcessing,
          onPressed: () async {
            setState(() => _isProcessing = true);

            // Simulate payment processing
            await Future.delayed(const Duration(seconds: 2));

            // 1. Create enrollment record (course purchase)
            final enrollmentCreated = await ref
                .read(purchaseCourseProvider.notifier)
                .purchase(widget.courseId);

            // 2. Create booking record (session booking)
            final repository = ref.read(bookingRepositoryProvider);
            final currentUser = ref.read(currentUserProvider);
            final userId = currentUser?.id ?? '1';
            final bookingReq = BookingRequest(
              userId: userId,
              courseId: widget.courseId,
              branchId: widget.bookingExtras?['branchId'],
              dateIso: widget.bookingExtras?['date'],
              time: widget.bookingExtras?['time'],
            );
            final booking = await repository.createBooking(bookingReq);

            if (mounted) {
              // Navigate to success and pass booking info + original extras
              context.go(
                '/home/booking/${widget.courseId}/success',
                extra: {
                  'booking': booking,
                  'branchId': widget.bookingExtras?['branchId'],
                  'date': widget.bookingExtras?['date'],
                  'time': widget.bookingExtras?['time'],
                  'enrolled': enrollmentCreated,
                },
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildOrderSummary(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppTheme.spacingMd),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        color: AppTheme.veryLightGrey,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Summary',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Flutter Basics Course',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              Flexible(
                flex: 0,
                child: Text(
                  '₹4,999',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.darkGrey,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Tax (18%)',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              Flexible(
                flex: 0,
                child: Text(
                  '₹900',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.darkGrey,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Discount',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              Flexible(
                flex: 0,
                child: Text(
                  '-₹900',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.successColor,
                  ),
                ),
              ),
            ],
          ),
          Divider(height: 16.h),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Total Amount',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.darkGrey,
                  ),
                ),
              ),
              Flexible(
                flex: 0,
                child: Text(
                  '₹5,999',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodOption(String title, IconData icon, String value) {
    return GestureDetector(
      onTap: () {
        setState(() => selectedPaymentMethod = value);
      },
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          border: Border.all(
            color: selectedPaymentMethod == value ? AppTheme.primaryColor : AppTheme.lightGrey,
            width: 2,
          ),
          color: selectedPaymentMethod == value ? AppTheme.primaryColor.withOpacity(0.05) : Colors.transparent,
        ),
        child: Row(
          children: [
            Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                color: AppTheme.veryLightGrey,
              ),
              child: Icon(icon, color: AppTheme.primaryColor),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.darkGrey,
                ),
              ),
            ),
            Radio<String>(
              value: value,
              groupValue: selectedPaymentMethod,
              onChanged: (val) {
                setState(() => selectedPaymentMethod = val!);
              },
            ),
          ],
        ),
      ),
    );
  }
}
