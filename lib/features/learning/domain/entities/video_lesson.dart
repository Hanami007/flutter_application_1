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
  });

  factory VideoLesson.fromJson(Map<String, dynamic> json) {
    return VideoLesson(
      id: json['id']?.toString() ?? '',
      courseId: json['course_id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString(),
      videoUrl: json['video_url']?.toString() ?? '',
      thumbnailUrl: json['thumbnail_url']?.toString(),
      durationSeconds: json['duration'] != null
          ? int.parse(json['duration'].toString())
          : 0,
      orderIndex: json['order_index'] != null
          ? int.parse(json['order_index'].toString())
          : 0,
      isWatched: json['is_watched'] == true,
    );
  }

  /// Human-readable duration, e.g. "10:50"
  String get formattedDuration {
    final minutes = durationSeconds ~/ 60;
    final seconds = durationSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }

  VideoLesson copyWith({bool? isWatched}) {
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
