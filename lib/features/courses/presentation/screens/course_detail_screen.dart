import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/common_widgets.dart';
import '../../../courses/domain/providers/course_provider.dart';
import '../../../enrollment/domain/providers/enrollment_provider.dart';
import '../../../enrollment/domain/entities/enrollment.dart';
import '../../../courses/domain/entities/course.dart';
import '../../../notifications/domain/entities/app_notification.dart';
import '../../../notifications/domain/providers/notification_provider.dart';

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
      backgroundColor: AppTheme.backgroundColor,
      body: CustomScrollView(
        slivers: [
          // Hero AppBar with Thumbnail
          SliverAppBar(
            expandedHeight: 240.h,
            pinned: true,
            backgroundColor: AppTheme.darkGrey,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () => context.pop(),
            ),
            actions: [
              // Favorite Button
              IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : Colors.white,
                ),
                onPressed: () => ref
                    .read(favoriteCourseIdsProvider.notifier)
                    .toggle(course.id),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: course.thumbnailUrl ??
                        'https://via.placeholder.com/600x300',
                    fit: BoxFit.cover,
                    errorWidget: (_, __, ___) => Container(
                      color: AppTheme.veryLightGrey,
                      child: Icon(Icons.image, size: 60.sp,
                          color: AppTheme.mediumGrey),
                    ),
                  ),
                  // Gradient overlay
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Course Content
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(AppTheme.spacingMd),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Level Badge
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 10.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      borderRadius:
                          BorderRadius.circular(AppTheme.radiusSm),
                    ),
                    child: Text(
                      course.level,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),

                  // Course Name
                  Text(
                    course.name,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  SizedBox(height: 8.h),

                  // Rating row
                  Row(
                    children: [
                      Icon(Icons.star, size: 16.sp, color: Colors.amber),
                      SizedBox(width: 4.w),
                      Text(
                        '${course.rating}',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.darkGrey,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        '(${course.totalStudents} reviews)',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: AppTheme.mediumGrey,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20.h),

                  // Stats Row
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceColor,
                      borderRadius:
                          BorderRadius.circular(AppTheme.radiusMd),
                      boxShadow: AppTheme.softShadow,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatCard(
                            '${course.duration}h', 'Duration', Icons.schedule),
                        _verticalDivider(),
                        _buildStatCard(
                            course.level, 'Level', Icons.signal_cellular_alt),
                        _verticalDivider(),
                        _buildStatCard('${course.totalStudents}', 'Students',
                            Icons.group),
                      ],
                    ),
                  ),

                  SizedBox(height: 24.h),

                  // Price / Enrollment Section (dynamic)
                  _EnrollmentSection(
                    course: course,
                    enrollmentAsync: enrollmentAsync,
                    progressAsync: progressAsync,
                  ),

                  SizedBox(height: 24.h),

                  // Description
                  Text(
                    'About Course',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    course.description,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),

                  SizedBox(height: 24.h),

                  // What You'll Learn
                  Text(
                    "What You'll Learn",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  SizedBox(height: 12.h),
                  _buildLearnPoint('Master the core concepts and tools'),
                  _buildLearnPoint('Build real-world projects'),
                  _buildLearnPoint('Get industry-recognized certification'),
                  _buildLearnPoint('Join our community of 1,500+ learners'),

                  SizedBox(height: 24.h),

                  // Requirements
                  Text(
                    'Requirements',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  SizedBox(height: 12.h),
                  _buildRequirement('Basic computer knowledge'),
                  _buildRequirement('A passion for learning'),

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
        Icon(icon, size: 20.sp, color: AppTheme.primaryColor),
        SizedBox(height: 4.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            color: AppTheme.darkGrey,
          ),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 11.sp, color: AppTheme.mediumGrey),
        ),
      ],
    );
  }

  Widget _verticalDivider() => Container(
        height: 40.h,
        width: 1,
        color: AppTheme.lightGrey,
      );

  Widget _buildLearnPoint(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        children: [
          Container(
            width: 24.w,
            height: 24.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.successColor.withOpacity(0.1),
            ),
            child: Icon(Icons.check, size: 14.sp, color: AppTheme.successColor),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14.sp,
                color: AppTheme.darkGrey,
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
        children: [
          Container(
            width: 20.w,
            height: 20.w,
            decoration: BoxDecoration(
              border: Border.all(color: AppTheme.lightGrey),
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Center(
              child: Container(
                width: 8.w,
                height: 8.w,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 14.sp, color: AppTheme.mediumGrey),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Price / Enrollment Info Section (inline)
// ─────────────────────────────────────────────

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
          // NOT purchased — show price card
          return _PriceCard(course: course);
        }
        // Purchased — show enrollment info
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
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryColor.withOpacity(0.08),
            AppTheme.secondaryColor.withOpacity(0.06),
          ],
        ),
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        border: Border.all(
            color: AppTheme.primaryColor.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(Icons.local_offer, color: AppTheme.primaryColor, size: 24.sp),
          SizedBox(width: 12.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Course Price',
                style: TextStyle(
                    fontSize: 12.sp, color: AppTheme.mediumGrey),
              ),
              Text(
                '฿${course.price.toStringAsFixed(0)}',
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.primaryColor,
                ),
              ),
            ],
          ),
          const Spacer(),
          Container(
            padding:
                EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: AppTheme.successColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppTheme.radiusSm),
            ),
            child: Text(
              'One-time',
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                color: AppTheme.successColor,
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
        color: AppTheme.successColor.withOpacity(0.07),
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        border: Border.all(color: AppTheme.successColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.verified, color: AppTheme.successColor, size: 20.sp),
              SizedBox(width: 8.w),
              Text(
                isCompleted ? 'Course Completed 🎉' : 'You\'re Enrolled!',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.successColor,
                ),
              ),
            ],
          ),
          if (progress != null && !isCompleted) ...[
            SizedBox(height: 10.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${displayPct.toStringAsFixed(0)}% Complete',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.darkGrey,
                  ),
                ),
                Text(
                  '${progress!.videosWatched}/${progress!.videosTotal} lessons',
                  style: TextStyle(
                      fontSize: 12.sp, color: AppTheme.mediumGrey),
                ),
              ],
            ),
            SizedBox(height: 6.h),
            ClipRRect(
              borderRadius: BorderRadius.circular(4.r),
              child: LinearProgressIndicator(
                value: (displayPct / 100).clamp(0.0, 1.0),
                minHeight: 6.h,
                backgroundColor: AppTheme.lightGrey,
                valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Bottom CTA Bar (dynamic button)
// ─────────────────────────────────────────────

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
          // ── NOT PURCHASED ─────────────────────
          return _buildBottomBar(
            child: PrimaryButton(
              text: '  Buy Course  –  ฿${course.price.toStringAsFixed(0)}',
              isLoading: purchaseState is AsyncLoading,
              onPressed: () =>
                  _showPurchaseDialog(context, ref),
            ),
          );
        }

        // ── PURCHASED: check progress ──────────
        return progressAsync.when(
          data: (progress) {
            final pct = progress?.progressPercentage ?? 0.0;
            final displayPct = pct > 1.0 ? pct : pct * 100;
            final hasStarted = displayPct > 0;
            final isCompleted = displayPct >= 100;

            if (isCompleted) {
              // COMPLETED
              return _buildBottomBar(
                child: Row(
                  children: [
                    Expanded(
                      child: PrimaryButton(
                        text: '🏆  Review Course',
                        backgroundColor: const Color(0xFFF59E0B),
                        onPressed: () =>
                            context.go('/home/learning/${course.id}'),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    _CertificateButton(courseId: course.id),
                  ],
                ),
              );
            } else if (hasStarted) {
              // IN PROGRESS
              return _buildBottomBar(
                child: PrimaryButton(
                  text: '▶  Continue Learning  –  ${displayPct.toStringAsFixed(0)}%',
                  onPressed: () =>
                      context.go('/home/learning/${course.id}'),
                ),
              );
            } else {
              // PURCHASED BUT NOT STARTED
              return _buildBottomBar(
                child: PrimaryButton(
                  text: '🎓  Start Learning',
                  backgroundColor: AppTheme.successColor,
                  onPressed: () =>
                      context.go('/home/learning/${course.id}'),
                ),
              );
            }
          },
          loading: () => _buildBottomBar(
            child: PrimaryButton(
              text: '🎓  Start Learning',
              backgroundColor: AppTheme.successColor,
              onPressed: () => context.go('/home/learning/${course.id}'),
            ),
          ),
          error: (_, __) => _buildBottomBar(
            child: PrimaryButton(
              text: '🎓  Start Learning',
              backgroundColor: AppTheme.successColor,
              onPressed: () => context.go('/home/learning/${course.id}'),
            ),
          ),
        );
      },
      loading: () => _buildBottomBar(
        child: const PrimaryButton(
          text: 'Loading...',
          isLoading: true,
          onPressed: _noop,
        ),
      ),
      error: (_, __) => _buildBottomBar(
        child: PrimaryButton(
          text: '  Buy Course  –  ฿${course.price.toStringAsFixed(0)}',
          onPressed: () => _showPurchaseDialog(context, ref),
        ),
      ),
    );
  }

  Widget _buildBottomBar({required Widget child}) {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: child,
    );
  }

  void _showPurchaseDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => _PurchaseDialog(
        course: course,
        onConfirm: () async {
          Navigator.of(ctx).pop();
          final success = await ref
              .read(purchaseCourseProvider.notifier)
              .purchase(course.id);
          if (success && context.mounted) {
            // Add notifications to the notification centre
            final notif = ref.read(notificationProvider.notifier);
            notif.add(AppNotification.paymentSuccess(
              courseName: course.name,
              amount: course.price,
            ));
            notif.add(AppNotification.enrollmentConfirmed(
              courseName: course.name,
            ));

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text(
                    '🎉 ชำระเงินสำเร็จ! คุณสามารถเริ่มเรียนได้แล้ว'),
                backgroundColor: AppTheme.successColor,
                duration: const Duration(seconds: 3),
              ),
            );
          }
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Purchase Confirmation Dialog
// ─────────────────────────────────────────────

