import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase_core;
import '../../../../core/constants/app_constants.dart';
import '../entities/video_lesson.dart';
import '../../../courses/data/mock_course_data.dart';

// ─────────────────────────────────────────────
// Video Lessons Provider (per course)
// ─────────────────────────────────────────────

bool get _isSupabaseActive {
  try {
    supabase_core.Supabase.instance.client;
    return AppConstants.supabaseUrl != 'https://your-project.supabase.co' &&
        AppConstants.supabaseUrl.isNotEmpty &&
        !AppConstants.supabaseUrl.contains('your-project');
  } catch (_) {
    return false;
  }
}

/// Fetches all video lessons for a given [courseId].
final videoLessonsProvider =
    FutureProvider.family<List<VideoLesson>, String>((ref, courseId) async {
  if (_isSupabaseActive) {
    try {
      final resp = await supabase_core.Supabase.instance.client
          .from('lessons')
          .select()
          .eq('course_id', courseId)
          .order('sort_order', ascending: true);
      return (resp as List)
          .map((v) => VideoLesson.fromJson(v as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Supabase video lessons load error: $e');
    }
  }

  // Mock fallback — filter mock videos for this course
  final mockVideos = MockCourseData.mockVideos
      .where((v) => v['course_id'] == courseId)
      .map((v) => VideoLesson.fromJson(v))
      .toList();

  mockVideos.sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
  return mockVideos;
});

// ─────────────────────────────────────────────
// Currently Selected Video
// ─────────────────────────────────────────────

final selectedVideoProvider = StateProvider<VideoLesson?>((ref) => null);

// ─────────────────────────────────────────────
// Watched Lesson IDs (per course session)
// ─────────────────────────────────────────────

/// Tracks which lesson IDs have been marked complete in the current session.
final watchedLessonIdsProvider =
    StateNotifierProvider.family<WatchedLessonsNotifier, Set<String>, String>(
        (ref, courseId) {
  return WatchedLessonsNotifier(courseId);
});

class WatchedLessonsNotifier extends StateNotifier<Set<String>> {
  final String courseId;

  WatchedLessonsNotifier(this.courseId) : super({});

  void markWatched(String lessonId) {
    if (!state.contains(lessonId)) {
      state = {...state, lessonId};
    }
  }

  void reset() => state = {};
}
