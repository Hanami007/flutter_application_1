import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/common_widgets.dart';
import '../../../courses/domain/providers/course_provider.dart';
import '../../../enrollment/domain/providers/enrollment_provider.dart';
import '../../../enrollment/domain/entities/enrollment.dart';
import '../../../courses/domain/entities/course.dart';

// ─── Unified Color Palette ───────────────────────────────────────────────────
const _teal = Color(0xFF2DC9A8);
const _tealLight = Color(0xFFE6F9F5);
const _textDark = Color(0xFF1A1F36);
const _textMid = Color(0xFF6E7A9A);
const _bgColor = Color(0xFFF7F9FC);
const _cardBg = Color(0xFFFFFFFF);

class CourseDetailScreen extends ConsumerWidget {
  final String courseId;

  const CourseDetailScreen({
    required this.courseId,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final courseAsync = ref.watch(courseDetailsProvider(courseId));

    return courseAsync.when(
      data: (course) => _CourseDetailBody(course: course),
      loading: () => const Scaffold(body: LoadingWidget()),
      error: (error, _) => Scaffold(
        body: Center(child: Text(error.toString())),
      ),
    );
  }
}

class _CourseDetailBody extends ConsumerWidget {
  final Course course;

  const _CourseDetailBody({required this.course});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enrollmentAsync = ref.watch(enrollmentStatusProvider(course.id));
    final progressAsync =
        ref.watch(courseProgressForCourseProvider(course.id));
    final isFavorite = ref.watch(
        favoriteCourseIdsProvider.select((ids) => ids.contains(course.id)));

