import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/constants/app_strings.dart';
import '../../../../shared/widgets/common_widgets.dart';
import '../../../courses/domain/entities/course.dart';
import '../../../enrollment/domain/providers/enrollment_provider.dart';

/// My Learning screen — shows all purchased/enrolled courses with progress.
class LearningScreen extends ConsumerWidget {
  const LearningScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enrolledAsync = ref.watch(enrolledCoursesProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(AppStrings.myLearning),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: AppTheme.darkGrey),
            onPressed: () {},
          ),
        ],
      ),
      body: enrolledAsync.when(
        data: (courses) => courses.isEmpty
            ? _buildEmptyState(context)
            : _buildCourseList(context, ref, courses),
        loading: () => const LoadingWidget(message: 'Loading your courses...'),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100.w,
              height: 100.w,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.school_outlined,
                size: 50.sp,
                color: AppTheme.primaryColor,
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              'No courses yet',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: AppTheme.darkGrey,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Browse our catalog and purchase your first course to start learning.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                color: AppTheme.mediumGrey,
                height: 1.5,
              ),
            ),
            SizedBox(height: 32.h),
            PrimaryButton(
              text: 'Browse Courses',
              onPressed: () => context.go('/home/courses'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseList(
      BuildContext context, WidgetRef ref, List<Course> courses) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 4.h),
          sliver: SliverToBoxAdapter(
            child: Row(
              children: [
                Text(
                  '${courses.length} ${courses.length == 1 ? 'Course' : 'Courses'} Enrolled',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.darkGrey,
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final course = courses[index];
                return _EnrolledCourseCard(course: course);
              },
              childCount: courses.length,
            ),
          ),
        ),
        SliverToBoxAdapter(child: SizedBox(height: 24.h)),
      ],
    );
  }
}

class _EnrolledCourseCard extends ConsumerWidget {
  final Course course;

  const _EnrolledCourseCard({required this.course});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressAsync = ref.watch(courseProgressForCourseProvider(course.id));
    final isFavorite = ref
        .watch(favoriteCourseIdsProvider.select((ids) => ids.contains(course.id)));

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        boxShadow: AppTheme.softShadow,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        onTap: () => context.go('/home/learning/${course.id}'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(AppTheme.radiusLg),
                topRight: Radius.circular(AppTheme.radiusLg),
              ),
              child: Stack(
                children: [
                  CachedNetworkImage(
                    imageUrl: course.thumbnailUrl ??
                        'https://placehold.co/400x180',
                    height: 160.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorWidget: (_, __, ___) => Container(
                      height: 160.h,
                      color: AppTheme.veryLightGrey,
                      child: Icon(Icons.image_not_supported,
                          color: AppTheme.mediumGrey),
                    ),
                  ),
                  // Favorite button
                  Positioned(
                    top: 8.h,
                    right: 8.w,
                    child: GestureDetector(
                      onTap: () => ref
                          .read(favoriteCourseIdsProvider.notifier)
                          .toggle(course.id),
                      child: Container(
                        padding: EdgeInsets.all(6.w),
                        decoration: BoxDecoration(
                          color: Colors.black45,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          size: 18.sp,
                          color: isFavorite ? Colors.red : Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.all(14.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Course Name
                  Text(
                    course.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.darkGrey,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Icon(Icons.star, size: 14.sp, color: Colors.amber),
                      SizedBox(width: 4.w),
                      Text(
                        '${course.rating}',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.darkGrey,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        '(${course.totalStudents} students)',
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: AppTheme.mediumGrey,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 12.h),

                  // Progress
                  progressAsync.when(
                    data: (progress) =>
                        _buildProgressSection(context, course, progress),
                    loading: () => LinearProgressIndicator(
                      backgroundColor: AppTheme.lightGrey,
                    ),
                    error: (_, __) =>
                        _buildProgressSection(context, course, null),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressSection(
    BuildContext context,
    Course course,
    CourseProgress? progress,
  ) {
    final pct = progress?.progressPercentage ?? 0.0;
    // Handle both 0-1 and 0-100 ranges
    final displayPct = pct > 1.0 ? pct : pct * 100;
    final isCompleted = displayPct >= 100;
    final hasStarted = displayPct > 0;

    // Determine button text and color
    String buttonText;
    Color buttonColor;
    IconData buttonIcon;

    if (isCompleted) {
      buttonText = 'Review Course';
      buttonColor = const Color(0xFFF59E0B); // amber
      buttonIcon = Icons.replay;
    } else if (hasStarted) {
      buttonText = 'Continue – ${displayPct.toStringAsFixed(0)}%';
      buttonColor = AppTheme.primaryColor;
      buttonIcon = Icons.play_arrow;
    } else {
      buttonText = 'Start Learning';
      buttonColor = AppTheme.successColor;
      buttonIcon = Icons.play_circle_outline;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Progress bar + percentage
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              isCompleted
                  ? '✅ Completed'
                  : hasStarted
                      ? 'In Progress'
                      : 'Not Started',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: isCompleted
                    ? AppTheme.successColor
                    : hasStarted
                        ? AppTheme.primaryColor
                        : AppTheme.mediumGrey,
              ),
            ),
            if (progress != null)
              Text(
                '${progress.videosWatched}/${progress.videosTotal} lessons',
                style:
                    TextStyle(fontSize: 11.sp, color: AppTheme.mediumGrey),
              ),
          ],
        ),
        SizedBox(height: 6.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(4.r),
          child: LinearProgressIndicator(
            value: (displayPct / 100).clamp(0.0, 1.0),
            minHeight: 5.h,
            backgroundColor: AppTheme.lightGrey,
            valueColor: AlwaysStoppedAnimation<Color>(
              isCompleted
                  ? AppTheme.successColor
                  : hasStarted
                      ? AppTheme.primaryColor
                      : AppTheme.lightGrey,
            ),
          ),
        ),
        SizedBox(height: 12.h),
        // Action Button
        SizedBox(
          width: double.infinity,
          height: 42.h,
          child: ElevatedButton.icon(
            onPressed: () => context.go('/home/learning/${course.id}'),
            icon: Icon(buttonIcon, size: 18.sp),
            label: Text(
              buttonText,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: buttonColor,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusMd),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
