/// VideoLesson entity — represents a single lesson/video within a course.
class VideoLesson {
  final String id;
  final String courseId;
  final String title;
  final String? description;
  final String videoUrl;
  final String? thumbnailUrl;
  final int durationSeconds; // raw seconds
  final int orderIndex;
  final bool isWatched;
  final String contentType; // 'video' | 'text' | 'quiz' | 'assignment'
  final String? content;

  const VideoLesson({
    required this.id,
    required this.courseId,
    required this.title,
    this.description,
    required this.videoUrl,
    this.thumbnailUrl,
    required this.durationSeconds,
    required this.orderIndex,
    this.isWatched = false,
    this.contentType = 'video',
    this.content,
  });

  factory VideoLesson.fromJson(Map<String, dynamic> json) {
    return VideoLesson(
      id: json['id']?.toString() ?? '',
      courseId: json['course_id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString(),
      videoUrl: json['video_url']?.toString() ?? '',
      thumbnailUrl: json['thumbnail_url']?.toString(),
      durationSeconds: json['video_duration'] != null
          ? int.parse(json['video_duration'].toString())
          : (json['duration'] != null
              ? int.parse(json['duration'].toString())
              : 0),
      orderIndex: json['sort_order'] != null
          ? int.parse(json['sort_order'].toString())
          : (json['order_index'] != null
              ? int.parse(json['order_index'].toString())
              : 0),
      isWatched: json['is_watched'] == true,
      contentType: json['content_type']?.toString() ?? 'video',
      content: json['content']?.toString(),
    );
  }

  /// Human-readable duration, e.g. "10:50"
  String get formattedDuration {
    final minutes = durationSeconds ~/ 60;
    final seconds = durationSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }

  VideoLesson copyWith({
    bool? isWatched,
    String? contentType,
    String? content,
  }) {
    return VideoLesson(
      id: id,
      courseId: courseId,
      title: title,
      description: description,
      videoUrl: videoUrl,
      thumbnailUrl: thumbnailUrl,
      durationSeconds: durationSeconds,
      orderIndex: orderIndex,
      isWatched: isWatched ?? this.isWatched,
      contentType: contentType ?? this.contentType,
      content: content ?? this.content,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is VideoLesson && other.id == id);

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'VideoLesson(id: $id, title: $title)';
}
