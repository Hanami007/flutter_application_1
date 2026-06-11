import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../courses/domain/entities/course.dart';
import '../../../courses/domain/providers/course_provider.dart';
import '../../../enrollment/domain/providers/enrollment_provider.dart';
import '../../domain/entities/video_lesson.dart';
import '../../domain/providers/learning_provider.dart';
import '../widgets/lesson_tile.dart';
import '../widgets/completion_banner.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../notifications/domain/entities/app_notification.dart';
import '../../../notifications/domain/providers/notification_provider.dart';
import 'package:learn_hub/shared/widgets/common_widgets.dart';

/// Full course learning screen with video player, lesson list, and progress tracking.
class CoursePlayerScreen extends ConsumerStatefulWidget {
  final String courseId;
  final String? initialVideoId;

  const CoursePlayerScreen({
    super.key,
    required this.courseId,
    this.initialVideoId,
  });

  @override
  ConsumerState<CoursePlayerScreen> createState() => _CoursePlayerScreenState();
}

class _CoursePlayerScreenState extends ConsumerState<CoursePlayerScreen>
    with TickerProviderStateMixin {
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;
  VideoLesson? _currentLesson;
  bool _isLoadingVideo = false;
  bool _showCompletionBanner = false;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _disposeVideo();
    _tabController.dispose();
    super.dispose();
  }

  void _disposeVideo() {
    if (_videoController != null) {
      try {
        _videoController!.removeListener(_videoListener);
      } catch (_) {}
      _videoController!.dispose();
    }
    _chewieController?.dispose();
    _chewieController = null;
    _videoController = null;
  }

  void _videoListener() {
    final controller = _videoController;
    final lesson = _currentLesson;
    if (controller == null || lesson == null) return;

    if (controller.value.isInitialized &&
        controller.value.position >= controller.value.duration &&
        !controller.value.isPlaying) {
      controller.removeListener(_videoListener);

      final watchedIds = ref.read(watchedLessonIdsProvider(widget.courseId));
      final lessons = ref.read(videoLessonsProvider(widget.courseId)).valueOrNull;

      if (lessons != null) {
        if (!watchedIds.contains(lesson.id)) {
          _markComplete(lessons, watchedIds);
        } else {
          // Already watched, but we still auto-advance if there is a next lesson
          final currentIdx = lessons.indexWhere((l) => l.id == lesson.id);
          if (currentIdx != -1 && currentIdx < lessons.length - 1) {
            _loadVideo(lessons[currentIdx + 1]);
          }
        }
      }
    }
  }

  bool _isDirectVideoUrl(String url) {
    final cleanUrl = url.toLowerCase().trim();
    return cleanUrl.contains('.mp4') ||
        cleanUrl.contains('.m3u8') ||
        cleanUrl.contains('.mov') ||
        cleanUrl.contains('.webm') ||
        cleanUrl.contains('.avi') ||
        cleanUrl.endsWith('.mp4') ||
        cleanUrl.contains('/video/') ||
        cleanUrl.contains('assets.mixkit.co');
  }

  Future<void> _loadVideo(VideoLesson lesson) async {
    if (_currentLesson?.id == lesson.id) return;

    _disposeVideo();

    if (!_isDirectVideoUrl(lesson.videoUrl)) {
      setState(() {
        _currentLesson = lesson;
        _isLoadingVideo = false;
      });
      return;
    }

    setState(() => _isLoadingVideo = true);

    try {
      _videoController = VideoPlayerController.networkUrl(
        Uri.parse(lesson.videoUrl),
      );
      await _videoController!.initialize();
      _videoController!.addListener(_videoListener);
      _chewieController = ChewieController(
        videoPlayerController: _videoController!,
        autoPlay: true,
        looping: false,
        allowFullScreen: true,
        allowMuting: true,
        showControls: true,
        materialProgressColors: ChewieProgressColors(
          playedColor: AppTheme.primaryColor,
          handleColor: AppTheme.primaryColor,
          backgroundColor: AppTheme.lightGrey,
          bufferedColor: AppTheme.primaryColor.withOpacity(0.3),
        ),
        placeholder: Container(color: Colors.black),
      );
      setState(() {
        _currentLesson = lesson;
        _isLoadingVideo = false;
      });
    } catch (e) {
      setState(() => _isLoadingVideo = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not load video: $e'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }

  Future<void> _markComplete(
      List<VideoLesson> allLessons, Set<String> watchedIds) async {
    if (_currentLesson == null) return;

    ref
        .read(watchedLessonIdsProvider(widget.courseId).notifier)
        .markWatched(_currentLesson!.id);

    final newWatched = {...watchedIds, _currentLesson!.id};
    final total = allLessons.length;
    final watched = newWatched.length;

    await ref.read(progressUpdateProvider.notifier).updateProgress(
          courseId: widget.courseId,
          videosWatched: watched,
          videosTotal: total,
        );

    // Update last accessed
    final userId = ref.read(currentUserIdProvider);
    await ref
        .read(enrollmentRepositoryProvider)
        .updateLastAccessed(userId, widget.courseId);

    if (watched >= total && mounted) {
      setState(() => _showCompletionBanner = true);
    } else {
      // Auto-advance to next lesson
      final currentIdx =
          allLessons.indexWhere((l) => l.id == _currentLesson!.id);
      if (currentIdx < allLessons.length - 1) {
        await _loadVideo(allLessons[currentIdx + 1]);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final courseAsync = ref.watch(courseDetailsProvider(widget.courseId));
    final lessonsAsync = ref.watch(videoLessonsProvider(widget.courseId));
    final progressAsync =
        ref.watch(courseProgressForCourseProvider(widget.courseId));
    final watchedIds = ref.watch(watchedLessonIdsProvider(widget.courseId));
    final isFavorite = ref.watch(favoriteCourseIdsProvider
        .select((ids) => ids.contains(widget.courseId)));

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: courseAsync.when(
        data: (course) => lessonsAsync.when(
          data: (lessons) => _buildContent(
              course, lessons, progressAsync.valueOrNull, watchedIds, isFavorite),
          loading: () => const Center(child: LoadingWidget(message: 'กำลังโหลดบทเรียน...')),
          error: (e, _) => Center(child: Text(e.toString())),
        ),
        loading: () => const Center(child: LoadingWidget(message: 'กำลังโหลดคอร์ส...')),
        error: (e, _) => Center(child: Text(e.toString())),
      ),
    );
  }

  Widget _buildContent(
    Course course,
    List<VideoLesson> lessons,
    CourseProgress? progress,
    Set<String> watchedIds,
    bool isFavorite,
  ) {
    // Auto-select initial video
    if (_currentLesson == null && lessons.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        VideoLesson initial;
        if (widget.initialVideoId != null) {
          try {
            initial = lessons
                .firstWhere((l) => l.id == widget.initialVideoId);
          } catch (_) {
            initial = lessons.first;
          }
        } else if (progress != null && progress.videosWatched > 0) {
          // Resume from last unwatched
          final idx = (progress.videosWatched).clamp(0, lessons.length - 1);
          initial = lessons[idx];
        } else {
          initial = lessons.first;
        }
        await _loadVideo(initial);
      });
    }

    final isCompleted = progress != null &&
        (progress.progressPercentage >= 1.0 ||
            (progress.videosTotal > 0 &&
                progress.videosWatched >= progress.videosTotal));
    final progressPct = progress?.progressPercentage ?? 0.0;
    final displayPct =
        progressPct > 1.0 ? progressPct : (progressPct * 100);

    return SafeArea(
      child: Column(
        children: [
          // Pinned Video Player at the top (fixed aspect ratio, stays visible)
          AspectRatio(
            aspectRatio: 16 / 9,
            child: _buildVideoPlayerHeader(course, isFavorite),
          ),
          
          // Scrollable Content Below Video
          Expanded(
            child: Column(
              children: [
                // Modern Gradient Progress Card
                _buildProgressSection(displayPct, progress),

                // Lesson Navigation & Selector Bar
                _buildLessonNavigation(lessons, watchedIds),

                // Completion Banner
                if ((isCompleted || _showCompletionBanner))
                  CompletionBanner(
                    courseName: course.name,
                    onViewCertificate: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content:
                              Text('ระบบดาวน์โหลดเกียรติบัตรกำลังเปิดใช้งานเร็วๆ นี้!'),
                        ),
                      );
                    },
                    onReviewCourse: () => _showReviewDialog(context, course.name),
                  ),

                // Premium Segmented TabBar
                Container(
                  color: AppTheme.surfaceColor,
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  child: Container(
                    height: 38.h,
                    decoration: BoxDecoration(
                      color: AppTheme.veryLightGrey,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      labelColor: AppTheme.primaryColor,
                      unselectedLabelColor: AppTheme.mediumGrey,
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicator: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      tabs: [
                        Tab(
                          child: Text(
                            'บทเรียน (${lessons.length})',
                            style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Tab(
                          child: Text(
                            'เกี่ยวกับคอร์ส',
                            style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Tabs Content
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildLessonsList(lessons, watchedIds),
                      _buildAboutTab(course),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Mark Complete Button
          if (_currentLesson != null &&
              !watchedIds.contains(_currentLesson!.id) &&
              !(isCompleted || _showCompletionBanner))
            _buildMarkCompleteButton(lessons, watchedIds),
        ],
      ),
    );
  }

  Widget _buildVideoPlayerHeader(Course course, bool isFavorite) {
    return Stack(
      children: [
        _buildVideoPlayer(),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black.withOpacity(0.7), Colors.transparent],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
                  onPressed: () => context.pop(),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: Text(
                    course.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      shadows: const [
                        Shadow(color: Colors.black45, blurRadius: 4, offset: Offset(0, 1)),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : Colors.white,
                  ),
                  onPressed: () =>
                      ref.read(favoriteCourseIdsProvider.notifier).toggle(widget.courseId),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVideoPlayer() {
    if (_isLoadingVideo) {
      return Container(
        color: Colors.black,
        child: const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
          ),
        ),
      );
    }

    if (_currentLesson == null) {
      return Container(
        color: Colors.black87,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.play_circle_outline_rounded, size: 54.sp, color: Colors.white54),
              SizedBox(height: 8.h),
              Text(
                'กรุณาเลือกบทเรียนเพื่อเริ่มต้นเรียน',
                style: TextStyle(color: Colors.white54, fontSize: 13.sp, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      );
    }

    final type = _currentLesson!.contentType;

    if (type == 'text') {
      return Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: EdgeInsets.all(20.w),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.chrome_reader_mode_rounded, size: 36.sp, color: const Color(0xFF38BDF8)),
              ),
              SizedBox(height: 12.h),
              Text(
                _currentLesson!.title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                'บทเรียนประเภทบทความอ่าน',
                style: TextStyle(color: Colors.white54, fontSize: 11.sp),
              ),
              SizedBox(height: 16.h),
              ElevatedButton.icon(
                onPressed: () => _showTextContentDialog(context, _currentLesson!),
                icon: Icon(Icons.menu_book_rounded, size: 16.sp),
                label: const Text('อ่านเนื้อหาเรียน (Read Lesson)'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (type == 'assignment') {
      return Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF2E2416), Color(0xFF1C1307)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: EdgeInsets.all(20.w),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.06),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.assignment_turned_in_rounded, size: 36.sp, color: const Color(0xFFF59E0B)),
              ),
              SizedBox(height: 12.h),
              Text(
                _currentLesson!.title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                'งานที่ได้รับมอบหมาย (Assignment Task)',
                style: TextStyle(color: Colors.white54, fontSize: 11.sp),
              ),
              SizedBox(height: 16.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _showTextContentDialog(context, _currentLesson!),
                    icon: Icon(Icons.info_outline_rounded, size: 16.sp),
                    label: const Text('คำอธิบายงาน'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white12,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                  ),
                  if (_currentLesson!.videoUrl.isNotEmpty) ...[
                    SizedBox(width: 10.w),
                    ElevatedButton.icon(
                      onPressed: () async {
                        final uri = Uri.parse(_currentLesson!.videoUrl);
                        if (await canLaunchUrl(uri)) {
                          await launchUrl(uri, mode: LaunchMode.externalApplication);
                        }
                      },
                      icon: Icon(Icons.open_in_new_rounded, size: 16.sp),
                      label: const Text('ลิงก์งาน (Link)'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.successColor,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      );
    }

    if (type == 'quiz') {
      return Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF142035), Color(0xFF0B1220)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: EdgeInsets.all(20.w),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.06),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.quiz_rounded, size: 36.sp, color: const Color(0xFF8B5CF6)),
              ),
              SizedBox(height: 12.h),
              Text(
                _currentLesson!.title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                'แบบทดสอบความรู้ (Knowledge Quiz)',
                style: TextStyle(color: Colors.white54, fontSize: 11.sp),
              ),
              SizedBox(height: 16.h),
              ElevatedButton.icon(
                onPressed: () async {
                  if (_currentLesson!.videoUrl.isNotEmpty) {
                    final uri = Uri.parse(_currentLesson!.videoUrl);
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri, mode: LaunchMode.externalApplication);
                    }
                  }
                },
                icon: Icon(Icons.play_arrow_rounded, size: 18.sp),
                label: const Text('เริ่มทำแบบทดสอบ (Start Quiz)'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.successColor,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_chewieController != null) {
      return Container(
        color: Colors.black,
        child: Chewie(controller: _chewieController!),
      );
    }

    if (!_isDirectVideoUrl(_currentLesson!.videoUrl)) {
      return Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(24.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.open_in_new_rounded, size: 36.sp, color: Colors.white),
                ),
                SizedBox(height: 12.h),
                Text(
                  _currentLesson!.title,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'บทเรียนลิงก์ภายนอก (External Link Resource)',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70, fontSize: 11.sp),
                ),
                SizedBox(height: 16.h),
                ElevatedButton.icon(
                  onPressed: () async {
                    final uri = Uri.parse(_currentLesson!.videoUrl);
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri, mode: LaunchMode.externalApplication);
                    }
                  },
                  icon: Icon(Icons.school_rounded, size: 16.sp),
                  label: const Text('เปิดลิงก์เรียนรู้เพิ่มเติม'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.successColor,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Container(
      color: Colors.black87,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.play_circle_outline_rounded, size: 54.sp, color: Colors.white54),
            SizedBox(height: 8.h),
            Text(
              'เลือกบทเรียนเพื่อเริ่มเรียน',
              style: TextStyle(color: Colors.white54, fontSize: 13.sp),
            ),
          ],
        ),
      ),
    );
  }

  void _showTextContentDialog(BuildContext context, VideoLesson lesson) {
    showDialog(
      context: context,
      builder: (context) {
        final isAssignment = lesson.contentType == 'assignment';
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          titlePadding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 10.h),
          contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          actionsPadding: EdgeInsets.fromLTRB(10.w, 5.h, 16.w, 16.h),
          title: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: isAssignment
                      ? const Color(0xFFFBBF24).withOpacity(0.12)
                      : AppTheme.primaryColor.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isAssignment ? Icons.assignment_rounded : Icons.description_rounded,
                  color: isAssignment ? const Color(0xFFD97706) : AppTheme.primaryColor,
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  lesson.title,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.darkGrey,
                  ),
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (lesson.description != null && lesson.description!.isNotEmpty) ...[
                  Text(
                    isAssignment ? 'คำแนะนำ / Instruction' : 'คำอธิบาย / Description',
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.mediumGrey,
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Text(
                      lesson.description!,
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: AppTheme.darkGrey,
                        height: 1.6,
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                ],
                if (lesson.content != null && lesson.content!.isNotEmpty) ...[
                  Text(
                    'เนื้อหาบทเรียน / Content',
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.mediumGrey,
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Text(
                      lesson.content!,
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: AppTheme.darkGrey,
                        height: 1.6,
                      ),
                    ),
                  ),
                ] else if (lesson.contentType == 'text') ...[
                  Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.h),
                      child: Text(
                        'ไม่มีรายละเอียดเนื้อหาเพิ่มเติม',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontStyle: FontStyle.italic,
                          color: AppTheme.mediumGrey,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                foregroundColor: AppTheme.primaryColor,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: const Text('ปิด (Close)'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildProgressSection(double displayPct, CourseProgress? progress) {
    final isCompleted = displayPct >= 100;
    return Container(
      margin: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 8.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isCompleted
              ? [const Color(0xFF10B981).withOpacity(0.08), const Color(0xFF059669).withOpacity(0.02)]
              : [AppTheme.primaryColor.withOpacity(0.08), AppTheme.primaryColor.withOpacity(0.02)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isCompleted
              ? const Color(0xFF10B981).withOpacity(0.15)
              : AppTheme.primaryColor.withOpacity(0.15),
          width: 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(6.w),
                decoration: BoxDecoration(
                  color: isCompleted
                      ? const Color(0xFF10B981).withOpacity(0.15)
                      : AppTheme.primaryColor.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isCompleted ? Icons.workspace_premium_rounded : Icons.trending_up_rounded,
                  size: 16.sp,
                  color: isCompleted ? const Color(0xFF10B981) : AppTheme.primaryColor,
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                'ความคืบหน้าการเรียนของคุณ',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.darkGrey,
                ),
              ),
              const Spacer(),
              Text(
                '${displayPct.toStringAsFixed(0)}%',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w800,
                  color: isCompleted ? const Color(0xFF10B981) : AppTheme.primaryColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(6.r),
            child: LinearProgressIndicator(
              value: (displayPct / 100).clamp(0.0, 1.0),
              minHeight: 8.h,
              backgroundColor: AppTheme.lightGrey,
              valueColor: AlwaysStoppedAnimation<Color>(
                displayPct >= 100 ? AppTheme.successColor : AppTheme.primaryColor,
              ),
            ),
          ),
          if (progress != null) ...[
            SizedBox(height: 6.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'เรียนสำเร็จแล้ว ${progress.videosWatched} จาก ${progress.videosTotal} บทเรียน',
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.mediumGrey,
                  ),
                ),
                if (isCompleted)
                  Text(
                    '🎉 ยินดีด้วยคุณเรียนจบแล้ว!',
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.successColor,
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLessonsList(List<VideoLesson> lessons, Set<String> watchedIds) {
    if (lessons.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.video_library_outlined,
                size: 48.sp, color: AppTheme.mediumGrey),
            SizedBox(height: 12.h),
            Text(
              'No lessons available yet.',
              style: TextStyle(fontSize: 14.sp, color: AppTheme.mediumGrey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      itemCount: lessons.length,
      itemBuilder: (context, idx) {
        final lesson = lessons[idx];
        final isWatched = watchedIds.contains(lesson.id);
        final isSelected = _currentLesson?.id == lesson.id;

        return LessonTile(
          lesson: lesson,
          isSelected: isSelected,
          isWatched: isWatched,
          onTap: () => _loadVideo(lesson),
        );
      },
    );
  }

  Widget _buildAboutTab(Course course) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Course Stats
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: AppTheme.surfaceColor,
              borderRadius: BorderRadius.circular(AppTheme.radiusMd),
              boxShadow: AppTheme.softShadow,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _statItem(Icons.schedule, '${course.duration}h', 'Duration'),
                _divider(),
                _statItem(Icons.signal_cellular_alt, course.level, 'Level'),
                _divider(),
                _statItem(Icons.group, '${course.totalStudents}', 'Students'),
              ],
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            'About this Course',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: AppTheme.darkGrey,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            course.description,
            style: TextStyle(
              fontSize: 14.sp,
              color: AppTheme.mediumGrey,
              height: 1.6,
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            'What You\'ll Learn',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: AppTheme.darkGrey,
            ),
          ),
          SizedBox(height: 8.h),
          if (course.whatYouWillLearn != null && course.whatYouWillLearn!.isNotEmpty)
            ...course.whatYouWillLearn!.map((p) => _learnPoint(p))
          else
            ...[
              'Master industry-standard concepts and tools',
              'Build real-world projects from scratch',
              'Get industry-recognized certification',
              'Join our community of learners',
            ].map((p) => _learnPoint(p)),
          SizedBox(height: 20.h),
          Text(
            'Requirements',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: AppTheme.darkGrey,
            ),
          ),
          SizedBox(height: 8.h),
          if (course.requirements != null && course.requirements!.isNotEmpty)
            ...course.requirements!.map((r) => _requirementPoint(r))
          else
            ...[
              'Basic computer knowledge',
              'A passion for learning',
            ].map((r) => _requirementPoint(r)),
        ],
      ),
    );
  }

  Widget _statItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, size: 22.sp, color: AppTheme.primaryColor),
        SizedBox(height: 4.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 13.sp,
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

  Widget _divider() => Container(
        height: 40.h,
        width: 1,
        color: AppTheme.lightGrey,
      );

  Widget _learnPoint(String text) => Padding(
        padding: EdgeInsets.only(bottom: 8.h),
        child: Row(
          children: [
            Icon(Icons.check_circle, size: 16.sp, color: AppTheme.successColor),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                text,
                style:
                    TextStyle(fontSize: 13.sp, color: AppTheme.mediumGrey),
              ),
            ),
          ],
        ),
      );

  Widget _requirementPoint(String text) => Padding(
        padding: EdgeInsets.only(bottom: 8.h),
        child: Row(
          children: [
            Icon(Icons.radio_button_unchecked, size: 14.sp, color: AppTheme.primaryColor),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                text,
                style:
                    TextStyle(fontSize: 13.sp, color: AppTheme.mediumGrey),
              ),
            ),
          ],
        ),
      );

  Widget _buildMarkCompleteButton(
      List<VideoLesson> lessons, Set<String> watchedIds) {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 48.h,
        child: ElevatedButton.icon(
          onPressed: () => _markComplete(lessons, watchedIds),
          icon: Icon(Icons.check_circle_outline, size: 20.sp),
          label: Text(
            'Mark as Complete & Continue',
            style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.successColor,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLessonNavigation(List<VideoLesson> lessons, Set<String> watchedIds) {
    final currentIdx = _currentLesson != null
        ? lessons.indexWhere((l) => l.id == _currentLesson!.id)
        : -1;
    final hasPrevious = currentIdx > 0;
    final hasNext = currentIdx != -1 && currentIdx < lessons.length - 1;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        border: Border(
          bottom: BorderSide(
            color: AppTheme.lightGrey.withOpacity(0.5),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Previous Button
          GestureDetector(
            onTap: hasPrevious ? () => _loadVideo(lessons[currentIdx - 1]) : null,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: hasPrevious
                    ? AppTheme.primaryColor.withOpacity(0.1)
                    : AppTheme.veryLightGrey,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.skip_previous_rounded,
                size: 20.sp,
                color: hasPrevious ? AppTheme.primaryColor : AppTheme.mediumGrey,
              ),
            ),
          ),
          SizedBox(width: 10.w),
          
          // Dropdown/Selector Button
          Expanded(
            child: InkWell(
              onTap: () => _showLessonSelectorBottomSheet(context, lessons, watchedIds),
              borderRadius: BorderRadius.circular(12.r),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: AppTheme.veryLightGrey,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: AppTheme.lightGrey.withOpacity(0.7),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Icon(
                        Icons.menu_book_rounded,
                        color: AppTheme.primaryColor,
                        size: 16.sp,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _currentLesson != null
                                ? 'บทเรียนที่ ${currentIdx + 1} จาก ${lessons.length}'
                                : 'เลือกบทเรียน',
                            style: TextStyle(
                              fontSize: 9.sp,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.mediumGrey,
                            ),
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            _currentLesson?.title ?? 'กรุณาเลือกบทเรียน...',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 11.5.sp,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.darkGrey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.unfold_more_rounded,
                      color: AppTheme.mediumGrey,
                      size: 16.sp,
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(width: 10.w),

          // Next Button
          GestureDetector(
            onTap: hasNext ? () => _loadVideo(lessons[currentIdx + 1]) : null,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: hasNext
                    ? AppTheme.primaryColor.withOpacity(0.1)
                    : AppTheme.veryLightGrey,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.skip_next_rounded,
                size: 20.sp,
                color: hasNext ? AppTheme.primaryColor : AppTheme.mediumGrey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLessonSelectorBottomSheet(
    BuildContext context,
    List<VideoLesson> lessons,
    Set<String> watchedIds,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: AppTheme.backgroundColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(AppTheme.radiusLg),
              topRight: Radius.circular(AppTheme.radiusLg),
            ),
          ),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.7,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Sheet Header
              Center(
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 12.h),
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: AppTheme.lightGrey,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Select Lesson',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.darkGrey,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                      visualDensity: VisualDensity.compact,
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              
              // Lesson List
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  itemCount: lessons.length,
                  itemBuilder: (context, idx) {
                    final lesson = lessons[idx];
                    final isWatched = watchedIds.contains(lesson.id);
                    final isSelected = _currentLesson?.id == lesson.id;

                    return LessonTile(
                      lesson: lesson,
                      isSelected: isSelected,
                      isWatched: isWatched,
                      onTap: () {
                        Navigator.pop(context);
                        _loadVideo(lesson);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showReviewDialog(BuildContext context, String courseName) {
    int selectedRating = 5;
    final textController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusLg),
              ),
              backgroundColor: AppTheme.surfaceColor,
              title: Column(
                children: [
                  Icon(Icons.rate_review_rounded, size: 48.sp, color: AppTheme.primaryColor),
                  SizedBox(height: 12.h),
                  Text(
                    'ให้คะแนนและรีวิวคอร์สเรียน',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.darkGrey,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    courseName,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: AppTheme.mediumGrey,
                    ),
                  ),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Star Rating selector
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        final starValue = index + 1;
                        final isSelected = starValue <= selectedRating;
                        return IconButton(
                          icon: Icon(
                            isSelected ? Icons.star_rounded : Icons.star_outline_rounded,
                            size: 36.sp,
                            color: isSelected ? const Color(0xFFFFC107) : AppTheme.mediumGrey,
                          ),
                          onPressed: () {
                            setDialogState(() {
                              selectedRating = starValue;
                            });
                          },
                        );
                      }),
                    ),
                    SizedBox(height: 16.h),
                    // Review comment text area
                    TextField(
                      controller: textController,
                      maxLines: 4,
                      maxLength: 200,
                      decoration: InputDecoration(
                        hintText: 'เขียนรีวิวเกี่ยวกับบทเรียนนี้...',
                        hintStyle: TextStyle(color: AppTheme.mediumGrey, fontSize: 13.sp),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                          borderSide: BorderSide(color: AppTheme.lightGrey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                          borderSide: BorderSide(color: AppTheme.primaryColor, width: 1.5),
                        ),
                        filled: true,
                        fillColor: AppTheme.veryLightGrey,
                      ),
                      style: TextStyle(color: AppTheme.darkGrey, fontSize: 14.sp),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'ยกเลิก',
                    style: TextStyle(color: AppTheme.mediumGrey),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    final reviewText = textController.text.trim();
                    Navigator.pop(context);
                    _submitReview(courseName, selectedRating, reviewText);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                    ),
                  ),
                  child: const Text('ส่งรีวิว'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _submitReview(String courseName, int rating, String reviewText) async {
    final userId = ref.read(currentUserIdProvider);

    // Save to Supabase ratings table
    await ref.read(courseRepositoryProvider).submitRating(
          userId: userId,
          courseId: widget.courseId,
          rating: rating.toDouble(),
          reviewText: reviewText,
        );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('⭐ ขอบคุณสำหรับรีวิว $rating ดาว และข้อเสนอแนะของคุณ!'),
          backgroundColor: AppTheme.successColor,
        ),
      );
    }

    final reviewMessage = reviewText.isNotEmpty
        ? 'คุณได้รีวิวคอร์ส "$courseName" ให้ $rating ดาว: "$reviewText"'
        : 'คุณได้รีวิวคอร์ส "$courseName" ให้ $rating ดาวเรียบร้อยแล้ว';
        
    ref.read(notificationProvider.notifier).add(
      AppNotification(
        id: 'review_${widget.courseId}_${DateTime.now().millisecondsSinceEpoch}',
        title: '⭐ รีวิวคอร์สสำเร็จ',
        message: reviewMessage,
        type: NotificationType.system,
        createdAt: DateTime.now(),
      ),
    );
    
    if (mounted) {
      context.pop();
    }
  }
}
