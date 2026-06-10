// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Course _$CourseFromJson(Map<String, dynamic> json) => _Course(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String,
  categoryId: json['categoryId'] as String,
  instructorId: json['instructorId'] as String,
  thumbnailUrl: json['thumbnailUrl'] as String?,
  price: (json['price'] as num).toDouble(),
  duration: (json['duration'] as num).toInt(),
  level: json['level'] as String,
  rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
  totalStudents: (json['totalStudents'] as num?)?.toInt() ?? 0,
  whatYouWillLearn: (json['whatYouWillLearn'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  requirements: (json['requirements'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$CourseToJson(_Course instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'categoryId': instance.categoryId,
  'instructorId': instance.instructorId,
  'thumbnailUrl': instance.thumbnailUrl,
  'price': instance.price,
  'duration': instance.duration,
  'level': instance.level,
  'rating': instance.rating,
  'totalStudents': instance.totalStudents,
  'whatYouWillLearn': instance.whatYouWillLearn,
  'requirements': instance.requirements,
  'createdAt': instance.createdAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
};

_Category _$CategoryFromJson(Map<String, dynamic> json) => _Category(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String?,
  iconUrl: json['iconUrl'] as String?,
);

Map<String, dynamic> _$CategoryToJson(_Category instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'iconUrl': instance.iconUrl,
};

_CourseProgress _$CourseProgressFromJson(Map<String, dynamic> json) =>
    _CourseProgress(
      id: json['id'] as String,
      userId: json['userId'] as String,
      courseId: json['courseId'] as String,
      videosWatched: (json['videosWatched'] as num?)?.toInt() ?? 0,
      videosTotal: (json['videosTotal'] as num?)?.toInt() ?? 0,
      progressPercentage:
          (json['progressPercentage'] as num?)?.toDouble() ?? 0.0,
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
    );

Map<String, dynamic> _$CourseProgressToJson(_CourseProgress instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'courseId': instance.courseId,
      'videosWatched': instance.videosWatched,
      'videosTotal': instance.videosTotal,
      'progressPercentage': instance.progressPercentage,
      'completedAt': instance.completedAt?.toIso8601String(),
    };
