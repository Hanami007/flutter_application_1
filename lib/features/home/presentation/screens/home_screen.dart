import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:learn_hub/core/theme/app_theme.dart';
import 'package:learn_hub/shared/constants/app_strings.dart';
import 'package:learn_hub/shared/widgets/common_widgets.dart';

// ─── Color Palette ───────────────────────────────────────────────────────────
const _teal = Color(0xFF2DC9A8);
const _tealLight = Color(0xFFE6F9F5);
const _purple = Color(0xFFAB94F0);
const _purpleLight = Color(0xFFF2EEFF);
const _orange = Color(0xFFFF9F50);
const _orangeLight = Color(0xFFFFF3E8);
const _pink = Color(0xFFFF7EB3);
const _pinkLight = Color(0xFFFFEDF5);
const _blue = Color(0xFF5B9CF6);
const _blueLight = Color(0xFFEEF4FF);
const _bgColor = Color(0xFFF7F9FC);
const _textDark = Color(0xFF1A1F36);
const _textMid = Color(0xFF6E7A9A);
const _cardBg = Color(0xFFFFFFFF);

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedNavIndex = 0;

  // ─── Category data ────────────────────────────────────────────────────────
  final List<_CategoryItem> _categories = const [
    _CategoryItem('ศิลปะ', Icons.palette_rounded, _purple, _purpleLight),
    _CategoryItem('โปรแกรม', Icons.code_rounded, _teal, _tealLight),
    _CategoryItem('ดนตรี', Icons.music_note_rounded, _orange, _orangeLight),
    _CategoryItem('ทำอาหาร', Icons.restaurant_rounded, _purple, _purpleLight),
    _CategoryItem('ออกแบบ', Icons.brush_rounded, _pink, _pinkLight),
    _CategoryItem('วิทยาศาสตร์', Icons.science_rounded, _blue, _blueLight),
  ];

  // ─── Mock recommended courses ─────────────────────────────────────────────
  final List<_CourseCard> _courses = const [
    _CourseCard(
      badge: 'New',
      category: 'DIGITAL ART',
      title: 'เริ่มต้นวาดรูปดิจิทัล\nด้วย Procreate',
      hours: '12 ชม.',
      rating: 4.9,
      gradientColors: [Color(0xFFFFD580), Color(0xFFFF9F50)],
      iconData: Icons.palette_outlined,
    ),
    _CourseCard(
      badge: 'Hot',
      category: 'PROGRAMMING',
      title: 'พื้นฐานการสร้าง\nApp ด้วย Flutter',
      hours: '24 ชม.',
      rating: 4.8,
      gradientColors: [Color(0xFF6EE7C8), Color(0xFF2DC9A8)],
      iconData: Icons.phone_android_outlined,
    ),
    _CourseCard(
      badge: 'New',
      category: 'MUSIC',
      title: 'เรียนกีตาร์\nตั้งแต่เริ่มต้น',
      hours: '18 ชม.',
      rating: 4.7,
      gradientColors: [Color(0xFFAB94F0), Color(0xFF7C5CBF)],
      iconData: Icons.music_note_outlined,
    ),
    _CourseCard(
      badge: '',
      category: 'COOKING',
      title: 'ทำอาหารไทย\nระดับมืออาชีพ',
      hours: '10 ชม.',
      rating: 4.9,
      gradientColors: [Color(0xFFFF7EB3), Color(0xFFE5397D)],
      iconData: Icons.restaurant_outlined,
    ),
  ];

  // ─── Mock reviews ─────────────────────────────────────────────────────────
  final List<_ReviewItem> _reviews = const [
    _ReviewItem(
      name: 'คณวิชิต',
      category: 'DIGITAL ART',
      rating: 5,
      review: '"คอร์สดีมากครับ สอนเข้าใจง่าย นำไปใช้ได้จริง"',
      avatarColor: Color(0xFFE6F9F5),
      avatarIconColor: Color(0xFF2DC9A8),
    ),
    _ReviewItem(
      name: 'อรุณรัตน์',
      category: 'PROGRAMMING',
      rating: 5,
      review: '"อาจารย์อธิบายได้ชัดเจน ใช้ได้จริงในงาน"',
      avatarColor: Color(0xFFF2EEFF),
      avatarIconColor: Color(0xFFAB94F0),
    ),
    _ReviewItem(
      name: 'มาลีนา',
      category: 'MUSIC',
      rating: 4,
      review: '"เนื้อหาครบถ้วน คุ้มค่ามากค่ะ"',
      avatarColor: Color(0xFFFFF3E8),
      avatarIconColor: Color(0xFFFF9F50),
    ),
    _ReviewItem(
      name: 'ศุภชัย',
      category: 'COOKING',
      rating: 5,
      review: '"ทำตามได้เลย เพื่อนชมชอบมาก"',
      avatarColor: Color(0xFFFFEDF5),
      avatarIconColor: Color(0xFFFF7EB3),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopBar(),
              _buildGreeting(),
              SizedBox(height: 16.h),
              _buildSearchBar(),
              SizedBox(height: 24.h),
              _buildCategoriesSection(),
              SizedBox(height: 28.h),
              _buildRecommendedSection(),
              SizedBox(height: 28.h),
              _buildReviewsSection(),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // ─── Top App Bar ──────────────────────────────────────────────────────────
  Widget _buildTopBar() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 4.h),
      child: Row(
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: _teal, width: 2),
            ),
            child: ClipOval(
              child: Container(
                color: _tealLight,
                child: Icon(Icons.person_rounded, color: _teal, size: 24.sp),
              ),
            ),
          ),
          SizedBox(width: 10.w),
          Text(
            'Lumina Learn',
            style: GoogleFonts.poppins(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: _textDark,
            ),
          ),
          const Spacer(),
          _TopIconButton(icon: Icons.shopping_cart_outlined, onTap: () {}),
          SizedBox(width: 6.w),
          _TopIconButton(
            icon: Icons.notifications_outlined,
            hasBadge: true,
            onTap: () => context.go('/home/notifications'),
          ),
        ],
      ),
    );
  }

  // ─── Greeting ─────────────────────────────────────────────────────────────
  Widget _buildGreeting() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'สวัสดีตอนเช้า ',
                style: GoogleFonts.notoSansThai(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700,
                  color: _textDark,
                ),
              ),
              Text('👋', style: TextStyle(fontSize: 24.sp)),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            'วันนี้อยากเรียนรู้อะไรใหม่ๆ ดีนะ?',
            style: GoogleFonts.notoSansThai(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: _textMid,
            ),
          ),
        ],
      ),
    );
  }

  // ─── Search Bar ───────────────────────────────────────────────────────────
  Widget _buildSearchBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Container(
        height: 48.h,
        decoration: BoxDecoration(
          color: _cardBg,
          borderRadius: BorderRadius.circular(14.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            SizedBox(width: 14.w),
            Icon(Icons.search_rounded, color: _textMid, size: 20.sp),
            SizedBox(width: 10.w),
            Expanded(
              child: TextField(
                style: GoogleFonts.notoSansThai(
                  fontSize: 14.sp,
                  color: _textDark,
                ),
                decoration: InputDecoration(
                  hintText: 'ค้นหาคอร์สที่คุณสนใจ...',
                  hintStyle: GoogleFonts.notoSansThai(
                    fontSize: 14.sp,
                    color: _textMid,
                  ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  filled: false,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Categories ───────────────────────────────────────────────────────────
  Widget _buildCategoriesSection() {
    return SizedBox(
      height: 125.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        itemCount: _categories.length,
        separatorBuilder: (_, i) => SizedBox(width: 16.w),
        itemBuilder: (context, index) =>
            _buildCategoryItem(_categories[index]),
      ),
    );
  }

  Widget _buildCategoryItem(_CategoryItem item) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 60.w,
          height: 60.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: item.bgColor,
          ),
          child: Icon(item.icon, color: item.iconColor, size: 28.sp),
        ),
        SizedBox(height: 8.h),
        Text(
          item.label,
          style: GoogleFonts.notoSansThai(
            fontSize: 11.sp,
            fontWeight: FontWeight.w500,
            color: _textDark,
          ),
        ),
      ],
    );
  }

  // ─── Recommended Courses ──────────────────────────────────────────────────
  Widget _buildRecommendedSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'คอร์สแนะนำสำหรับคุณ',
                  style: GoogleFonts.notoSansThai(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: _textDark,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => context.go('/home/courses'),
                child: Text(
                  'ดูทั้งหมด',
                  style: GoogleFonts.notoSansThai(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: _teal,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 14.h),
        SizedBox(
          height: 245.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            itemCount: _courses.length,
            separatorBuilder: (_, i) => SizedBox(width: 14.w),
            itemBuilder: (context, index) =>
                _buildCourseCardWidget(_courses[index]),
          ),
        ),
      ],
    );
  }

  Widget _buildCourseCardWidget(_CourseCard course) {
    return GestureDetector(
      onTap: () => context.go('/home/courses'),
      child: Container(
        width: 180.w,
        decoration: BoxDecoration(
          color: _cardBg,
          borderRadius: BorderRadius.circular(18.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 108.h,
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(18.r)),
                gradient: LinearGradient(
                  colors: course.gradientColors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: -10,
                    bottom: -10,
                    child: Icon(
                      course.iconData,
                      size: 80.sp,
                      color: Colors.white.withValues(alpha: 0.2),
                    ),
                  ),
                  if (course.badge.isNotEmpty)
                    Positioned(
                      top: 10.h,
                      right: 10.w,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.w, vertical: 3.h),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Text(
                          course.badge,
                          style: GoogleFonts.poppins(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w700,
                            color: _teal,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(12.w, 10.h, 12.w, 8.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.category,
                    style: GoogleFonts.poppins(
                      fontSize: 9.sp,
                      fontWeight: FontWeight.w600,
                      color: _textMid,
                      letterSpacing: 0.8,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    course.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.notoSansThai(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                      color: _textDark,
                      height: 1.35,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Icon(Icons.access_time_rounded,
                          size: 12.sp, color: _textMid),
                      SizedBox(width: 3.w),
                      Text(
                        course.hours,
                        style: GoogleFonts.notoSansThai(
                            fontSize: 11.sp, color: _textMid),
                      ),
                      const Spacer(),
                      Icon(Icons.star_rounded,
                          size: 12.sp, color: Color(0xFFFFC107)),
                      SizedBox(width: 2.w),
                      Text(
                        course.rating.toStringAsFixed(1),
                        style: GoogleFonts.poppins(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                          color: _textDark,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Reviews Section ──────────────────────────────────────────────────────
  Widget _buildReviewsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Text(
            'รีวิวจากผู้เรียน',
            style: GoogleFonts.notoSansThai(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: _textDark,
            ),
          ),
        ),
        SizedBox(height: 14.h),
        SizedBox(
          height: 215.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            itemCount: _reviews.length,
            separatorBuilder: (_, i) => SizedBox(width: 14.w),
            itemBuilder: (context, index) =>
                _buildReviewCard(_reviews[index]),
          ),
        ),
      ],
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

  Widget _buildReviewCard(_ReviewItem review) {
    return Container(
      width: 220.w,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar + name
          Row(
            children: [
              Container(
                width: 36.w,
                height: 36.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: review.avatarColor,
                ),
                child: Icon(
                  Icons.person_rounded,
                  color: review.avatarIconColor,
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.notoSansThai(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                        color: _textDark,
                      ),
                    ),
                    Text(
                      review.category,
                      style: GoogleFonts.poppins(
                        fontSize: 9.sp,
                        fontWeight: FontWeight.w600,
                        color: _textMid,
                        letterSpacing: 0.6,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          // Stars
          Row(
            children: List.generate(5, (i) {
              return Icon(
                i < review.rating
                    ? Icons.star_rounded
                    : Icons.star_outline_rounded,
                size: 16.sp,
                color: i < review.rating
                    ? const Color(0xFFFFC107)
                    : _textMid,
              );
            }),
          ),
          SizedBox(height: 10.h),
          // Review text
          Expanded(
            child: Text(
              review.review,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.notoSansThai(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: _textDark,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Bottom Navigation ────────────────────────────────────────────────────
  Widget _buildBottomNav() {
    final items = [
      _NavItem(Icons.home_rounded, Icons.home_outlined, 'Home'),
      _NavItem(Icons.menu_book_rounded, Icons.menu_book_outlined, 'Courses'),
      _NavItem(
          Icons.calendar_month_rounded, Icons.calendar_month_outlined, 'Schedule'),
      _NavItem(Icons.person_rounded, Icons.person_outlined, 'Profile'),
    ];

    final routes = ['/home', '/home/courses', '/home/schedule', '/home/profile'];

    return Container(
      decoration: BoxDecoration(
        color: _cardBg,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 76.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (index) {
              final isSelected = _selectedNavIndex == index;
              return GestureDetector(
                onTap: () {
                  setState(() => _selectedNavIndex = index);
                  context.go(routes[index]);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  padding:
                      EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: isSelected ? _tealLight : Colors.transparent,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isSelected
                            ? items[index].activeIcon
                            : items[index].inactiveIcon,
                        size: 22.sp,
                        color: isSelected ? _teal : _textMid,
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        items[index].label,
                        style: GoogleFonts.poppins(
                          fontSize: 10.sp,
                          fontWeight: isSelected
                              ? FontWeight.w700
                              : FontWeight.w400,
                          color: isSelected ? _teal : _textMid,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

// ─── Data classes ─────────────────────────────────────────────────────────────

class _CategoryItem {
  final String label;
  final IconData icon;
  final Color iconColor;
  final Color bgColor;
  const _CategoryItem(this.label, this.icon, this.iconColor, this.bgColor);
}

class _CourseCard {
  final String badge;
  final String category;
  final String title;
  final String hours;
  final double rating;
  final List<Color> gradientColors;
  final IconData iconData;
  const _CourseCard({
    required this.badge,
    required this.category,
    required this.title,
    required this.hours,
    required this.rating,
    required this.gradientColors,
    required this.iconData,
  });
}

class _ReviewItem {
  final String name;
  final String category;
  final int rating;
  final String review;
  final Color avatarColor;
  final Color avatarIconColor;
  const _ReviewItem({
    required this.name,
    required this.category,
    required this.rating,
    required this.review,
    required this.avatarColor,
    required this.avatarIconColor,
  });
}

class _NavItem {
  final IconData activeIcon;
  final IconData inactiveIcon;
  final String label;
  const _NavItem(this.activeIcon, this.inactiveIcon, this.label);
}

// ─── Top Icon Button ──────────────────────────────────────────────────────────
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
          color: _cardBg,
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
            Icon(icon, color: _textDark, size: 20.sp),
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
