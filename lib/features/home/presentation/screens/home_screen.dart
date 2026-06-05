import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:learn_hub/features/courses/domain/providers/course_provider.dart';
import 'package:learn_hub/features/enrollment/domain/providers/enrollment_provider.dart';
import 'package:learn_hub/features/notifications/domain/providers/notification_provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/constants/app_strings.dart';
import '../../../../shared/widgets/common_widgets.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);
    final popularCoursesAsync = ref.watch(popularCoursesProvider);
    final enrolledIdsAsync = ref.watch(enrolledCourseIdsProvider);
    final enrolledIds = enrolledIdsAsync.maybeWhen(
      data: (ids) => ids,
      orElse: () => const <String>{},
    );

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with Profile
              _buildHeader(context),
              
              // Search Bar
              _buildSearchBar(context),

              // Promotional Banner
              _buildPromoBanner(context),

              // Categories Section
              _buildCategoriesSection(context, categoriesAsync),

              // Popular Courses Section
              _buildPopularCoursesSection(context, popularCoursesAsync, enrolledIds),

              // Upcoming Classes Section
              _buildUpcomingClassesSection(context),

              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(context, ref),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(AppTheme.spacingMd),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome back',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: AppTheme.mediumGrey,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                'John Doe',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ],
          ),
          Container(
            width: 48.w,
            height: 48.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.primaryColor,
            ),
            child: Icon(Icons.person, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppTheme.spacingMd),
      child: TextField(
        decoration: InputDecoration(
          hintText: AppStrings.searchCourses,
          prefixIcon: Icon(Icons.search, color: AppTheme.mediumGrey),
          suffixIcon: Icon(Icons.tune, color: AppTheme.mediumGrey),
        ),
      ),
    );
  }

  Widget _buildPromoBanner(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(AppTheme.spacingMd),
      child: Container(
        height: 160.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppTheme.radiusLg),
          gradient: LinearGradient(
            colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: AppTheme.softShadow,
        ),
        child: Stack(
          children: [
            Positioned(
              right: -20,
              top: -20,
              child: Icon(
                Icons.school,
                size: 150.sp,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(AppTheme.spacingMd),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Special Offer',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Get 30% off on all courses',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    'Limited time only. Use code LEARN30',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoriesSection(BuildContext context, AsyncValue categoriesAsync) {
    return categoriesAsync.when(
      data: (categories) => Padding(
        padding: EdgeInsets.symmetric(horizontal: AppTheme.spacingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    AppStrings.categories,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                GestureDetector(
                  onTap: () => context.go('/home/courses'),
                  child: Text(
                    AppStrings.viewAll,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            SizedBox(
              height: 100.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length > 5 ? 5 : categories.length,
                itemBuilder: (context, index) {
                  return _buildCategoryCard(categories[index].name);
                },
              ),
            ),
            SizedBox(height: 24.h),
          ],
        ),
      ),
      loading: () => LoadingWidget(),
      error: (error, stack) => Text(error.toString()),
    );
  }

  Widget _buildCategoryCard(String categoryName) {
    return Padding(
      padding: EdgeInsets.only(right: 12.w),
      child: Container(
        width: 80.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          color: AppTheme.veryLightGrey,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.category,
                color: AppTheme.primaryColor,
                size: 32.sp,
              ),
              SizedBox(height: 8.h),
              Text(
                categoryName,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.darkGrey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPopularCoursesSection(
    BuildContext context,
    AsyncValue popularCoursesAsync,
    Set<String> enrolledIds,
  ) {
    return popularCoursesAsync.when(
      data: (courses) => Padding(
        padding: EdgeInsets.symmetric(horizontal: AppTheme.spacingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    AppStrings.popularCourses,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                GestureDetector(
                  onTap: () => context.go('/home/courses'),
                  child: Text(
                    AppStrings.viewAll,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: courses.length > 3 ? 3 : courses.length,
              itemBuilder: (context, index) {
                final course = courses[index];
                final enrolled = enrolledIds.contains(course.id);
                return Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: CourseCard(
                    thumbnail: course.thumbnailUrl ?? 'https://via.placeholder.com/300x200',
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
            SizedBox(height: 24.h),
          ],
        ),
      ),
      loading: () => LoadingWidget(),
      error: (error, stack) => Text(error.toString()),
    );
  }

  Widget _buildUpcomingClassesSection(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppTheme.spacingMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  AppStrings.upcomingClasses,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              GestureDetector(
                onTap: () => context.go('/home/schedule'),
                child: Text(
                  AppStrings.viewAll,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          _buildUpcomingClassCard(
            'Flutter Basics',
            'John Smith',
            'Tomorrow, 2:00 PM',
            'Online',
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingClassCard(String title, String instructor, String time, String type) {
    return Container(
      padding: EdgeInsets.all(AppTheme.spacingMd),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        color: AppTheme.surfaceColor,
        boxShadow: AppTheme.softShadow,
      ),
      child: Row(
        children: [
          Container(
            width: 50.w,
            height: 50.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppTheme.radiusMd),
              color: AppTheme.veryLightGrey,
            ),
            child: Icon(Icons.video_call, color: AppTheme.primaryColor),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.darkGrey,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  '$instructor • $type',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: AppTheme.mediumGrey,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppTheme.radiusSm),
              color: AppTheme.successColor.withOpacity(0.1),
            ),
            child: Text(
              time,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: AppTheme.successColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context, WidgetRef ref) {
    final unread = ref.watch(unreadCountProvider);
    return BottomNavigationBar(
      backgroundColor: AppTheme.surfaceColor,
      selectedItemColor: AppTheme.primaryColor,
      unselectedItemColor: AppTheme.mediumGrey,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.book),
          label: 'Courses',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today),
          label: 'Schedule',
        ),
        BottomNavigationBarItem(
          icon: Badge(
            isLabelVisible: unread > 0,
            label: Text('$unread'),
            backgroundColor: AppTheme.errorColor,
            child: Icon(Icons.notifications),
          ),
          label: 'Notifications',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
      onTap: (index) {
        switch (index) {
          case 0:
            context.go('/home');
            break;
          case 1:
            context.go('/home/courses');
            break;
          case 2:
            context.go('/home/schedule');
            break;
          case 3:
            context.go('/home/notifications');
            break;
          case 4:
            context.go('/home/profile');
            break;
        }
      },
    );
  }
}


