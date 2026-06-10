import 'package:freezed_annotation/freezed_annotation.dart';

part 'course.freezed.dart';
part 'course.g.dart';

@freezed
abstract class Course with _$Course {
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

  factory Course.fromDbJson(Map<String, dynamic> dbJson) {
    return Course(
      id: dbJson['id']?.toString() ?? '',
      name: dbJson['name']?.toString() ?? '',
      description: dbJson['description']?.toString() ?? '',
      categoryId: dbJson['category_id']?.toString() ?? dbJson['categoryId']?.toString() ?? '',
      instructorId: dbJson['instructor_id']?.toString() ?? dbJson['instructorId']?.toString() ?? '',
      thumbnailUrl: dbJson['thumbnail_url']?.toString() ?? dbJson['thumbnailUrl']?.toString(),
      price: dbJson['price'] != null ? double.parse(dbJson['price'].toString()) : 0.0,
      duration: dbJson['duration'] != null ? int.parse(dbJson['duration'].toString()) : 0,
      level: dbJson['level']?.toString() ?? 'Beginner',
      rating: dbJson['rating'] != null ? double.parse(dbJson['rating'].toString()) : 0.0,
      totalStudents: dbJson['total_students'] != null
          ? int.parse(dbJson['total_students'].toString())
          : (dbJson['totalStudents'] != null ? int.parse(dbJson['totalStudents'].toString()) : 0),
      whatYouWillLearn: dbJson['what_you_will_learn'] != null
          ? List<String>.from(dbJson['what_you_will_learn'] as List)
          : (dbJson['whatYouWillLearn'] != null ? List<String>.from(dbJson['whatYouWillLearn'] as List) : null),
      requirements: dbJson['requirements'] != null
          ? List<String>.from(dbJson['requirements'] as List)
          : (dbJson['requirements'] != null ? List<String>.from(dbJson['requirements'] as List) : null),
      createdAt: dbJson['created_at'] != null ? DateTime.tryParse(dbJson['created_at'].toString()) : null,
      updatedAt: dbJson['updated_at'] != null ? DateTime.tryParse(dbJson['updated_at'].toString()) : null,
    );
  }
}

@freezed
abstract class Category with _$Category {
  const factory Category({
    required String id,
    required String name,
    String? description,
    String? iconUrl,
  }) = _Category;

  factory Category.fromJson(Map<String, dynamic> json) => _$CategoryFromJson(json);
}

@freezed
abstract class CourseProgress with _$CourseProgress {
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
