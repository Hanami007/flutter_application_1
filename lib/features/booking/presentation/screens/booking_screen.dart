import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../shared/constants/app_strings.dart';
import '../../../../../shared/widgets/common_widgets.dart' hide ErrorWidget;
import '../../../../../features/booking/domain/providers/booking_provider.dart';

class BookingScreen extends ConsumerStatefulWidget {
  final String courseId;

  const BookingScreen({
    required this.courseId,
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends ConsumerState<BookingScreen> {
  String? selectedBranch;
  DateTime? selectedDate;
  String? selectedTime;

  @override
  Widget build(BuildContext context) {
    final branchesAsync = ref.watch(branchesProvider);
    final classSessionsAsync = ref.watch(classSessionsProvider(widget.courseId));

    // Determine if branch selection is required (if there are branches available)
    final availableBranches = branchesAsync.asData?.value ?? <dynamic>[];
    final bool isBranchRequired = availableBranches.isNotEmpty;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(AppStrings.bookClass),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppTheme.spacingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Step Indicator
            _buildStepIndicator(1),
            SizedBox(height: 24.h),

            // Select Branch
            Text(
              AppStrings.selectBranch,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 12.h),
            branchesAsync.when(
              data: (branches) => Column(
                children: branches.map((branch) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 12.h),
                    child: _buildBranchCard(
                      branch.name,
                      branch.address,
                      selectedBranch == branch.id,
                      () {
                        setState(() => selectedBranch = branch.id);
                      },
                    ),
                  );
                }).toList(),
              ),
              loading: () => LoadingWidget(),
              error: (error, stack) => Text(error.toString()),
            ),

            SizedBox(height: 24.h),

            // Select Date
            Text(
              AppStrings.selectDate,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 12.h),
            GestureDetector(
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(Duration(days: 90)),
                );
                if (date != null) {
                  setState(() => selectedDate = date);
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 12.h,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                  border: Border.all(
                    color: selectedDate != null ? AppTheme.primaryColor : AppTheme.lightGrey,
                    width: 2,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      color: AppTheme.primaryColor,
                    ),
                    SizedBox(width: 12.w),
                    Text(
                      selectedDate != null
                          ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
                          : 'Pick a date',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: selectedDate != null ? AppTheme.darkGrey : AppTheme.mediumGrey,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 24.h),

            // Select Time
            Text(
              AppStrings.selectTime,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 12.h),
            GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12.w,
                mainAxisSpacing: 12.h,
                childAspectRatio: 2,
              ),
              itemCount: 6,
              itemBuilder: (context, index) {
                final times = ['9:00 AM', '10:00 AM', '11:00 AM', '2:00 PM', '3:00 PM', '4:00 PM'];
                final time = times[index];
                return GestureDetector(
                  onTap: () {
                    setState(() => selectedTime = time);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                      color: selectedTime == time ? AppTheme.primaryColor : AppTheme.veryLightGrey,
                    ),
                    child: Center(
                      child: Text(
                        time,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: selectedTime == time ? Colors.white : AppTheme.darkGrey,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),

            SizedBox(height: 32.h),

            // Booking Summary
            _buildBookingSummary(context),

            SizedBox(height: 32.h),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(AppTheme.spacingMd),
          child: PrimaryButton(
          text: 'Proceed to Payment',
          isDisabled: (isBranchRequired && selectedBranch == null) || selectedDate == null || selectedTime == null,
          onPressed: () {
            // Pass selected booking details to the payment screen via `extra`.
            context.go(
              '/home/booking/${widget.courseId}/payment',
              extra: {
                'branchId': selectedBranch,
                'date': selectedDate?.toIso8601String(),
                'time': selectedTime,
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildStepIndicator(int currentStep) {
    return Row(
      children: List.generate(3, (index) {
        return Expanded(
          child: Column(
            children: [
              Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: index + 1 <= currentStep ? AppTheme.primaryColor : AppTheme.lightGrey,
                ),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: index + 1 <= currentStep ? Colors.white : AppTheme.mediumGrey,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                ['Branch', 'Date & Time', 'Payment'][index],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.darkGrey,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildBranchCard(String name, String address, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          border: Border.all(
            color: isSelected ? AppTheme.primaryColor : AppTheme.lightGrey,
            width: 2,
          ),
          color: isSelected ? AppTheme.primaryColor.withOpacity(0.05) : Colors.transparent,
        ),
        child: Row(
          children: [
            Container(
              width: 50.w,
              height: 50.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                color: AppTheme.veryLightGrey,
              ),
              child: Icon(Icons.location_on, color: AppTheme.primaryColor),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.darkGrey,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    address,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: AppTheme.mediumGrey,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: AppTheme.primaryColor),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingSummary(BuildContext context) {
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
            'Booking Summary',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(height: 12.h),
          _buildSummaryRow('Branch', selectedBranch ?? 'Not selected'),
          _buildSummaryRow('Date', selectedDate != null ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}' : 'Not selected'),
          _buildSummaryRow('Time', selectedTime ?? 'Not selected'),
          Divider(height: 16.h),
          _buildSummaryRow('Total Price', '₹5,999', isTotal: true),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 14.sp : 13.sp,
              fontWeight: isTotal ? FontWeight.w600 : FontWeight.w500,
              color: AppTheme.mediumGrey,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 16.sp : 14.sp,
              fontWeight: isTotal ? FontWeight.w700 : FontWeight.w600,
              color: isTotal ? AppTheme.primaryColor : AppTheme.darkGrey,
            ),
          ),
        ],
      ),
    );
  }
}
