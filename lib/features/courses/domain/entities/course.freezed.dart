// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'course.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Course _$CourseFromJson(Map<String, dynamic> json) {
  return _Course.fromJson(json);
}

/// @nodoc
mixin _$Course {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get categoryId => throw _privateConstructorUsedError;
  String get instructorId => throw _privateConstructorUsedError;
  String? get thumbnailUrl => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  int get duration => throw _privateConstructorUsedError;
  String get level => throw _privateConstructorUsedError;
  double get rating => throw _privateConstructorUsedError;
  int get totalStudents => throw _privateConstructorUsedError;
  List<String>? get whatYouWillLearn => throw _privateConstructorUsedError;
  List<String>? get requirements => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Course to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Course
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CourseCopyWith<Course> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CourseCopyWith<$Res> {
  factory $CourseCopyWith(Course value, $Res Function(Course) then) =
      _$CourseCopyWithImpl<$Res, Course>;
  @useResult
  $Res call({
    String id,
    String name,
    String description,
    String categoryId,
    String instructorId,
    String? thumbnailUrl,
    double price,
    int duration,
    String level,
    double rating,
    int totalStudents,
    List<String>? whatYouWillLearn,
    List<String>? requirements,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class _$CourseCopyWithImpl<$Res, $Val extends Course>
    implements $CourseCopyWith<$Res> {
  _$CourseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Course
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? categoryId = null,
    Object? instructorId = null,
    Object? thumbnailUrl = freezed,
    Object? price = null,
    Object? duration = null,
    Object? level = null,
    Object? rating = null,
    Object? totalStudents = null,
    Object? whatYouWillLearn = freezed,
    Object? requirements = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            categoryId: null == categoryId
                ? _value.categoryId
                : categoryId // ignore: cast_nullable_to_non_nullable
                      as String,
            instructorId: null == instructorId
                ? _value.instructorId
                : instructorId // ignore: cast_nullable_to_non_nullable
                      as String,
            thumbnailUrl: freezed == thumbnailUrl
                ? _value.thumbnailUrl
                : thumbnailUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            price: null == price
                ? _value.price
                : price // ignore: cast_nullable_to_non_nullable
                      as double,
            duration: null == duration
                ? _value.duration
                : duration // ignore: cast_nullable_to_non_nullable
                      as int,
            level: null == level
                ? _value.level
                : level // ignore: cast_nullable_to_non_nullable
                      as String,
            rating: null == rating
                ? _value.rating
                : rating // ignore: cast_nullable_to_non_nullable
                      as double,
            totalStudents: null == totalStudents
                ? _value.totalStudents
                : totalStudents // ignore: cast_nullable_to_non_nullable
                      as int,
            whatYouWillLearn: freezed == whatYouWillLearn
                ? _value.whatYouWillLearn
                : whatYouWillLearn // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
            requirements: freezed == requirements
                ? _value.requirements
                : requirements // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CourseImplCopyWith<$Res> implements $CourseCopyWith<$Res> {
  factory _$$CourseImplCopyWith(
    _$CourseImpl value,
    $Res Function(_$CourseImpl) then,
  ) = __$$CourseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String description,
    String categoryId,
    String instructorId,
    String? thumbnailUrl,
    double price,
    int duration,
    String level,
    double rating,
    int totalStudents,
    List<String>? whatYouWillLearn,
    List<String>? requirements,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class __$$CourseImplCopyWithImpl<$Res>
    extends _$CourseCopyWithImpl<$Res, _$CourseImpl>
    implements _$$CourseImplCopyWith<$Res> {
  __$$CourseImplCopyWithImpl(
    _$CourseImpl _value,
    $Res Function(_$CourseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Course
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? categoryId = null,
    Object? instructorId = null,
    Object? thumbnailUrl = freezed,
    Object? price = null,
    Object? duration = null,
    Object? level = null,
    Object? rating = null,
    Object? totalStudents = null,
    Object? whatYouWillLearn = freezed,
    Object? requirements = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$CourseImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        categoryId: null == categoryId
            ? _value.categoryId
            : categoryId // ignore: cast_nullable_to_non_nullable
                  as String,
        instructorId: null == instructorId
            ? _value.instructorId
            : instructorId // ignore: cast_nullable_to_non_nullable
                  as String,
        thumbnailUrl: freezed == thumbnailUrl
            ? _value.thumbnailUrl
            : thumbnailUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        price: null == price
            ? _value.price
            : price // ignore: cast_nullable_to_non_nullable
                  as double,
        duration: null == duration
            ? _value.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as int,
        level: null == level
            ? _value.level
            : level // ignore: cast_nullable_to_non_nullable
                  as String,
        rating: null == rating
            ? _value.rating
            : rating // ignore: cast_nullable_to_non_nullable
                  as double,
        totalStudents: null == totalStudents
            ? _value.totalStudents
            : totalStudents // ignore: cast_nullable_to_non_nullable
                  as int,
        whatYouWillLearn: freezed == whatYouWillLearn
            ? _value._whatYouWillLearn
            : whatYouWillLearn // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        requirements: freezed == requirements
            ? _value._requirements
            : requirements // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CourseImpl implements _Course {
  const _$CourseImpl({
    required this.id,
    required this.name,
    required this.description,
    required this.categoryId,
    required this.instructorId,
    this.thumbnailUrl,
    required this.price,
    required this.duration,
    required this.level,
    this.rating = 0.0,
    this.totalStudents = 0,
    final List<String>? whatYouWillLearn,
    final List<String>? requirements,
    this.createdAt,
    this.updatedAt,
  }) : _whatYouWillLearn = whatYouWillLearn,
       _requirements = requirements;

  factory _$CourseImpl.fromJson(Map<String, dynamic> json) =>
      _$$CourseImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String description;
  @override
  final String categoryId;
  @override
  final String instructorId;
  @override
  final String? thumbnailUrl;
  @override
  final double price;
  @override
  final int duration;
  @override
  final String level;
  @override
  @JsonKey()
  final double rating;
  @override
  @JsonKey()
  final int totalStudents;
  final List<String>? _whatYouWillLearn;
  @override
  List<String>? get whatYouWillLearn {
    final value = _whatYouWillLearn;
    if (value == null) return null;
    if (_whatYouWillLearn is EqualUnmodifiableListView) return _whatYouWillLearn;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _requirements;
  @override
  List<String>? get requirements {
    final value = _requirements;
    if (value == null) return null;
    if (_requirements is EqualUnmodifiableListView) return _requirements;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'Course(id: $id, name: $name, description: $description, categoryId: $categoryId, instructorId: $instructorId, thumbnailUrl: $thumbnailUrl, price: $price, duration: $duration, level: $level, rating: $rating, totalStudents: $totalStudents, whatYouWillLearn: $whatYouWillLearn, requirements: $requirements, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CourseImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.instructorId, instructorId) ||
                other.instructorId == instructorId) &&
            (identical(other.thumbnailUrl, thumbnailUrl) ||
                other.thumbnailUrl == thumbnailUrl) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.level, level) || other.level == level) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.totalStudents, totalStudents) ||
                other.totalStudents == totalStudents) &&
            const DeepCollectionEquality().equals(other._whatYouWillLearn, _whatYouWillLearn) &&
            const DeepCollectionEquality().equals(other._requirements, _requirements) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    description,
    categoryId,
    instructorId,
    thumbnailUrl,
    price,
    duration,
    level,
    rating,
    totalStudents,
    const DeepCollectionEquality().hash(_whatYouWillLearn),
    const DeepCollectionEquality().hash(_requirements),
    createdAt,
    updatedAt,
  );

  /// Create a copy of Course
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CourseImplCopyWith<_$CourseImpl> get copyWith =>
      __$$CourseImplCopyWithImpl<_$CourseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CourseImplToJson(this);
  }
}

abstract class _Course implements Course {
  const factory _Course({
    required final String id,
    required final String name,
    required final String description,
    required final String categoryId,
    required final String instructorId,
    final String? thumbnailUrl,
    required final double price,
    required final int duration,
    required final String level,
    final double rating,
    final int totalStudents,
    final List<String>? whatYouWillLearn,
    final List<String>? requirements,
    final DateTime? createdAt,
    final DateTime? updatedAt,
  }) = _$CourseImpl;

  factory _Course.fromJson(Map<String, dynamic> json) = _$CourseImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get description;
  @override
  String get categoryId;
  @override
  String get instructorId;
  @override
  String? get thumbnailUrl;
  @override
  double get price;
  @override
  int get duration;
  @override
  String get level;
  @override
  double get rating;
  @override
  int get totalStudents;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of Course
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CourseImplCopyWith<_$CourseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Category _$CategoryFromJson(Map<String, dynamic> json) {
  return _Category.fromJson(json);
}

/// @nodoc
mixin _$Category {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get iconUrl => throw _privateConstructorUsedError;

  /// Serializes this Category to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Category
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CategoryCopyWith<Category> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CategoryCopyWith<$Res> {
  factory $CategoryCopyWith(Category value, $Res Function(Category) then) =
      _$CategoryCopyWithImpl<$Res, Category>;
  @useResult
  $Res call({String id, String name, String? description, String? iconUrl});
}

/// @nodoc
class _$CategoryCopyWithImpl<$Res, $Val extends Category>
    implements $CategoryCopyWith<$Res> {
  _$CategoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Category
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? iconUrl = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            iconUrl: freezed == iconUrl
                ? _value.iconUrl
                : iconUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CategoryImplCopyWith<$Res>
    implements $CategoryCopyWith<$Res> {
  factory _$$CategoryImplCopyWith(
    _$CategoryImpl value,
    $Res Function(_$CategoryImpl) then,
  ) = __$$CategoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String name, String? description, String? iconUrl});
}

/// @nodoc
class __$$CategoryImplCopyWithImpl<$Res>
    extends _$CategoryCopyWithImpl<$Res, _$CategoryImpl>
    implements _$$CategoryImplCopyWith<$Res> {
  __$$CategoryImplCopyWithImpl(
    _$CategoryImpl _value,
    $Res Function(_$CategoryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Category
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? iconUrl = freezed,
  }) {
    return _then(
      _$CategoryImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        iconUrl: freezed == iconUrl
            ? _value.iconUrl
            : iconUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CategoryImpl implements _Category {
  const _$CategoryImpl({
    required this.id,
    required this.name,
    this.description,
    this.iconUrl,
  });

  factory _$CategoryImpl.fromJson(Map<String, dynamic> json) =>
      _$$CategoryImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String? description;
  @override
  final String? iconUrl;

  @override
  String toString() {
    return 'Category(id: $id, name: $name, description: $description, iconUrl: $iconUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CategoryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.iconUrl, iconUrl) || other.iconUrl == iconUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, description, iconUrl);

  /// Create a copy of Category
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CategoryImplCopyWith<_$CategoryImpl> get copyWith =>
      __$$CategoryImplCopyWithImpl<_$CategoryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CategoryImplToJson(this);
  }
}

abstract class _Category implements Category {
  const factory _Category({
    required final String id,
    required final String name,
    final String? description,
    final String? iconUrl,
  }) = _$CategoryImpl;

  factory _Category.fromJson(Map<String, dynamic> json) =
      _$CategoryImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String? get description;
  @override
  String? get iconUrl;

  /// Create a copy of Category
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CategoryImplCopyWith<_$CategoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CourseProgress _$CourseProgressFromJson(Map<String, dynamic> json) {
  return _CourseProgress.fromJson(json);
}

/// @nodoc
mixin _$CourseProgress {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get courseId => throw _privateConstructorUsedError;
  int get videosWatched => throw _privateConstructorUsedError;
  int get videosTotal => throw _privateConstructorUsedError;
  double get progressPercentage => throw _privateConstructorUsedError;
  DateTime? get completedAt => throw _privateConstructorUsedError;

  /// Serializes this CourseProgress to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CourseProgress
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CourseProgressCopyWith<CourseProgress> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CourseProgressCopyWith<$Res> {
  factory $CourseProgressCopyWith(
    CourseProgress value,
    $Res Function(CourseProgress) then,
  ) = _$CourseProgressCopyWithImpl<$Res, CourseProgress>;
  @useResult
  $Res call({
    String id,
    String userId,
    String courseId,
    int videosWatched,
    int videosTotal,
    double progressPercentage,
    DateTime? completedAt,
  });
}

/// @nodoc
class _$CourseProgressCopyWithImpl<$Res, $Val extends CourseProgress>
    implements $CourseProgressCopyWith<$Res> {
  _$CourseProgressCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CourseProgress
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? courseId = null,
    Object? videosWatched = null,
    Object? videosTotal = null,
    Object? progressPercentage = null,
    Object? completedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            courseId: null == courseId
                ? _value.courseId
                : courseId // ignore: cast_nullable_to_non_nullable
                      as String,
            videosWatched: null == videosWatched
                ? _value.videosWatched
                : videosWatched // ignore: cast_nullable_to_non_nullable
                      as int,
            videosTotal: null == videosTotal
                ? _value.videosTotal
                : videosTotal // ignore: cast_nullable_to_non_nullable
                      as int,
            progressPercentage: null == progressPercentage
                ? _value.progressPercentage
                : progressPercentage // ignore: cast_nullable_to_non_nullable
                      as double,
            completedAt: freezed == completedAt
                ? _value.completedAt
                : completedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CourseProgressImplCopyWith<$Res>
    implements $CourseProgressCopyWith<$Res> {
  factory _$$CourseProgressImplCopyWith(
    _$CourseProgressImpl value,
    $Res Function(_$CourseProgressImpl) then,
  ) = __$$CourseProgressImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String userId,
    String courseId,
    int videosWatched,
    int videosTotal,
    double progressPercentage,
    DateTime? completedAt,
  });
}

/// @nodoc
class __$$CourseProgressImplCopyWithImpl<$Res>
    extends _$CourseProgressCopyWithImpl<$Res, _$CourseProgressImpl>
    implements _$$CourseProgressImplCopyWith<$Res> {
  __$$CourseProgressImplCopyWithImpl(
    _$CourseProgressImpl _value,
    $Res Function(_$CourseProgressImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CourseProgress
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? courseId = null,
    Object? videosWatched = null,
    Object? videosTotal = null,
    Object? progressPercentage = null,
    Object? completedAt = freezed,
  }) {
    return _then(
      _$CourseProgressImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        courseId: null == courseId
            ? _value.courseId
            : courseId // ignore: cast_nullable_to_non_nullable
                  as String,
        videosWatched: null == videosWatched
            ? _value.videosWatched
            : videosWatched // ignore: cast_nullable_to_non_nullable
                  as int,
        videosTotal: null == videosTotal
            ? _value.videosTotal
            : videosTotal // ignore: cast_nullable_to_non_nullable
                  as int,
        progressPercentage: null == progressPercentage
            ? _value.progressPercentage
            : progressPercentage // ignore: cast_nullable_to_non_nullable
                  as double,
        completedAt: freezed == completedAt
            ? _value.completedAt
            : completedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CourseProgressImpl implements _CourseProgress {
  const _$CourseProgressImpl({
    required this.id,
    required this.userId,
    required this.courseId,
    this.videosWatched = 0,
    this.videosTotal = 0,
    this.progressPercentage = 0.0,
    this.completedAt,
  });

  factory _$CourseProgressImpl.fromJson(Map<String, dynamic> json) =>
      _$$CourseProgressImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String courseId;
  @override
  @JsonKey()
  final int videosWatched;
  @override
  @JsonKey()
  final int videosTotal;
  @override
  @JsonKey()
  final double progressPercentage;
  @override
  final DateTime? completedAt;

  @override
  String toString() {
    return 'CourseProgress(id: $id, userId: $userId, courseId: $courseId, videosWatched: $videosWatched, videosTotal: $videosTotal, progressPercentage: $progressPercentage, completedAt: $completedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CourseProgressImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.courseId, courseId) ||
                other.courseId == courseId) &&
            (identical(other.videosWatched, videosWatched) ||
                other.videosWatched == videosWatched) &&
            (identical(other.videosTotal, videosTotal) ||
                other.videosTotal == videosTotal) &&
            (identical(other.progressPercentage, progressPercentage) ||
                other.progressPercentage == progressPercentage) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    userId,
    courseId,
    videosWatched,
    videosTotal,
    progressPercentage,
    completedAt,
  );

  /// Create a copy of CourseProgress
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CourseProgressImplCopyWith<_$CourseProgressImpl> get copyWith =>
      __$$CourseProgressImplCopyWithImpl<_$CourseProgressImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CourseProgressImplToJson(this);
  }
}

abstract class _CourseProgress implements CourseProgress {
  const factory _CourseProgress({
    required final String id,
    required final String userId,
    required final String courseId,
    final int videosWatched,
    final int videosTotal,
    final double progressPercentage,
    final DateTime? completedAt,
  }) = _$CourseProgressImpl;

  factory _CourseProgress.fromJson(Map<String, dynamic> json) =
      _$CourseProgressImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get courseId;
  @override
  int get videosWatched;
  @override
  int get videosTotal;
  @override
  double get progressPercentage;
  @override
  DateTime? get completedAt;

  /// Create a copy of CourseProgress
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CourseProgressImplCopyWith<_$CourseProgressImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