class _PurchaseDialog extends StatelessWidget {
  final Course course;
  final VoidCallback onConfirm;

  const _PurchaseDialog({required this.course, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusLg)),
      contentPadding: EdgeInsets.all(24.w),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon
          Container(
            width: 64.w,
            height: 64.w,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.shopping_cart, size: 32.sp,
                color: AppTheme.primaryColor),
          ),
          SizedBox(height: 16.h),
          Text(
            'Confirm Purchase',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: AppTheme.darkGrey,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            course.name,
            textAlign: TextAlign.center,
            maxLines: 2,
            style: TextStyle(fontSize: 13.sp, color: AppTheme.mediumGrey),
          ),
          SizedBox(height: 16.h),
          Container(
            padding:
                EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: AppTheme.veryLightGrey,
              borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total',
                    style: TextStyle(
                        fontSize: 14.sp, color: AppTheme.mediumGrey)),
                Text(
                  '฿${course.price.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppTheme.radiusMd)),
                  ),
                  child: Text('Cancel',
                      style: TextStyle(fontSize: 14.sp)),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: ElevatedButton(
                  onPressed: onConfirm,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppTheme.radiusMd)),
                  ),
                  child: Text('Confirm',
                      style: TextStyle(
                          fontSize: 14.sp, fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Certificate Quick Button
// ─────────────────────────────────────────────

class _CertificateButton extends ConsumerWidget {
  final String courseId;

  const _CertificateButton({required this.courseId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 48.h,
      child: ElevatedButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Certificate download coming soon!')),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFF59E0B).withOpacity(0.15),
          foregroundColor: const Color(0xFFF59E0B),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            side: const BorderSide(color: Color(0xFFF59E0B), width: 1.5),
          ),
        ),
        child: Icon(Icons.workspace_premium, size: 22.sp),
      ),
    );
  }
}

void _noop() {}
