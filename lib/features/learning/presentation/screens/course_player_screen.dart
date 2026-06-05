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
    _chewieController?.dispose();
    _videoController?.dispose();
    _chewieController = null;
    _videoController = null;
  }

  Future<void> _loadVideo(VideoLesson lesson) async {
    if (_currentLesson?.id == lesson.id) return;

    setState(() => _isLoadingVideo = true);
    _disposeVideo();

    try {
      _videoController = VideoPlayerController.networkUrl(
        Uri.parse(lesson.videoUrl),
      );
      await _videoController!.initialize();
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
              onReviewCourse: () => context.pop(),
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

    if (_chewieController != null) {
      return Container(
        color: Colors.black,
        child: Chewie(controller: _chewieController!),
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
          ...[
            'Master industry-standard concepts and tools',
            'Build real-world projects from scratch',
            'Get industry-recognized certification',
            'Join our community of learners',
          ].map((p) => _learnPoint(p)),
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
}
