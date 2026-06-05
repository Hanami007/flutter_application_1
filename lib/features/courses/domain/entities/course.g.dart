// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CourseImpl _$$CourseImplFromJson(Map<String, dynamic> json) => _$CourseImpl(
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
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$$CourseImplToJson(_$CourseImpl instance) =>
    <String, dynamic>{
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
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

_$CategoryImpl _$$CategoryImplFromJson(Map<String, dynamic> json) =>
    _$CategoryImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      iconUrl: json['iconUrl'] as String?,
    );

Map<String, dynamic> _$$CategoryImplToJson(_$CategoryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'iconUrl': instance.iconUrl,
    };

_$CourseProgressImpl _$$CourseProgressImplFromJson(Map<String, dynamic> json) =>
    _$CourseProgressImpl(
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

Map<String, dynamic> _$$CourseProgressImplToJson(
  _$CourseProgressImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'courseId': instance.courseId,
  'videosWatched': instance.videosWatched,
  'videosTotal': instance.videosTotal,
  'progressPercentage': instance.progressPercentage,
  'completedAt': instance.completedAt?.toIso8601String(),
};
