import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:learn_hub/core/theme/app_theme.dart';
import 'package:learn_hub/shared/constants/app_strings.dart';
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
            colorScheme: ColorScheme.light(
              primary: AppTheme.primaryColor,
              onPrimary: Colors.white,
              onSurface: AppTheme.darkGrey,
            ),
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: AppTheme.primaryColor,
                onPrimary: Colors.white,
                onSurface: AppTheme.darkGrey,
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
    final course = courseAsync.valueOrNull;
    final courseName = course?.name ?? 'Course';

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
              'Scan QR Code / สแกนจ่าย',
              Icons.qr_code_scanner,
              'qr_scan',
            ),

            SizedBox(height: 24.h),

            if (selectedPaymentMethod == 'qr_scan') ...[
              _buildPromptPayQRCodeCard(context),
              SizedBox(height: 24.h),
              _buildPaymentProofForm(context),
              SizedBox(height: 24.h),
            ],

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

            // 1. Upload transfer slip if available
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
              // Continue anyway so user booking is not blocked
            }

            // Simulate payment processing
            await Future.delayed(const Duration(seconds: 1));

            // 2. Create enrollment record (course purchase)
            final enrollmentCreated = await ref
                .read(purchaseCourseProvider.notifier)
                .purchase(widget.courseId);

            // 3. Create booking record (session booking)
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
              amount: 5999.0, // Match the total amount
              paymentMethod: selectedPaymentMethod,
              transactionId: _transactionIdController.text.trim(),
              slipUrl: slipUrl,
            );

            // Add notifications for purchase
            ref.read(notificationProvider.notifier).add(
              AppNotification.paymentSuccess(
                courseName: courseName,
                amount: 5999.0,
              ),
            );
            ref.read(notificationProvider.notifier).add(
              AppNotification.enrollmentConfirmed(
                courseName: courseName,
              ),
            );

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

  Widget _buildPromptPayQRCodeCard(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      child: Column(
        children: [
          Container(
            color: const Color(0xFF0F2C59), // Deep blue theme for PromptPay
            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.qr_code, color: Colors.white, size: 24.sp),
                SizedBox(width: 8.w),
                Text(
                  'Thai QR Payment / พร้อมเพย์',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppTheme.lightGrey),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Image.network(
                    'https://api.qrserver.com/v1/create-qr-code/?size=200&data=learnhub-payment-5999',
                    width: 200.w,
                    height: 200.w,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return SizedBox(
                        width: 200.w,
                        height: 200.w,
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return SizedBox(
                        width: 200.w,
                        height: 200.w,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.wifi_off, size: 40.sp, color: AppTheme.mediumGrey),
                              SizedBox(height: 8.h),
                              Text(
                                'QR Code Offline',
                                style: TextStyle(color: AppTheme.mediumGrey, fontSize: 12.sp),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  'จำนวนเงินที่ต้องชำระ (Total Amount)',
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: AppTheme.mediumGrey,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  '₹5,999',
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  'กรุณาสแกน QR Code ด้านบนเพื่อโอนเงิน\nเมื่อโอนเสร็จสิ้นแล้ว โปรดแนบหลักฐานการโอนที่แบบฟอร์มด้านล่าง',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppTheme.darkGrey,
                    height: 1.4,
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
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ข้อมูลการโอนเงิน (Transfer Details)',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(height: 12.h),
          TextInputField(
            label: 'ชื่อผู้โอน / Sender Name',
            hint: 'เช่น สมชาย รักเรียน',
            controller: _senderNameController,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'กรุณากรอกชื่อผู้โอน / Please enter sender name';
              }
              return null;
            },
          ),
          SizedBox(height: 16.h),
          GestureDetector(
            onTap: () => _selectDateTime(context),
            child: AbsorbPointer(
              child: TextInputField(
                label: 'วัน-เวลาที่โอน / Transfer Date & Time',
                hint: 'แตะเพื่อเลือกวันเวลา / Tap to select date & time',
                controller: _transferDateTimeController,
                suffixIcon: const Icon(Icons.calendar_today, color: AppTheme.primaryColor),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'กรุณาเลือกวันเวลาที่โอน / Please select transfer date & time';
                  }
                  return null;
                },
              ),
            ),
          ),
          SizedBox(height: 16.h),
          TextInputField(
            label: 'เลขที่อ้างอิงธุรกรรม / Transaction ID (Ref. No.)',
            hint: 'เช่น 20260605XXXX',
            controller: _transactionIdController,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'กรุณากรอกเลขที่รายการ / Please enter transaction ID';
              }
              return null;
            },
          ),
          SizedBox(height: 20.h),
          Text(
            'หลักฐานการโอนเงิน / Transfer Slip',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppTheme.darkGrey,
            ),
          ),
          SizedBox(height: 8.h),
          _buildSlipUploadWidget(context),
          if (_showSlipError)
            Padding(
              padding: EdgeInsets.only(top: 8.h, left: 4.w),
              child: Text(
                'กรุณาแนบรูปภาพสลิปการโอนเงิน / Please upload transfer slip',
                style: TextStyle(
                  color: AppTheme.errorColor,
                  fontSize: 12.sp,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSlipUploadWidget(BuildContext context) {
    return GestureDetector(
      onTap: _pickSlip,
      child: DottedBorder(
        color: _showSlipError ? AppTheme.errorColor : AppTheme.primaryColor,
        strokeWidth: 2,
        dashPattern: const [6, 4],
        borderType: BorderType.RRect,
        radius: Radius.circular(AppTheme.radiusMd),
        child: Container(
          width: double.infinity,
          height: 150.h,
          decoration: BoxDecoration(
            color: AppTheme.veryLightGrey,
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          ),
          child: _slipImage == null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.cloud_upload_outlined,
                      size: 40.sp,
                      color: AppTheme.primaryColor,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'แตะเพื่อแนบรูปภาพสลิป / Tap to upload slip',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: AppTheme.mediumGrey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                )
              : Stack(
                  children: [
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                        child: Image.memory(
                          _slipImageBytes!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _slipImage = null;
                            _slipImageBytes = null;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.black54,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 18,
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
