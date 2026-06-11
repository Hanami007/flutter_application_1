import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';

/// Animated banner shown when a user completes a course (100% progress).
class CompletionBanner extends StatefulWidget {
  final String courseName;
  final VoidCallback? onViewCertificate;
  final VoidCallback? onReviewCourse;
  final VoidCallback? onDismiss;

  const CompletionBanner({
    super.key,
    required this.courseName,
    this.onViewCertificate,
    this.onReviewCourse,
    this.onDismiss,
  });

  @override
  State<CompletionBanner> createState() => _CompletionBannerState();
}

class _CompletionBannerState extends State<CompletionBanner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scaleAnim;
  late final Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _scaleAnim = CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut);
    _fadeAnim = CurvedAnimation(parent: _ctrl, curve: Curves.easeIn);
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnim,
      child: ScaleTransition(
        scale: _scaleAnim,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          padding: EdgeInsets.fromLTRB(12.w, 10.h, 12.w, 10.h),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF8B5CF6), // Royal Indigo
                Color(0xFF3B82F6), // Ocean Blue
              ],
            ),
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF8B5CF6).withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Dismiss Close Button
              if (widget.onDismiss != null)
                Positioned(
                  top: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: widget.onDismiss,
                    child: Container(
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.18),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close_rounded,
                        color: Colors.white,
                        size: 12,
                      ),
                    ),
                  ),
                ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Trophy Icon
                  Container(
                    width: 42.w,
                    height: 42.w,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.emoji_events_rounded,
                      size: 22.sp,
                      color: const Color(0xFFFBBF24),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  // Title and Course name
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '🎉 เรียนจบหลักสูตรแล้ว!',
                          style: GoogleFonts.notoSansThai(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          widget.courseName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.notoSansThai(
                            fontSize: 11.sp,
                            color: Colors.white.withOpacity(0.85),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8.w),
                  // Compact Buttons Column
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.onViewCertificate != null)
                        SizedBox(
                          height: 28.h,
                          child: ElevatedButton.icon(
                            onPressed: widget.onViewCertificate,
                            icon: Icon(Icons.workspace_premium_rounded, size: 12.sp),
                            label: Text(
                              'เกียรติบัตร',
                              style: GoogleFonts.notoSansThai(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: const Color(0xFF3B82F6),
                              elevation: 0,
                              padding: EdgeInsets.symmetric(horizontal: 10.w),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                            ),
                          ),
                        ),
                      if (widget.onReviewCourse != null) ...[
                        SizedBox(height: 4.h),
                        SizedBox(
                          height: 28.h,
                          child: OutlinedButton.icon(
                            onPressed: widget.onReviewCourse,
                            icon: Icon(Icons.rate_review_rounded, size: 12.sp),
                            label: Text(
                              'เขียนรีวิว',
                              style: GoogleFonts.notoSansThai(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              side: const BorderSide(color: Colors.white, width: 1.0),
                              padding: EdgeInsets.symmetric(horizontal: 10.w),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  SizedBox(width: 8.w), // Space for close button Positioning
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
