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
      duration: const Duration(milliseconds: 200),
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: isSelected
            ? AppTheme.primaryColor.withOpacity(0.1)
            : AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        border: Border.all(
          color: isSelected
              ? AppTheme.primaryColor.withOpacity(0.4)
              : AppTheme.lightGrey,
          width: isSelected ? 1.5 : 1,
        ),
      ),
      child: InkWell(
        onTap: isLocked ? null : onTap,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        child: Padding(
          padding: EdgeInsets.all(12.w),
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
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: isLocked
                            ? AppTheme.mediumGrey
                            : AppTheme.darkGrey,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Icon(
                          Icons.schedule,
                          size: 12.sp,
                          color: AppTheme.mediumGrey,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          lesson.formattedDuration,
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: AppTheme.mediumGrey,
                          ),
                        ),
                        if (isWatched) ...[
                          SizedBox(width: 8.w),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 6.w, vertical: 2.h),
                            decoration: BoxDecoration(
                              color: AppTheme.successColor.withOpacity(0.12),
                              borderRadius:
                                  BorderRadius.circular(AppTheme.radiusSm),
                            ),
                            child: Text(
                              'Completed',
                              style: TextStyle(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w600,
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
        decoration: BoxDecoration(
          color: AppTheme.lightGrey,
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.lock_outline,
          size: 18.sp,
          color: AppTheme.mediumGrey,
        ),
      );
    }

    if (isWatched) {
      return Container(
        width: 36.w,
        height: 36.w,
        decoration: BoxDecoration(
          color: AppTheme.successColor.withOpacity(0.15),
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.check_circle,
          size: 20.sp,
          color: AppTheme.successColor,
        ),
      );
    }

    if (isSelected) {
      return Container(
        width: 36.w,
        height: 36.w,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
          ),
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.play_arrow,
          size: 20.sp,
          color: Colors.white,
        ),
      );
    }

    return Container(
      width: 36.w,
      height: 36.w,
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.play_circle_outline,
        size: 20.sp,
        color: AppTheme.primaryColor,
      ),
    );
  }
}
