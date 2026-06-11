import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
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
    const textDarkColor = Color(0xFF1A1F36);
    const brandTeal = Color(0xFF2DC9A8);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        title: Text(
          'คอร์สเรียนของฉัน',
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
      body: enrolledAsync.when(
        data: (courses) => courses.isEmpty
            ? _buildEmptyState(context)
            : _buildCourseList(context, ref, courses),
        loading: () => const Center(
          child: CircularProgressIndicator(color: brandTeal),
        ),
        error: (e, _) => Center(
          child: Text(
            'เกิดข้อผิดพลาด: $e',
            style: GoogleFonts.notoSansThai(color: Colors.red, fontSize: 13.sp),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    const brandTeal = Color(0xFF2DC9A8);
    const brandTealLight = Color(0xFFE6F9F5);
    const textDarkColor = Color(0xFF1A1F36);
    const textMidColor = Color(0xFF6E7A9A);

    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100.w,
              height: 100.w,
              decoration: const BoxDecoration(
                color: brandTealLight,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.school_rounded,
                size: 50.sp,
                color: brandTeal,
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              'ยังไม่มีคอร์สเรียนในขณะนี้',
              style: GoogleFonts.notoSansThai(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: textDarkColor,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'เลือกดูคอร์สเรียนทั้งหมดในหมวดหมู่ของเราเพื่อเริ่มต้นเรียนรู้ทันที',
              textAlign: TextAlign.center,
              style: GoogleFonts.notoSansThai(
                fontSize: 13.sp,
                color: textMidColor,
                height: 1.5,
              ),
            ),
            SizedBox(height: 32.h),
            PrimaryButton(
              text: 'เลือกดูคอร์สเรียนทั้งหมด',
              backgroundColor: brandTeal,
              onPressed: () => context.go('/home/courses'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseList(
      BuildContext context, WidgetRef ref, List<Course> courses) {
    const textDarkColor = Color(0xFF1A1F36);
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverPadding(
          padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 4.h),
          sliver: SliverToBoxAdapter(
            child: Row(
              children: [
                Text(
                  'คอร์สเรียนทั้งหมดที่คุณลงทะเบียน (${courses.length})',
                  style: GoogleFonts.notoSansThai(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: textDarkColor,
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
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
    final isFavorite = ref.watch(favoriteCourseIdsProvider.select((ids) => ids.contains(course.id)));
    const textDarkColor = Color(0xFF1A1F36);
    const textMidColor = Color(0xFF6E7A9A);
    const brandTeal = Color(0xFF2DC9A8);

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFEDF2F7), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16.r),
        onTap: () => context.go('/home/learning/${course.id}'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
              child: Stack(
                children: [
                  CachedNetworkImage(
                    imageUrl: course.thumbnailUrl ?? 'https://placehold.co/400x180',
                    height: 150.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorWidget: (_, __, ___) => Container(
                      height: 150.h,
                      color: const Color(0xFFE6F9F5),
                      child: const Icon(
                        Icons.menu_book_rounded,
                        color: brandTeal,
                        size: 40,
                      ),
                    ),
                  ),
                  // Favorite button
                  Positioned(
                    top: 10.h,
                    right: 10.w,
                    child: GestureDetector(
                      onTap: () => ref
                          .read(favoriteCourseIdsProvider.notifier)
                          .toggle(course.id),
                      child: Container(
                        padding: EdgeInsets.all(6.w),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                          size: 18.sp,
                          color: isFavorite ? Colors.red : textMidColor,
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
                    style: GoogleFonts.notoSansThai(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: textDarkColor,
                      height: 1.3,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Row(
                    children: [
                      Icon(Icons.star_rounded, size: 16.sp, color: const Color(0xFFFFC107)),
                      SizedBox(width: 4.w),
                      Text(
                        '${course.rating}',
                        style: GoogleFonts.poppins(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color: textDarkColor,
                        ),
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        '(${course.totalStudents} ผู้เรียน)',
                        style: GoogleFonts.notoSansThai(
                          fontSize: 11.sp,
                          color: textMidColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 14.h),

                  // Progress Section
                  progressAsync.when(
                    data: (progress) => _buildProgressSection(context, course, progress),
                    loading: () => const LinearProgressIndicator(
                      color: brandTeal,
                      backgroundColor: Color(0xFFEDF2F7),
                    ),
                    error: (_, __) => _buildProgressSection(context, course, null),
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
    final displayPct = pct > 1.0 ? pct : pct * 100;
    final isCompleted = displayPct >= 100;
    final hasStarted = displayPct > 0;

    const brandTeal = Color(0xFF2DC9A8);
    const textDarkColor = Color(0xFF1A1F36);
    const textMidColor = Color(0xFF6E7A9A);

    String buttonText;
    Color buttonColor;
    IconData buttonIcon;

    if (isCompleted) {
      buttonText = 'เขียนรีวิวคอร์สเรียน';
      buttonColor = const Color(0xFFF59E0B); // amber
      buttonIcon = Icons.rate_review_rounded;
    } else if (hasStarted) {
      buttonText = 'เรียนต่อจากเดิม (${displayPct.toStringAsFixed(0)}%)';
      buttonColor = brandTeal;
      buttonIcon = Icons.play_arrow_rounded;
    } else {
      buttonText = 'เริ่มเรียนกันเลย';
      buttonColor = const Color(0xFF0F7A5F); // darker teal
      buttonIcon = Icons.school_rounded;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
              decoration: BoxDecoration(
                color: isCompleted
                    ? const Color(0xFFE6F4EA)
                    : hasStarted
                        ? const Color(0xFFE6F9F5)
                        : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: Text(
                isCompleted
                    ? 'เรียนจบแล้ว 🎉'
                    : hasStarted
                        ? 'กำลังเรียนอยู่'
                        : 'ยังไม่ได้เริ่ม',
                style: GoogleFonts.notoSansThai(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.bold,
                  color: isCompleted
                      ? const Color(0xFF137333)
                      : hasStarted
                          ? brandTeal
                          : textMidColor,
                ),
              ),
            ),
            if (progress != null)
              Text(
                '${progress.videosWatched}/${progress.videosTotal} บทเรียน',
                style: GoogleFonts.poppins(
                  fontSize: 11.sp,
                  color: textMidColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
          ],
        ),
        SizedBox(height: 8.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(4.r),
          child: LinearProgressIndicator(
            value: (displayPct / 100).clamp(0.0, 1.0),
            minHeight: 6.h,
            backgroundColor: const Color(0xFFEDF2F7),
            valueColor: AlwaysStoppedAnimation<Color>(
              isCompleted
                  ? const Color(0xFF10B981)
                  : hasStarted
                      ? brandTeal
                      : const Color(0xFFCBD5E0),
            ),
          ),
        ),
        SizedBox(height: 14.h),
        // Action Button
        SizedBox(
          width: double.infinity,
          height: 42.h,
          child: ElevatedButton.icon(
            onPressed: () => context.go('/home/learning/${course.id}'),
            icon: Icon(buttonIcon, size: 18.sp, color: Colors.white),
            label: Text(
              buttonText,
              style: GoogleFonts.notoSansThai(
                fontSize: 13.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: buttonColor,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
