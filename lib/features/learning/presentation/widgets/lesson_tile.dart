import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/video_lesson.dart';

/// A single lesson row in the lesson list of the CoursePlayerScreen.
class LessonTile extends StatelessWidget {
  final VideoLesson lesson;
  final bool isSelected;
  final bool isWatched;
  final bool isLocked;
  final VoidCallback? onTap;

  const LessonTile({
    super.key,
    required this.lesson,
    this.isSelected = false,
    this.isWatched = false,
    this.isLocked = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: isSelected
            ? AppTheme.primaryColor.withOpacity(0.06)
            : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isSelected
              ? AppTheme.primaryColor.withOpacity(0.3)
              : const Color(0xFFE2E8F0),
          width: isSelected ? 1.5 : 1,
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: AppTheme.primaryColor.withOpacity(0.08),
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
      child: InkWell(
        onTap: isLocked ? null : onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
          child: Row(
            children: [
              // Status Icon
              _buildStatusIcon(),
              SizedBox(width: 12.w),
              // Lesson Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lesson.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                        color: isLocked ? AppTheme.mediumGrey : AppTheme.darkGrey,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Icon(
                          Icons.schedule_rounded,
                          size: 12.sp,
                          color: AppTheme.mediumGrey,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          lesson.formattedDuration,
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: AppTheme.mediumGrey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (isWatched) ...[
                          SizedBox(width: 8.w),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 6.w, vertical: 2.h),
                            decoration: BoxDecoration(
                              color: AppTheme.successColor.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            child: Text(
                              'เสร็จสิ้น',
                              style: TextStyle(
                                fontSize: 9.5.sp,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.successColor,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusIcon() {
    if (isLocked) {
      return Container(
        width: 36.w,
        height: 36.w,
        decoration: const BoxDecoration(
          color: Color(0xFFF1F5F9),
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.lock_outline_rounded,
          size: 16.sp,
          color: AppTheme.mediumGrey,
        ),
      );
    }

    if (isWatched) {
      return Container(
        width: 36.w,
        height: 36.w,
        decoration: BoxDecoration(
          color: AppTheme.successColor.withOpacity(0.12),
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.check_circle_rounded,
          size: 18.sp,
          color: AppTheme.successColor,
        ),
      );
    }

    IconData getIconData() {
      switch (lesson.contentType) {
        case 'text':
          return Icons.article_rounded;
        case 'assignment':
          return Icons.assignment_rounded;
        case 'quiz':
          return Icons.quiz_rounded;
        default:
          return Icons.play_arrow_rounded;
      }
    }

    if (isSelected) {
      return Container(
        width: 36.w,
        height: 36.w,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppTheme.primaryColor, Color(0xFF8B5CF6)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryColor.withOpacity(0.25),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Icon(
          getIconData(),
          size: 18.sp,
          color: Colors.white,
        ),
      );
    }

    return Container(
      width: 36.w,
      height: 36.w,
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withOpacity(0.08),
        shape: BoxShape.circle,
      ),
      child: Icon(
        getIconData(),
        size: 16.sp,
        color: AppTheme.primaryColor,
      ),
    );
  }
}
