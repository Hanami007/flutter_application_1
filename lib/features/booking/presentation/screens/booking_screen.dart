import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../shared/constants/app_strings.dart';
import '../../../../../shared/widgets/common_widgets.dart' hide ErrorWidget;
import '../../../../../features/booking/domain/providers/booking_provider.dart';
import 'package:learn_hub/features/courses/domain/providers/course_provider.dart';

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

  String _getThaiDayName(int weekday) {
    const days = ['จันทร์', 'อังคาร', 'พุธ', 'พฤหัสบดี', 'ศุกร์', 'เสาร์', 'อาทิตย์'];
    if (weekday >= 1 && weekday <= 7) return days[weekday - 1];
    return '';
  }

  String _getThaiMonthName(int month) {
    const months = [
      'มกราคม', 'กุมภาพันธ์', 'มีนาคม', 'เมษายน', 'พฤษภาคม', 'มิถุนายน',
      'กรกฎาคม', 'สิงหาคม', 'กันยายน', 'ตุลาคม', 'พฤศจิกายน', 'ธันวาคม'
    ];
    if (month >= 1 && month <= 12) return months[month - 1];
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final branchesAsync = ref.watch(branchesProvider);
    final classSessionsAsync = ref.watch(classSessionsProvider(widget.courseId));

    // Determine if branch selection is required (if there are branches available)
    final availableBranches = branchesAsync.asData?.value ?? <dynamic>[];
    final bool isBranchRequired = availableBranches.isNotEmpty;
    const textDarkColor = Color(0xFF1A1F36);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        title: Text(
          'จองชั้นเรียน',
          style: GoogleFonts.notoSansThai(
            fontWeight: FontWeight.bold,
            fontSize: 17.sp,
            color: textDarkColor,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: textDarkColor, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Step Indicator
            _buildStepIndicator(1),
            SizedBox(height: 24.h),

            // Select Branch
            Text(
              'เลือกสาขาบริการ / Select Branch',
              style: GoogleFonts.notoSansThai(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: textDarkColor,
              ),
            ),
            SizedBox(height: 10.h),
            branchesAsync.when(
              data: (branches) => Column(
                children: branches.map((branch) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 10.h),
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

            SizedBox(height: 20.h),

            // Select Date
            Text(
              'เลือกวันที่ต้องการเข้าเรียน',
              style: GoogleFonts.notoSansThai(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: textDarkColor,
              ),
            ),
            SizedBox(height: 8.h),
            GestureDetector(
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 90)),
                  builder: (context, child) {
                    return Theme(
                      data: ThemeData(
                        colorScheme: const ColorScheme.light(
                          primary: Color(0xFF2DC9A8),
                          onPrimary: Colors.white,
                          onSurface: Color(0xFF1A1F36),
                        ),
                      ),
                      child: child!,
                    );
                  },
                );
                if (date != null) {
                  setState(() => selectedDate = date);
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 14.w,
                  vertical: 12.h,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: selectedDate != null ? const Color(0xFF2DC9A8) : const Color(0xFFE2E8F0),
                    width: selectedDate != null ? 1.5 : 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.015),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_today_rounded,
                      color: const Color(0xFF2DC9A8),
                      size: 18.sp,
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Text(
                        selectedDate != null
                            ? 'วัน${_getThaiDayName(selectedDate!.weekday)}ที่ ${selectedDate!.day} ${_getThaiMonthName(selectedDate!.month)} ${selectedDate!.year + 543}'
                            : 'กดเพื่อเลือกวันที่เรียน / Choose a date',
                        style: GoogleFonts.notoSansThai(
                          fontSize: 12.5.sp,
                          fontWeight: selectedDate != null ? FontWeight.bold : FontWeight.w500,
                          color: selectedDate != null ? const Color(0xFF1A1F36) : const Color(0xFF6E7A9A),
                        ),
                      ),
                    ),
                    Icon(
                      Icons.keyboard_arrow_right_rounded,
                      color: const Color(0xFF6E7A9A),
                      size: 18.sp,
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20.h),

            // Select Time
            Text(
              'เลือกเวลาเรียนที่ต้องการ',
              style: GoogleFonts.notoSansThai(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: textDarkColor,
              ),
            ),
            SizedBox(height: 8.h),
            GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10.w,
                mainAxisSpacing: 10.h,
                childAspectRatio: 2.3,
              ),
              itemCount: 6,
              itemBuilder: (context, index) {
                final times = ['09:00 น.', '10:00 น.', '11:00 น.', '14:00 น.', '15:00 น.', '16:00 น.'];
                final time = times[index];
                final isSelected = selectedTime == time;
                return GestureDetector(
                  onTap: () {
                    setState(() => selectedTime = time);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(
                        color: isSelected ? const Color(0xFF2DC9A8) : const Color(0xFFE2E8F0),
                        width: isSelected ? 1.5 : 1,
                      ),
                      color: isSelected ? const Color(0xFF2DC9A8) : Colors.white,
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: const Color(0xFF2DC9A8).withOpacity(0.2),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : null,
                    ),
                    child: Center(
                      child: Text(
                        time,
                        style: GoogleFonts.poppins(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : textDarkColor,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),

            SizedBox(height: 28.h),

            // Booking Summary
            _buildBookingSummary(context),

            SizedBox(height: 24.h),
          ],
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
        padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 20.h),
        child: PrimaryButton(
          text: 'ดำเนินการชำระเงิน / Proceed to Payment',
          backgroundColor: const Color(0xFF2DC9A8),
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
    const brandTeal = Color(0xFF2DC9A8);
    const textDarkColor = Color(0xFF1A1F36);
    const textMidColor = Color(0xFF6E7A9A);
    const stepTitles = ['เลือกสาขา', 'วันและเวลา', 'ชำระเงิน'];

    return Row(
      children: List.generate(3, (index) {
        final isCompleted = index + 1 < currentStep;
        final isCurrent = index + 1 == currentStep;
        final isUpcoming = index + 1 > currentStep;

        return Expanded(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 2.h,
                      color: index == 0
                          ? Colors.transparent
                          : (isCompleted || isCurrent ? brandTeal : const Color(0xFFE2E8F0)),
                    ),
                  ),
                  Container(
                    width: 32.w,
                    height: 32.w,
                    decoration: BoxDecoration(
                      color: isCompleted || isCurrent ? brandTeal : Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isCompleted || isCurrent ? brandTeal : const Color(0xFFE2E8F0),
                        width: 2,
                      ),
                      boxShadow: isCurrent
                          ? [
                              BoxShadow(
                                color: brandTeal.withOpacity(0.25),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : null,
                    ),
                    child: Center(
                      child: isCompleted
                          ? const Icon(Icons.check_rounded, color: Colors.white, size: 16)
                          : Text(
                              '${index + 1}',
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.bold,
                                color: isCurrent ? Colors.white : textMidColor,
                              ),
                            ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 2.h,
                      color: index == 2
                          ? Colors.transparent
                          : (isCompleted ? brandTeal : const Color(0xFFE2E8F0)),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 6.h),
              Text(
                stepTitles[index],
                textAlign: TextAlign.center,
                style: GoogleFonts.notoSansThai(
                  fontSize: 11.sp,
                  fontWeight: isCurrent ? FontWeight.bold : FontWeight.w500,
                  color: isCurrent ? textDarkColor : textMidColor,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildBranchCard(String name, String address, bool isSelected, VoidCallback onTap) {
    const brandTeal = Color(0xFF2DC9A8);
    const brandTealLight = Color(0xFFE6F9F5);
    const textDarkColor = Color(0xFF1A1F36);
    const textMidColor = Color(0xFF6E7A9A);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected ? brandTeal : const Color(0xFFE2E8F0),
            width: isSelected ? 1.5 : 1,
          ),
          color: isSelected ? brandTealLight.withOpacity(0.12) : Colors.white,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: brandTeal.withOpacity(0.06),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.015),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Row(
          children: [
            Container(
              width: 44.w,
              height: 44.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                color: isSelected ? brandTealLight : const Color(0xFFF1F5F9),
              ),
              child: Icon(Icons.location_on_rounded, color: brandTeal, size: 20.sp),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: GoogleFonts.notoSansThai(
                      fontSize: 13.5.sp,
                      fontWeight: FontWeight.bold,
                      color: textDarkColor,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    address,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.notoSansThai(
                      fontSize: 11.5.sp,
                      fontWeight: FontWeight.w500,
                      color: textMidColor,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle_rounded, color: brandTeal, size: 20.sp)
            else
              Icon(Icons.radio_button_unchecked_rounded, color: const Color(0xFFCBD5E0), size: 20.sp),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingSummary(BuildContext context) {
    final courseAsync = ref.watch(courseDetailsProvider(widget.courseId));
    const textDarkColor = Color(0xFF1A1F36);
    const brandTeal = Color(0xFF2DC9A8);

    String branchText = 'ไม่ได้เลือกสาขา';
    if (selectedBranch != null) {
      final branchesAsync = ref.watch(branchesProvider);
      branchesAsync.maybeWhen(
        data: (branches) {
          final b = branches.firstWhere((br) => br.id == selectedBranch, orElse: () => branches.first);
          branchText = b.name;
        },
        orElse: () {},
      );
    }

    String dateText = 'ไม่ได้เลือกวันที่';
    if (selectedDate != null) {
      dateText = '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}';
    }

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFEDF2F7), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'สรุปรายการจองเรียน / Summary',
            style: GoogleFonts.notoSansThai(
              fontSize: 13.sp,
              fontWeight: FontWeight.bold,
              color: textDarkColor,
            ),
          ),
          SizedBox(height: 12.h),
          _buildSummaryRow('สาขาเรียน / Branch', branchText, isTotal: false),
          SizedBox(height: 6.h),
          _buildSummaryRow('วันที่เรียน / Date', dateText, isTotal: false),
          SizedBox(height: 6.h),
          _buildSummaryRow('เวลาเรียน / Time', selectedTime ?? 'ไม่ได้เลือกเวลา', isTotal: false),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: const Divider(height: 1, color: Color(0xFFEDF2F7)),
          ),
          courseAsync.when(
            data: (course) => _buildSummaryRow(
              'ยอดชำระสุทธิ / Total Price',
              '฿${course.price.toStringAsFixed(0)}',
              isTotal: true,
            ),
            loading: () => _buildSummaryRow(
              'ยอดชำระสุทธิ / Total Price',
              'กำลังโหลด...',
              isTotal: true,
            ),
            error: (err, _) => _buildSummaryRow(
              'ยอดชำระสุทธิ / Total Price',
              'ข้อผิดพลาด',
              isTotal: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    const textDarkColor = Color(0xFF1A1F36);
    const textMidColor = Color(0xFF6E7A9A);
    const brandTeal = Color(0xFF2DC9A8);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.notoSansThai(
            fontSize: isTotal ? 12.5.sp : 11.5.sp,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            color: isTotal ? textDarkColor : textMidColor,
          ),
        ),
        Text(
          value,
          style: isTotal
              ? GoogleFonts.poppins(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                  color: brandTeal,
                )
              : GoogleFonts.notoSansThai(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: textDarkColor,
                ),
        ),
      ],
    );
  }
}
