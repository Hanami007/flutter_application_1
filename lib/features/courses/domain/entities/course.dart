import 'package:freezed_annotation/freezed_annotation.dart';

part 'course.freezed.dart';
part 'course.g.dart';

@freezed
class Course with _$Course {
  const factory Course({
    required String id,
    required String name,
    required String description,
    required String categoryId,
    required String instructorId,
    String? thumbnailUrl,
    required double price,
    required int duration,
    required String level,
    @Default(0.0) double rating,
    @Default(0) int totalStudents,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Course;

  factory Course.fromJson(Map<String, dynamic> json) => _$CourseFromJson(json);
}

@freezed
class Category with _$Category {
  const factory Category({
    required String id,
    required String name,
    String? description,
    String? iconUrl,
  }) = _Category;

  factory Category.fromJson(Map<String, dynamic> json) => _$CategoryFromJson(json);
}

@freezed
class CourseProgress with _$CourseProgress {
  const factory CourseProgress({
    required String id,
    required String userId,
    required String courseId,
    @Default(0) int videosWatched,
    @Default(0) int videosTotal,
    @Default(0.0) double progressPercentage,
    DateTime? completedAt,
  }) = _CourseProgress;

  factory CourseProgress.fromJson(Map<String, dynamic> json) => 
      _$CourseProgressFromJson(json);
}
