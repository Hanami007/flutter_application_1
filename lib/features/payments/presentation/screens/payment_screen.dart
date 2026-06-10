import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:learn_hub/core/theme/app_theme.dart';
import 'package:learn_hub/shared/widgets/common_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase_core;
import '../../../booking/domain/providers/booking_provider.dart';
import '../../../enrollment/domain/providers/enrollment_provider.dart';
import '../../../notifications/domain/entities/app_notification.dart';
import '../../../notifications/domain/providers/notification_provider.dart';
import '../../../courses/domain/providers/course_provider.dart';
import '../../../courses/domain/entities/course.dart';

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
  String selectedPaymentMethod = 'qr_scan';
  bool _isProcessing = false;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _senderNameController = TextEditingController();
  final TextEditingController _transactionIdController = TextEditingController();
  final TextEditingController _transferDateTimeController = TextEditingController();

  XFile? _slipImage;
  Uint8List? _slipImageBytes;
  final ImagePicker _picker = ImagePicker();
  bool _showSlipError = false;

  @override
  void dispose() {
    _senderNameController.dispose();
    _transactionIdController.dispose();
    _transferDateTimeController.dispose();
    super.dispose();
  }

  Future<void> _pickSlip() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        final bytes = await image.readAsBytes();
        setState(() {
          _slipImage = image;
          _slipImageBytes = bytes;
          _showSlipError = false;
        });
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2025),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
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
    if (pickedDate != null) {
      if (!mounted) return;
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
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
      if (pickedTime != null) {
        final DateTime fullDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        final String formatted = "${fullDateTime.day.toString().padLeft(2, '0')}/${fullDateTime.month.toString().padLeft(2, '0')}/${fullDateTime.year} ${fullDateTime.hour.toString().padLeft(2, '0')}:${fullDateTime.minute.toString().padLeft(2, '0')}";
        setState(() {
          _transferDateTimeController.text = formatted;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final courseAsync = ref.watch(courseDetailsProvider(widget.courseId));
    const textDarkColor = Color(0xFF1A1F36);
    const brandTeal = Color(0xFF2DC9A8);

    return courseAsync.when(
      data: (course) {
        final courseName = course.name;
        final coursePrice = course.price;
        
        // VAT 7% Calculation (inclusive)
        final basePrice = coursePrice / 1.07;
        final vat = coursePrice - basePrice;

        return Scaffold(
          backgroundColor: const Color(0xFFF7F9FC),
          appBar: AppBar(
            title: Text(
              'ชำระเงิน',
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
                // Order Summary Card
                _buildOrderSummary(context, course, basePrice, vat, coursePrice),

                SizedBox(height: 16.h),

                // Payment Methods Label
                Text(
                  'วิธีการชำระเงิน',
                  style: GoogleFonts.notoSansThai(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: textDarkColor,
                  ),
                ),
                SizedBox(height: 8.h),

                _buildPaymentMethodOption(
                  'สแกน QR Code / พร้อมเพย์',
                  Icons.qr_code_scanner_rounded,
                  'qr_scan',
                ),

                SizedBox(height: 14.h),

                if (selectedPaymentMethod == 'qr_scan') ...[
                  _buildPromptPayQRCodeCard(context, coursePrice),
                  SizedBox(height: 14.h),
                  _buildPaymentProofForm(context),
                  SizedBox(height: 12.h),
                ],

                // Terms & Conditions Checkbox
                Row(
                  children: [
                    Transform.scale(
                      scale: 0.85,
                      child: Checkbox(
                        value: true,
                        activeColor: brandTeal,
                        onChanged: (_) {},
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: VisualDensity.compact,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: Text(
                        'ฉันยอมรับเงื่อนไขและข้อกำหนดในการซื้อคอร์สเรียน',
                        style: GoogleFonts.notoSansThai(
                          fontSize: 11.sp,
                          color: const Color(0xFF6E7A9A),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 24.h),
              ],
            ),
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 20.h),
            child: PrimaryButton(
              text: 'ยืนยันการชำระเงิน ฿${coursePrice.toStringAsFixed(0)}',
              isLoading: _isProcessing,
              backgroundColor: brandTeal,
              onPressed: () async {
                if (_formKey.currentState == null || !_formKey.currentState!.validate()) {
                  if (_slipImage == null) {
                    setState(() {
                      _showSlipError = true;
                    });
                  }
                  return;
                }
                if (_slipImage == null) {
                  setState(() {
                    _showSlipError = true;
                  });
                  return;
                }

                setState(() => _isProcessing = true);

                // 1. Upload transfer slip
                String? slipUrl;
                try {
                  if (_slipImageBytes != null && _slipImage != null) {
                    final client = supabase_core.Supabase.instance.client;
                    final fileExt = _slipImage!.name.split('.').lastOrNull ?? 'jpg';
                    final fileName = 'slip_${DateTime.now().millisecondsSinceEpoch}.$fileExt';
                    final userId = ref.read(currentUserIdProvider);
                    final filePath = '$userId/$fileName';

                    debugPrint('Uploading slip to storage: $filePath');
                    await client.storage.from('payment-slips').uploadBinary(
                          filePath,
                          _slipImageBytes!,
                          fileOptions: const supabase_core.FileOptions(upsert: true),
                        );

                    final responseUrl = client.storage.from('payment-slips').getPublicUrl(filePath);
                    slipUrl = responseUrl;
                    debugPrint('Uploaded slip successfully: $slipUrl');
                  }
                } catch (e) {
                  debugPrint('Failed to upload slip to Supabase storage: $e');
                }

                // Simulate payment processing delay
                await Future.delayed(const Duration(seconds: 1));

                // 2. Create enrollment record
                final enrollmentCreated = await ref
                    .read(purchaseCourseProvider.notifier)
                    .purchase(widget.courseId);

                // 3. Create booking record
                final repository = ref.read(bookingRepositoryProvider);
                final userId = ref.read(currentUserIdProvider);
                final bookingReq = BookingRequest(
                  userId: userId,
                  courseId: widget.courseId,
                  branchId: widget.bookingExtras?['branchId'],
                  dateIso: widget.bookingExtras?['date'],
                  time: widget.bookingExtras?['time'],
                );
                final booking = await repository.createBooking(bookingReq);

                // 4. Create payment record (persist to database)
                await repository.createPaymentRecord(
                  userId: userId,
                  bookingId: booking.id,
                  amount: coursePrice,
                  paymentMethod: selectedPaymentMethod,
                  transactionId: _transactionIdController.text.trim(),
                  slipUrl: slipUrl,
                );

                // Add notifications for purchase using dynamic details
                ref.read(notificationProvider.notifier).add(
                  AppNotification.paymentSuccess(
                    courseName: courseName,
                    amount: coursePrice,
                  ),
                );
                ref.read(notificationProvider.notifier).add(
                  AppNotification.enrollmentConfirmed(
                    courseName: courseName,
                  ),
                );

                if (mounted) {
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
      },
      loading: () => Scaffold(
        backgroundColor: const Color(0xFFF7F9FC),
        appBar: AppBar(
          title: Text(
            'ชำระเงิน',
            style: GoogleFonts.notoSansThai(
              fontWeight: FontWeight.bold,
              fontSize: 17.sp,
              color: textDarkColor,
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
        body: const Center(
          child: CircularProgressIndicator(color: brandTeal),
        ),
      ),
      error: (err, stack) => Scaffold(
        backgroundColor: const Color(0xFFF7F9FC),
        appBar: AppBar(
          title: Text(
            'ชำระเงิน',
            style: GoogleFonts.notoSansThai(
              fontWeight: FontWeight.bold,
              fontSize: 17.sp,
              color: textDarkColor,
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(24.w),
            child: Text(
              'เกิดข้อผิดพลาดในการโหลดข้อมูล: $err',
              style: GoogleFonts.notoSansThai(color: Colors.red, fontSize: 13.sp),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOrderSummary(BuildContext context, Course course, double basePrice, double vat, double totalPrice) {
    const textDarkColor = Color(0xFF1A1F36);
    const textMidColor = Color(0xFF6E7A9A);
    const brandTeal = Color(0xFF2DC9A8);

    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: const Color(0xFFEDF2F7), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'สรุปรายการสั่งซื้อ',
            style: GoogleFonts.notoSansThai(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: textDarkColor,
            ),
          ),
          SizedBox(height: 10.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: course.thumbnailUrl != null
                    ? Image.network(
                        course.thumbnailUrl!,
                        width: 56.w,
                        height: 56.w,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _buildPlaceholderThumbnail(),
                      )
                    : _buildPlaceholderThumbnail(),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course.name,
                      style: GoogleFonts.notoSansThai(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                        color: textDarkColor,
                        height: 1.25,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'โดย Lumina Learn',
                      style: GoogleFonts.notoSansThai(
                        fontSize: 11.sp,
                        color: textMidColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: const Divider(height: 1, color: Color(0xFFEDF2F7)),
          ),
          _buildSummaryRow('ราคาคอร์ส (ก่อน VAT)', '฿${basePrice.toStringAsFixed(2)}', isBold: false),
          SizedBox(height: 6.h),
          _buildSummaryRow('ภาษีมูลค่าเพิ่ม (VAT 7%)', '฿${vat.toStringAsFixed(2)}', isBold: false),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: const Divider(height: 1, color: Color(0xFFEDF2F7)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'ยอดรวมสุทธิ',
                style: GoogleFonts.notoSansThai(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: textDarkColor,
                ),
              ),
              Text(
                '฿${totalPrice.toStringAsFixed(0)}',
                style: GoogleFonts.poppins(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: brandTeal,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {required bool isBold}) {
    const textDarkColor = Color(0xFF1A1F36);
    const textMidColor = Color(0xFF6E7A9A);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.notoSansThai(
            fontSize: 12.sp,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
            color: isBold ? textDarkColor : textMidColor,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 12.sp,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            color: textDarkColor,
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceholderThumbnail() {
    return Container(
      width: 56.w,
      height: 56.w,
      color: const Color(0xFFE6F9F5),
      child: const Icon(
        Icons.menu_book_rounded,
        color: Color(0xFF2DC9A8),
        size: 24,
      ),
    );
  }

  Widget _buildPaymentMethodOption(String title, IconData icon, String value) {
    const brandTeal = Color(0xFF2DC9A8);
    const brandTealLight = Color(0xFFE6F9F5);
    const textDarkColor = Color(0xFF1A1F36);

    final isSelected = selectedPaymentMethod == value;

    return GestureDetector(
      onTap: () {
        setState(() => selectedPaymentMethod = value);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? brandTeal : const Color(0xFFE2E8F0),
            width: 1.5,
          ),
          color: isSelected ? brandTealLight.withValues(alpha: 0.12) : Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 36.w,
              height: 36.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                color: isSelected ? brandTealLight : const Color(0xFFF7F9FC),
              ),
              child: Icon(icon, color: brandTeal, size: 18.sp),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.notoSansThai(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: textDarkColor,
                ),
              ),
            ),
            Transform.scale(
              scale: 0.8,
              child: Radio<String>(
                value: value,
                activeColor: brandTeal,
                groupValue: selectedPaymentMethod,
                onChanged: (val) {
                  setState(() => selectedPaymentMethod = val!);
                },
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPromptPayQRCodeCard(BuildContext context, double totalPrice) {
    const brandTeal = Color(0xFF2DC9A8);
    const textDarkColor = Color(0xFF1A1F36);
    const textMidColor = Color(0xFF6E7A9A);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: const Color(0xFFEDF2F7), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0F2C59), Color(0xFF1A498B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(top: Radius.circular(14.r)),
            ),
            padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 12.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.qr_code_rounded, color: Colors.white, size: 20.sp),
                SizedBox(width: 6.w),
                Text(
                  'Thai QR Payment / พร้อมเพย์',
                  style: GoogleFonts.notoSansThai(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 13.sp,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(14.w),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.02),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Image.network(
                    'https://api.qrserver.com/v1/create-qr-code/?size=140&data=learnhub-payment-${totalPrice.toStringAsFixed(0)}',
                    width: 140.w,
                    height: 140.w,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return SizedBox(
                        width: 140.w,
                        height: 140.w,
                        child: const Center(
                          child: CircularProgressIndicator(color: brandTeal, strokeWidth: 2.5),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return SizedBox(
                        width: 140.w,
                        height: 140.w,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.wifi_off_rounded, size: 28.sp, color: textMidColor),
                              SizedBox(height: 6.h),
                              Text(
                                'QR Code Offline',
                                style: GoogleFonts.notoSansThai(color: textMidColor, fontSize: 10.sp),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  'จำนวนเงินที่ต้องชำระ (Total Amount)',
                  style: GoogleFonts.notoSansThai(
                    fontSize: 11.sp,
                    color: textMidColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  '฿${totalPrice.toStringAsFixed(0)}',
                  style: GoogleFonts.poppins(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w700,
                    color: brandTeal,
                  ),
                ),
                SizedBox(height: 10.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: const Color(0xFFF1F5F9)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 2),
                        child: Icon(Icons.info_outline_rounded, color: Color(0xFF3B82F6), size: 14),
                      ),
                      SizedBox(width: 6.w),
                      Expanded(
                        child: Text(
                          'สแกน QR Code เพื่อโอนเงิน จากนั้นแนบหลักฐานการโอนที่แบบฟอร์มด้านล่าง',
                          style: GoogleFonts.notoSansThai(
                            fontSize: 10.sp,
                            color: textDarkColor,
                            height: 1.35,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentProofForm(BuildContext context) {
    const textDarkColor = Color(0xFF1A1F36);

    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: const Color(0xFFEDF2F7), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ข้อมูลการโอนเงิน (Transfer Details)',
              style: GoogleFonts.notoSansThai(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: textDarkColor,
              ),
            ),
            SizedBox(height: 12.h),
            
            // Row 1: Sender Name
            _buildCompactTextField(
              label: 'ชื่อผู้โอน',
              hint: 'ชื่อผู้โอนเงิน / Sender name',
              controller: _senderNameController,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'กรุณากรอกชื่อผู้โอน';
                }
                return null;
              },
            ),
            SizedBox(height: 12.h),

            // Row 2: Date & Ref side by side in a Row layout
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => _selectDateTime(context),
                    child: AbsorbPointer(
                      child: _buildCompactTextField(
                        label: 'วัน-เวลาที่โอน',
                        hint: 'แตะเพื่อเลือก',
                        controller: _transferDateTimeController,
                        suffixIcon: const Icon(Icons.calendar_today_rounded, color: Color(0xFF2DC9A8), size: 16),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'กรุณาเลือกวันเวลา';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: _buildCompactTextField(
                    label: 'เลขที่อ้างอิง (Ref. No.)',
                    hint: 'เลขธุรกรรม',
                    controller: _transactionIdController,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'กรุณากรอกเลขอ้างอิง';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            
            SizedBox(height: 16.h),
            Text(
              'หลักฐานการโอนเงิน / Transfer Slip',
              style: GoogleFonts.notoSansThai(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: textDarkColor,
              ),
            ),
            SizedBox(height: 8.h),
            _buildSlipUploadWidget(context),
            if (_showSlipError)
              Padding(
                padding: EdgeInsets.only(top: 6.h, left: 2.w),
                child: Text(
                  'กรุณาแนบรูปภาพสลิปการโอนเงิน',
                  style: TextStyle(
                    color: AppTheme.errorColor,
                    fontSize: 11.sp,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    Widget? suffixIcon,
    String? Function(String?)? validator,
    VoidCallback? onTap,
    bool readOnly = false,
  }) {
    const textDarkColor = Color(0xFF1A1F36);
    const textMidColor = Color(0xFF6E7A9A);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.notoSansThai(
            fontSize: 11.5.sp,
            fontWeight: FontWeight.w600,
            color: textDarkColor,
          ),
        ),
        SizedBox(height: 5.h),
        TextFormField(
          controller: controller,
          validator: validator,
          onTap: onTap,
          readOnly: readOnly,
          style: GoogleFonts.notoSansThai(
            fontSize: 13.sp,
            color: textDarkColor,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.notoSansThai(
              fontSize: 11.5.sp,
              color: textMidColor.withValues(alpha: 0.5),
            ),
            filled: true,
            fillColor: const Color(0xFFF8FAFC),
            contentPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: const BorderSide(color: Color(0xFF2DC9A8), width: 1.2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: const BorderSide(color: Colors.red, width: 0.8),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: const BorderSide(color: Colors.red, width: 1.2),
            ),
            errorStyle: GoogleFonts.notoSansThai(
              fontSize: 10.sp,
              color: Colors.red,
            ),
            isDense: true,
            suffixIcon: suffixIcon != null
                ? Container(
                    margin: EdgeInsets.only(right: 6.w),
                    child: suffixIcon,
                  )
                : null,
            suffixIconConstraints: const BoxConstraints(
              minWidth: 20,
              minHeight: 20,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSlipUploadWidget(BuildContext context) {
    const brandTeal = Color(0xFF2DC9A8);
    const brandTealLight = Color(0xFFE6F9F5);
    const textMidColor = Color(0xFF6E7A9A);

    return GestureDetector(
      onTap: _pickSlip,
      child: DottedBorder(
        color: _showSlipError ? AppTheme.errorColor : brandTeal,
        strokeWidth: 1.5,
        dashPattern: const [6, 4],
        borderType: BorderType.RRect,
        radius: Radius.circular(10.r),
        child: Container(
          width: double.infinity,
          height: 110.h,
          decoration: BoxDecoration(
            color: _showSlipError
                ? AppTheme.errorColor.withValues(alpha: 0.01)
                : brandTealLight.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: _slipImage == null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.cloud_upload_outlined,
                      size: 28.sp,
                      color: brandTeal,
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      'แตะเพื่อแนบรูปภาพสลิป / Tap to upload slip',
                      style: GoogleFonts.notoSansThai(
                        fontSize: 11.5.sp,
                        color: textMidColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                )
              : Stack(
                  children: [
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.r),
                        child: Image.memory(
                          _slipImageBytes!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 6,
                      right: 6,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _slipImage = null;
                            _slipImageBytes = null;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: const BoxDecoration(
                            color: Colors.black54,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 14,
                          ),
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