    return Scaffold(
      backgroundColor: _bgColor,
      body: CustomScrollView(
        slivers: [
          // Collapsible Header Image with premium circular overlay actions
          SliverAppBar(
            expandedHeight: 240.h,
            pinned: true,
            backgroundColor: _textDark,
            leading: Padding(
              padding: EdgeInsets.all(8.w),
              child: _CircularIconButton(
                icon: Icons.arrow_back_ios_new_rounded,
                onPressed: () => context.pop(),
              ),
            ),
            actions: [
              Padding(
                padding: EdgeInsets.all(8.w),
                child: _CircularIconButton(
                  icon: isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                  iconColor: isFavorite ? Colors.red : _textDark,
                  onPressed: () => ref
                      .read(favoriteCourseIdsProvider.notifier)
                      .toggle(course.id),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: course.thumbnailUrl ??
                        'https://placehold.co/600x300',
                    fit: BoxFit.cover,
                    errorWidget: (_, __, ___) => Container(
                      color: const Color(0xFFE2E8F0),
                      child: Icon(Icons.image, size: 60.sp, color: _textMid),
                    ),
                  ),
                  // Gradient overlay
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.4),
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.6),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Course content details
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Level Badge
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: _tealLight,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Text(
                      course.level.toUpperCase(),
                      style: GoogleFonts.poppins(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w700,
                        color: _teal,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  SizedBox(height: 12.h),

                  // Course Title
                  Text(
                    course.name,
                    style: GoogleFonts.notoSansThai(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w800,
                      color: _textDark,
                      height: 1.3,
                    ),
                  ),
                  SizedBox(height: 8.h),

                  // Rating Row
                  Row(
                    children: [
                      Icon(Icons.star_rounded, size: 18.sp, color: Colors.amber),
                      SizedBox(width: 4.w),
                      Text(
                        '${course.rating}',
                        style: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: _textDark,
                        ),
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        '(${course.totalStudents} รีวิวจากผู้เรียน)',
                        style: GoogleFonts.notoSansThai(
                          fontSize: 13.sp,
                          color: _textMid,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20.h),

                  // Info Stats Grid
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    decoration: BoxDecoration(
                      color: _cardBg,
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatCard('${course.duration} ชม.', 'ระยะเวลาเรียน', Icons.schedule_rounded),
                        _verticalDivider(),
                        _buildStatCard(course.level, 'ระดับวิชา', Icons.bar_chart_rounded),
                        _verticalDivider(),
                        _buildStatCard('${course.totalStudents}', 'จำนวนผู้เรียน', Icons.people_alt_rounded),
                      ],
                    ),
                  ),

                  SizedBox(height: 24.h),

                  // Price Card / Enrollment Status
                  _EnrollmentSection(
                    course: course,
                    enrollmentAsync: enrollmentAsync,
                    progressAsync: progressAsync,
                  ),

                  SizedBox(height: 24.h),

                  // About Course Description
                  Text(
                    'เกี่ยวกับคอร์สนี้',
                    style: GoogleFonts.notoSansThai(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: _textDark,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    course.description,
                    style: GoogleFonts.notoSansThai(
                      fontSize: 14.sp,
                      color: _textMid,
                      height: 1.6,
                    ),
                  ),

                  SizedBox(height: 24.h),

                  // What you'll learn list points
                  Text(
                    "สิ่งที่คุณจะได้รับจากคอร์สนี้",
                    style: GoogleFonts.notoSansThai(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: _textDark,
                    ),
                  ),
                  SizedBox(height: 12.h),
<<<<<<< HEAD
                  _buildLearnPoint('เข้าใจแนวคิดพื้นฐานและเครื่องมือที่สำคัญทั้งหมด'),
                  _buildLearnPoint('ฝึกทำโปรเจกต์จริงเพื่อนำไปต่อยอดทำงานได้จริง'),
                  _buildLearnPoint('รับใบประกาศนียบัตรเมื่อเรียนจบหลักสูตร'),
                  _buildLearnPoint('รับสิทธิ์เข้าร่วมกลุ่มผู้เรียนเพื่อแลกเปลี่ยนความรู้'),
=======
                  if (course.whatYouWillLearn != null && course.whatYouWillLearn!.isNotEmpty)
                    ...course.whatYouWillLearn!.map((point) => _buildLearnPoint(point))
                  else ...[
                    _buildLearnPoint('Master the core concepts and tools'),
                    _buildLearnPoint('Build real-world projects'),
                    _buildLearnPoint('Get industry-recognized certification'),
                    _buildLearnPoint('Join our community of 1,500+ learners'),
                  ],
>>>>>>> da955614eb1b9c1286d32a93be72ed105c6a00d0

                  SizedBox(height: 24.h),

                  // Requirements list points
                  Text(
                    'ความต้องการในการเรียน',
                    style: GoogleFonts.notoSansThai(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: _textDark,
                    ),
                  ),
                  SizedBox(height: 12.h),
<<<<<<< HEAD
                  _buildRequirement('ความรู้พื้นฐานเกี่ยวกับการใช้คอมพิวเตอร์ทั่วไป'),
                  _buildRequirement('มีความพร้อมและความตั้งใจในการเรียนรู้สิ่งใหม่'),
=======
                  if (course.requirements != null && course.requirements!.isNotEmpty)
                    ...course.requirements!.map((req) => _buildRequirement(req))
                  else ...[
                    _buildRequirement('Basic computer knowledge'),
                    _buildRequirement('A passion for learning'),
                  ],
>>>>>>> da955614eb1b9c1286d32a93be72ed105c6a00d0

                  SizedBox(height: 32.h),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _CourseCTABar(
        course: course,
        enrollmentAsync: enrollmentAsync,
        progressAsync: progressAsync,
      ),
    );
  }

  Widget _buildStatCard(String value, String label, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 22.sp, color: _teal),
        SizedBox(height: 6.h),
        Text(
          value,
          style: GoogleFonts.notoSansThai(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            color: _textDark,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.notoSansThai(fontSize: 11.sp, color: _textMid),
        ),
      ],
    );
  }

  Widget _verticalDivider() => Container(
        height: 36.h,
        width: 1,
        color: const Color(0xFFE2E8F0),
      );

  Widget _buildLearnPoint(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 22.w,
            height: 22.w,
            margin: EdgeInsets.only(top: 2.h),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: _tealLight,
            ),
            child: Icon(Icons.check, size: 13.sp, color: _teal),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.notoSansThai(
                fontSize: 14.sp,
                color: _textDark,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequirement(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 18.w,
            height: 18.w,
            margin: EdgeInsets.only(top: 3.h),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFCBD5E0), width: 1.5),
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Center(
              child: Container(
                width: 8.w,
                height: 8.w,
                decoration: const BoxDecoration(
                  color: _teal,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.notoSansThai(
                fontSize: 14.sp,
                color: _textMid,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CircularIconButton extends StatelessWidget {
  final IconData icon;
  final Color? iconColor;
  final VoidCallback onPressed;

  const _CircularIconButton({
    required this.icon,
    this.iconColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, color: iconColor ?? _textDark, size: 18.sp),
        padding: EdgeInsets.zero,
        onPressed: onPressed,
      ),
    );
  }
}

// ─── Enrollment Section Builder ──────────────────────────────────────────────
class _EnrollmentSection extends ConsumerWidget {
  final Course course;
  final AsyncValue<Enrollment?> enrollmentAsync;
  final AsyncValue<CourseProgress?> progressAsync;

  const _EnrollmentSection({
    required this.course,
    required this.enrollmentAsync,
    required this.progressAsync,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return enrollmentAsync.when(
      data: (enrollment) {
        if (enrollment == null) {
          return _PriceCard(course: course);
        }
        return progressAsync.when(
          data: (progress) => _EnrollmentInfoCard(
              course: course, enrollment: enrollment, progress: progress),
          loading: () => _EnrollmentInfoCard(
              course: course, enrollment: enrollment, progress: null),
          error: (_, __) => _EnrollmentInfoCard(
              course: course, enrollment: enrollment, progress: null),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => _PriceCard(course: course),
    );
  }
}

class _PriceCard extends StatelessWidget {
  final Course course;

  const _PriceCard({required this.course});

  @override
  Widget build(BuildContext context) {
    final double originalPrice = course.price * 1.5;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: const BoxDecoration(
              color: _tealLight,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.local_offer_rounded, color: _teal, size: 20.sp),
          ),
          SizedBox(width: 14.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ราคาพิเศษวันนี้',
                style: GoogleFonts.notoSansThai(fontSize: 12.sp, color: _textMid),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    '฿${course.price.toStringAsFixed(0)}',
                    style: GoogleFonts.poppins(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w800,
                      color: _textDark,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    '฿${originalPrice.toStringAsFixed(0)}',
                    style: GoogleFonts.poppins(
                      fontSize: 13.sp,
                      color: _textMid,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: const Color(0xFFE6F4EA),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Text(
              'ซื้อขาดครั้งเดียว',
              style: GoogleFonts.notoSansThai(
                fontSize: 11.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF137333),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EnrollmentInfoCard extends StatelessWidget {
  final Course course;
  final Enrollment enrollment;
  final CourseProgress? progress;

  const _EnrollmentInfoCard({
    required this.course,
    required this.enrollment,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final pct = progress?.progressPercentage ?? 0.0;
    final displayPct = pct > 1.0 ? pct : pct * 100;
    final isCompleted = displayPct >= 100;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: _tealLight,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: _teal.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.verified_rounded, color: _teal, size: 22.sp),
              SizedBox(width: 8.w),
              Text(
                isCompleted ? 'เรียนสำเร็จแล้ว 🎉' : 'คุณลงทะเบียนคอร์สนี้แล้ว!',
                style: GoogleFonts.notoSansThai(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                  color: _teal,
                ),
              ),
            ],
          ),
          if (progress != null && !isCompleted) ...[
            SizedBox(height: 12.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'ความคืบหน้าการเรียน ${displayPct.toStringAsFixed(0)}%',
                  style: GoogleFonts.notoSansThai(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: _textDark,
                  ),
                ),
                Text(
                  '${progress!.videosWatched}/${progress!.videosTotal} บทเรียน',
                  style: GoogleFonts.notoSansThai(fontSize: 12.sp, color: _textMid),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            ClipRRect(
              borderRadius: BorderRadius.circular(4.r),
              child: LinearProgressIndicator(
                value: (displayPct / 100).clamp(0.0, 1.0),
                minHeight: 6.h,
                backgroundColor: const Color(0xFFE2E8F0),
                valueColor: const AlwaysStoppedAnimation<Color>(_teal),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ─── CTA Bottom Bar ──────────────────────────────────────────────────────────
class _CourseCTABar extends ConsumerWidget {
  final Course course;
  final AsyncValue<Enrollment?> enrollmentAsync;
  final AsyncValue<CourseProgress?> progressAsync;

  const _CourseCTABar({
    required this.course,
    required this.enrollmentAsync,
    required this.progressAsync,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final purchaseState = ref.watch(purchaseCourseProvider);

    return enrollmentAsync.when(
      data: (enrollment) {
        if (enrollment == null) {
          return _buildBottomBar(
            child: SizedBox(
              width: double.infinity,
              height: 48.h,
              child: ElevatedButton(
                onPressed: purchaseState is AsyncLoading
                    ? null
                    : () => context.go('/home/booking/${course.id}'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _teal,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24.r),
                  ),
                ),
                child: Text(
                  'สมัครเรียนคอร์สนี้  –  ฿${course.price.toStringAsFixed(0)}',
                  style: GoogleFonts.notoSansThai(fontSize: 15.sp, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          );
        }

        return progressAsync.when(
          data: (progress) {
            final pct = progress?.progressPercentage ?? 0.0;
            final displayPct = pct > 1.0 ? pct : pct * 100;
            final hasStarted = displayPct > 0;
            final isCompleted = displayPct >= 100;

            if (isCompleted) {
              return _buildBottomBar(
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 48.h,
                        child: ElevatedButton(
                          onPressed: () => context.go('/home/learning/${course.id}'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF59E0B),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24.r),
                            ),
                          ),
                          child: Text(
                            '🏆  รีวิวคอร์สเรียน',
                            style: GoogleFonts.notoSansThai(fontSize: 15.sp, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    _CertificateButton(courseId: course.id),
                  ],
                ),
              );
            } else if (hasStarted) {
              return _buildBottomBar(
                child: SizedBox(
                  width: double.infinity,
                  height: 48.h,
                  child: ElevatedButton(
                    onPressed: () => context.go('/home/learning/${course.id}'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _teal,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.r),
                      ),
                    ),
                    child: Text(
                      '▶  เรียนต่อจากเดิม  –  ${displayPct.toStringAsFixed(0)}%',
                      style: GoogleFonts.notoSansThai(fontSize: 15.sp, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              );
            } else {
              return _buildBottomBar(
                child: SizedBox(
                  width: double.infinity,
                  height: 48.h,
                  child: ElevatedButton(
                    onPressed: () => context.go('/home/learning/${course.id}'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0F7A5F),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.r),
                      ),
                    ),
                    child: Text(
                      '🎓  เริ่มเรียนเลย',
                      style: GoogleFonts.notoSansThai(fontSize: 15.sp, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              );
            }
          },
          loading: () => _buildBottomBar(
            child: SizedBox(
              width: double.infinity,
              height: 48.h,
              child: ElevatedButton(
                onPressed: () => context.go('/home/learning/${course.id}'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0F7A5F),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24.r),
                  ),
                ),
                child: Text(
                  '🎓  เริ่มเรียนเลย',
                  style: GoogleFonts.notoSansThai(fontSize: 15.sp, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          error: (_, __) => _buildBottomBar(
            child: SizedBox(
              width: double.infinity,
              height: 48.h,
              child: ElevatedButton(
                onPressed: () => context.go('/home/learning/${course.id}'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0F7A5F),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24.r),
                  ),
                ),
                child: Text(
                  '🎓  เริ่มเรียนเลย',
                  style: GoogleFonts.notoSansThai(fontSize: 15.sp, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        );
      },
      loading: () => _buildBottomBar(
        child: SizedBox(
          width: double.infinity,
          height: 48.h,
          child: ElevatedButton(
            onPressed: null,
            style: ElevatedButton.styleFrom(
              backgroundColor: _teal,
              disabledBackgroundColor: _teal.withValues(alpha: 0.5),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.r),
              ),
            ),
            child: Text(
              'กำลังโหลด...',
              style: GoogleFonts.notoSansThai(fontSize: 15.sp, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
        ),
      ),
      error: (_, __) => _buildBottomBar(
        child: SizedBox(
          width: double.infinity,
          height: 48.h,
          child: ElevatedButton(
            onPressed: () => context.go('/home/booking/${course.id}'),
            style: ElevatedButton.styleFrom(
              backgroundColor: _teal,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.r),
              ),
            ),
            child: Text(
              'สมัครเรียนคอร์สนี้  –  ฿${course.price.toStringAsFixed(0)}',
              style: GoogleFonts.notoSansThai(fontSize: 15.sp, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomBar({required Widget child}) {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _CertificateButton extends StatelessWidget {
  final String courseId;

  const _CertificateButton({required this.courseId});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48.h,
      width: 48.h,
      child: ElevatedButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('กำลังดำเนินการดาวน์โหลดเกียรติบัตร...')),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFF59E0B).withValues(alpha: 0.15),
          foregroundColor: const Color(0xFFF59E0B),
          elevation: 0,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
            side: const BorderSide(color: Color(0xFFF59E0B), width: 1.5),
          ),
        ),
        child: Icon(Icons.workspace_premium_rounded, size: 22.sp),
      ),
    );
  }
}
