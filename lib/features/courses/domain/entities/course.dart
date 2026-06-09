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
    List<String>? whatYouWillLearn,
    List<String>? requirements,
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

class ReviewModel {
  final String id;
  final String userName;
  final String courseName;
  final double rating;
  final String review;
  final DateTime createdAt;

  ReviewModel({
    required this.id,
    required this.userName,
    required this.courseName,
    required this.rating,
    required this.review,
    required this.createdAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id']?.toString() ?? '',
      userName: json['userName']?.toString() ?? json['user_name']?.toString() ?? '',
      courseName: json['courseName']?.toString() ?? json['course_name']?.toString() ?? '',
      rating: json['rating'] != null ? double.parse(json['rating'].toString()) : 5.0,
      review: json['review']?.toString() ?? '',
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at'].toString()) 
          : DateTime.now(),
    );
  }
}
