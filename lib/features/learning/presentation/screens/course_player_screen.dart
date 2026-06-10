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
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text(e.toString())),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
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

    return NestedScrollView(
      headerSliverBuilder: (context, _) => [
        SliverAppBar(
          pinned: true,
          backgroundColor: AppTheme.darkGrey,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => context.pop(),
          ),
          title: Text(
            course.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.red : Colors.white,
              ),
              onPressed: () =>
                  ref.read(favoriteCourseIdsProvider.notifier).toggle(widget.courseId),
            ),
          ],
          // Video Player in the flexible space
          flexibleSpace: FlexibleSpaceBar(
            background: _buildVideoPlayer(),
          ),
          expandedHeight: 220.h,
        ),
      ],
      body: Column(
        children: [
          // Progress Bar
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
                        Text('Certificate generated! Download feature coming soon.'),
                  ),
                );
              },
              onReviewCourse: () => _showReviewDialog(context, course.name),
            ),

          // Tabs
          Container(
            color: AppTheme.surfaceColor,
            child: TabBar(
              controller: _tabController,
              labelColor: AppTheme.primaryColor,
              unselectedLabelColor: AppTheme.mediumGrey,
              indicatorColor: AppTheme.primaryColor,
              tabs: [
                Tab(
                  child: Text(
                    'Lessons (${lessons.length})',
                    style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600),
                  ),
                ),
                Tab(
                  child: Text(
                    'About',
                    style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Lessons Tab
                _buildLessonsList(lessons, watchedIds),
                // About Tab
                _buildAboutTab(course),
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

  Widget _buildVideoPlayer() {
    if (_isLoadingVideo) {
      return Container(
        color: Colors.black,
        child: Center(
          child: CircularProgressIndicator(
            valueColor:
                AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
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
              Icon(Icons.play_circle_outline,
                  size: 60.sp, color: Colors.white54),
              SizedBox(height: 8.h),
              Text(
                'Select a lesson to start',
                style: TextStyle(color: Colors.white54, fontSize: 14.sp),
              ),
            ],
          ),
        ),
      );
    }

    final type = _currentLesson!.contentType;

    if (type == 'text') {
      return Container(
        color: AppTheme.darkGrey,
        padding: EdgeInsets.all(16.w),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.description_rounded, size: 40.sp, color: Colors.white),
              SizedBox(height: 8.h),
              Text(
                _currentLesson!.title,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 12.h),
              ElevatedButton.icon(
                onPressed: () => _showTextContentDialog(context, _currentLesson!),
                icon: Icon(Icons.chrome_reader_mode_rounded, size: 18.sp),
                label: const Text('อ่านเนื้อหาเรียน (Read Lesson)'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radiusMd),
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
        color: AppTheme.darkGrey,
        padding: EdgeInsets.all(16.w),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.assignment_turned_in_rounded, size: 40.sp, color: Colors.amber),
              SizedBox(height: 8.h),
              Text(
                _currentLesson!.title,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                'Assignment Task',
                style: TextStyle(color: Colors.white70, fontSize: 11.sp),
              ),
              SizedBox(height: 12.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _showTextContentDialog(context, _currentLesson!),
                    icon: Icon(Icons.info_outline, size: 16.sp),
                    label: const Text('คำอธิบาย (Details)'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white24,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                      ),
                    ),
                  ),
                  if (_currentLesson!.videoUrl.isNotEmpty) ...[
                    SizedBox(width: 8.w),
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
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
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
        color: AppTheme.darkGrey,
        padding: EdgeInsets.all(16.w),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.quiz_rounded, size: 40.sp, color: AppTheme.secondaryColor),
              SizedBox(height: 8.h),
              Text(
                _currentLesson!.title,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 12.h),
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
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radiusMd),
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
        color: AppTheme.darkGrey,
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(24.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.open_in_new_rounded,
                  size: 40.sp,
                  color: Colors.white,
                ),
                SizedBox(height: 8.h),
                Text(
                  _currentLesson!.title,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'This lesson contains an external link/resource.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 11.sp,
                  ),
                ),
                SizedBox(height: 12.h),
                ElevatedButton.icon(
                  onPressed: () async {
                    final uri = Uri.parse(_currentLesson!.videoUrl);
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri, mode: LaunchMode.externalApplication);
                    }
                  },
                  icon: Icon(Icons.school, size: 16.sp),
                  label: Text(
                    'ไปที่บทเรียน (Open Link)',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.successColor,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppTheme.radiusMd),
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
            Icon(Icons.play_circle_outline,
                size: 60.sp, color: Colors.white54),
            SizedBox(height: 8.h),
            Text(
              'Select a lesson to start',
              style: TextStyle(color: Colors.white54, fontSize: 14.sp),
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
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusLg),
          ),
          backgroundColor: AppTheme.surfaceColor,
          title: Row(
            children: [
              Icon(
                lesson.contentType == 'assignment'
                    ? Icons.assignment_rounded
                    : Icons.description_rounded,
                color: AppTheme.primaryColor,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  lesson.title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.darkGrey,
                  ),
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (lesson.description != null && lesson.description!.isNotEmpty) ...[
                  Text(
                    'Description:',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.mediumGrey,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    lesson.description!,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppTheme.darkGrey,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 16.h),
                ],
                if (lesson.content != null && lesson.content!.isNotEmpty) ...[
                  Text(
                    'Content:',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.mediumGrey,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    lesson.content!,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppTheme.darkGrey,
                      height: 1.5,
                    ),
                  ),
                ] else if (lesson.contentType == 'text') ...[
                  Text(
                    'No content description provided.',
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontStyle: FontStyle.italic,
                      color: AppTheme.mediumGrey,
                    ),
                  ),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildProgressSection(double displayPct, CourseProgress? progress) {
    return Container(
      color: AppTheme.surfaceColor,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Your Progress',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.darkGrey,
                ),
              ),
              Text(
                '${displayPct.toStringAsFixed(0)}%',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: displayPct >= 100
                      ? AppTheme.successColor
                      : AppTheme.primaryColor,
                ),
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
              valueColor: AlwaysStoppedAnimation<Color>(
                displayPct >= 100
                    ? AppTheme.successColor
                    : AppTheme.primaryColor,
              ),
            ),
          ),
          if (progress != null)
            Padding(
              padding: EdgeInsets.only(top: 4.h),
              child: Text(
                '${progress.videosWatched} / ${progress.videosTotal} lessons completed',
                style:
                    TextStyle(fontSize: 11.sp, color: AppTheme.mediumGrey),
              ),
            ),
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
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
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
          Container(
            decoration: BoxDecoration(
              color: hasPrevious
                  ? AppTheme.primaryColor.withOpacity(0.1)
                  : AppTheme.veryLightGrey,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(
                Icons.skip_previous_rounded,
                color: hasPrevious ? AppTheme.primaryColor : AppTheme.mediumGrey,
              ),
              onPressed: hasPrevious
                  ? () => _loadVideo(lessons[currentIdx - 1])
                  : null,
              tooltip: 'Previous Lesson',
            ),
          ),
          SizedBox(width: 12.w),
          
          // Dropdown/Selector Button
          Expanded(
            child: InkWell(
              onTap: () => _showLessonSelectorBottomSheet(context, lessons, watchedIds),
              borderRadius: BorderRadius.circular(AppTheme.radiusMd),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: AppTheme.veryLightGrey,
                  borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                  border: Border.all(
                    color: AppTheme.lightGrey,
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.list_alt_rounded,
                      color: AppTheme.primaryColor,
                      size: 18.sp,
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _currentLesson != null
                                ? 'Lesson ${currentIdx + 1} of ${lessons.length}'
                                : 'Select Lesson',
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.mediumGrey,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            _currentLesson?.title ?? 'Choose a lesson...',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.darkGrey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: AppTheme.mediumGrey,
                      size: 18.sp,
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),

          // Next Button
          Container(
            decoration: BoxDecoration(
              color: hasNext
                  ? AppTheme.primaryColor.withOpacity(0.1)
                  : AppTheme.veryLightGrey,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(
                Icons.skip_next_rounded,
                color: hasNext ? AppTheme.primaryColor : AppTheme.mediumGrey,
              ),
              onPressed: hasNext
                  ? () => _loadVideo(lessons[currentIdx + 1])
                  : null,
              tooltip: 'Next Lesson',
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
