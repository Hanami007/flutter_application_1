import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:learn_hub/core/theme/app_theme.dart';
import '../../../../shared/constants/app_strings.dart';
import '../../../../shared/widgets/common_widgets.dart';
import '../../../courses/domain/providers/course_provider.dart';
import '../../../enrollment/domain/providers/enrollment_provider.dart';

class CourseListScreen extends ConsumerStatefulWidget {
  const CourseListScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<CourseListScreen> createState() => _CourseListScreenState();
}

class _CourseListScreenState extends ConsumerState<CourseListScreen> {
  String? _selectedCategoryId;

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
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(AppStrings.courses),
      ),
      body: Column(
        children: [
          // Search and Filter
          Padding(
            padding: EdgeInsets.all(AppTheme.spacingMd),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: AppStrings.searchCourses,
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Container(
                  height: 48.h,
                  width: 48.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                    color: AppTheme.veryLightGrey,
                  ),
                  child: Icon(Icons.tune),
                ),
              ],
            ),
          ),

          // Category Filter
          SizedBox(
            height: 50.h,
            child: categoriesAsync.when(
              data: (categories) => ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: AppTheme.spacingMd),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final cat = categories[index];
                  final selected = _selectedCategoryId == cat.id;
                  return Padding(
                    padding: EdgeInsets.only(right: 8.w),
                    child: FilterChip(
                      label: Text(cat.name),
                      selected: selected,
                      onSelected: (isSelected) {
                        setState(() {
                          if (isSelected) {
                            _selectedCategoryId = cat.id;
                          } else {
                            _selectedCategoryId = null;
                          }
                        });
                      },
                    ),
                  );
                },
              ),
              loading: () => SizedBox(),
              error: (error, stack) => SizedBox(),
            ),
          ),

          SizedBox(height: 16.h),

          // Courses List
          Expanded(
            child: coursesAsync.when(
              data: (courses) => ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: AppTheme.spacingMd),
                itemCount: courses.length,
                itemBuilder: (context, index) {
                  final course = courses[index];
                  final enrolled = enrolledIds.contains(course.id);
                  return Padding(
                    padding: EdgeInsets.only(bottom: 12.h),
                    child: CourseCard(
                      thumbnail: course.thumbnailUrl ?? 'https://placehold.co/300x200',
                      courseName: course.name,
                      instructor: 'Instructor',
                      rating: course.rating,
                      students: course.totalStudents,
                      price: '฿${course.price.toStringAsFixed(0)}',
                      isEnrolled: enrolled,
                      onTap: () => context.go('/home/courses/${course.id}'),
                      onBook: enrolled
                          ? () => context.go('/home/learning/${course.id}')
                          : () => context.go('/home/courses/${course.id}'),
                    ),
                  );
                },
              ),
              loading: () => LoadingWidget(),
              error: (error, stack) => Text(error.toString()),
            ),
          ),
        ],
      ),
    );
  }
}
