import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:learn_hub/core/theme/app_theme.dart';
import '../../../../shared/constants/app_strings.dart';
import '../../../../shared/widgets/common_widgets.dart';
import '../../../courses/domain/providers/course_provider.dart';
import '../../../enrollment/domain/providers/enrollment_provider.dart';
import '../../domain/entities/course.dart';
import 'package:learn_hub/features/notifications/presentation/widgets/notification_dropdown_button.dart';

class CourseListScreen extends ConsumerStatefulWidget {
  const CourseListScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<CourseListScreen> createState() => _CourseListScreenState();
}

class _CourseListScreenState extends ConsumerState<CourseListScreen> {
  String? _selectedCategoryId;

  Widget _buildTopBar(BuildContext context) {
    const tealColor = Color(0xFF2DC9A8);
    const tealLightColor = Color(0xFFE6F9F5);
    const textDarkColor = Color(0xFF1A1F36);

    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 4.h),
      child: Row(
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: tealColor, width: 2),
            ),
            child: ClipOval(
              child: Container(
                color: tealLightColor,
                child: Icon(Icons.person_rounded, color: tealColor, size: 24.sp),
              ),
            ),
          ),
          SizedBox(width: 10.w),
          Text(
            'คอร์สทั้งหมด',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: textDarkColor,
            ),
          ),
          const Spacer(),
          _TopIconButton(icon: Icons.shopping_cart_outlined, onTap: () {}),
          SizedBox(width: 6.w),
          const NotificationDropdownButton(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoriesProvider);
    final coursesAsync = _selectedCategoryId == null
        ? ref.watch(allCoursesProvider)
        : ref.watch(coursesByCategoryProvider(_selectedCategoryId!));
    final enrolledIdsAsync = ref.watch(enrolledCourseIdsProvider);
    final enrolledIds = enrolledIdsAsync.maybeWhen(
      data: (ids) => ids,
      orElse: () => const <String>{},
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC), // Sleek light background
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(context),
            
            // Search and Filter
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 48.h,
                      child: TextField(
                        textAlignVertical: TextAlignVertical.center,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: const Color(0xFF1A1F36),
                        ),
                        decoration: InputDecoration(
                          hintText: 'ค้นหาคอร์สเรียนของคุณ...',
                          hintStyle: TextStyle(
                            fontSize: 14.sp,
                            color: const Color(0xFFA0AEC0),
                          ),
                          prefixIcon: Icon(Icons.search, color: const Color(0xFF718096), size: 20.sp),
                          filled: true,
                          fillColor: const Color(0xFFEDF2F7),
                          contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24.r),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24.r),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24.r),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Container(
                    height: 48.h,
                    width: 48.h,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFD7C7FF), // Purple filter background matching mock
                    ),
                    child: const Icon(Icons.tune, color: Color(0xFF6B46C1)),
                  ),
                ],
              ),
            ),

            // Category Filter Chips
            SizedBox(
              height: 44.h,
              child: categoriesAsync.when(
                data: (categories) => ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  itemCount: categories.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      final selected = _selectedCategoryId == null;
                      return Padding(
                        padding: EdgeInsets.only(right: 8.w),
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedCategoryId = null),
                          child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            decoration: BoxDecoration(
                              color: selected ? const Color(0xFF0F7A5F) : const Color(0xFFE2E8F0),
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Text(
                              'ทั้งหมด',
                              style: TextStyle(
                                color: selected ? Colors.white : const Color(0xFF4A5568),
                                fontWeight: FontWeight.w600,
                                fontSize: 13.sp,
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                    final cat = categories[index - 1];
                    final selected = _selectedCategoryId == cat.id;
                    return Padding(
                      padding: EdgeInsets.only(right: 8.w),
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedCategoryId = cat.id),
                        child: Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          decoration: BoxDecoration(
                            color: selected ? const Color(0xFF0F7A5F) : const Color(0xFFE2E8F0),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Text(
                            cat.name,
                            style: TextStyle(
                              color: selected ? Colors.white : const Color(0xFF4A5568),
                              fontWeight: FontWeight.w600,
                              fontSize: 13.sp,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                loading: () => const SizedBox(),
                error: (error, stack) => const SizedBox(),
              ),
            ),

            SizedBox(height: 16.h),

            // Courses List
            Expanded(
              child: coursesAsync.when(
                data: (courses) => ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(bottom: 24.h),
                  itemCount: courses.length,
                  itemBuilder: (context, index) {
                    final course = courses[index];
                    final enrolled = enrolledIds.contains(course.id);
                    return _buildCourseListItem(context, course, enrolled);
                  },
                ),
                loading: () => const LoadingWidget(),
                error: (error, stack) => Text(error.toString()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseListItem(BuildContext context, Course course, bool enrolled) {
    // Custom logic to mock instructor name and crossed-out original price to match mock layout
    final String instructor = course.name.contains('Procreate') || course.name.contains('ศิลปะ')
        ? 'อ. รันลดา มั่งคั่ง'
        : 'อ. สมชาย วิทยา';
    final double originalPrice = course.price * 1.5;
    final String badgeText = course.name.contains('Procreate') || course.name.contains('ศิลปะ')
        ? 'ยอดนิยม'
        : 'แนะนำ';

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
                child: Image.network(
                  course.thumbnailUrl ?? 'https://via.placeholder.com/300x200',
                  height: 160.h,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 12.h,
                right: 12.w,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6B46C1), // Purple badge color
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    badgeText,
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  course.name,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1A1F36),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 6.h),
                Text(
                  instructor,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: const Color(0xFF718096),
                  ),
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Icon(Icons.star_rounded, color: Colors.amber, size: 18.sp),
                    SizedBox(width: 4.w),
                    Text(
                      course.rating.toStringAsFixed(1),
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1A1F36),
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      '(${course.totalStudents} นักเรียน)',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: const Color(0xFF718096),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          '฿${course.price.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF1A1F36),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          '฿${originalPrice.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: const Color(0xFF718096),
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: enrolled
                          ? () => context.go('/home/learning/${course.id}')
                          : () => context.go('/home/courses/${course.id}'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF62C1A8),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                      ),
                      child: Text(
                        enrolled ? 'เริ่มเรียน' : 'ดูรายละเอียด',
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TopIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool hasBadge;

  const _TopIconButton({
    required this.icon,
    required this.onTap,
    this.hasBadge = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38.w,
        height: 38.w,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.07),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(icon, color: const Color(0xFF1A1F36), size: 20.sp),
            if (hasBadge)
              Positioned(
                top: 8.h,
                right: 8.w,
                child: Container(
                  width: 7.w,
                  height: 7.w,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFF4B4B),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
