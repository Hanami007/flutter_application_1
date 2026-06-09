// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'course.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Course {

 String get id; String get name; String get description; String get categoryId; String get instructorId; String? get thumbnailUrl; double get price; int get duration; String get level; double get rating; int get totalStudents; List<String>? get whatYouWillLearn; List<String>? get requirements; DateTime? get createdAt; DateTime? get updatedAt;
/// Create a copy of Course
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CourseCopyWith<Course> get copyWith => _$CourseCopyWithImpl<Course>(this as Course, _$identity);

  /// Serializes this Course to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Course&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.instructorId, instructorId) || other.instructorId == instructorId)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl)&&(identical(other.price, price) || other.price == price)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.level, level) || other.level == level)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.totalStudents, totalStudents) || other.totalStudents == totalStudents)&&const DeepCollectionEquality().equals(other.whatYouWillLearn, whatYouWillLearn)&&const DeepCollectionEquality().equals(other.requirements, requirements)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,categoryId,instructorId,thumbnailUrl,price,duration,level,rating,totalStudents,const DeepCollectionEquality().hash(whatYouWillLearn),const DeepCollectionEquality().hash(requirements),createdAt,updatedAt);

@override
String toString() {
  return 'Course(id: $id, name: $name, description: $description, categoryId: $categoryId, instructorId: $instructorId, thumbnailUrl: $thumbnailUrl, price: $price, duration: $duration, level: $level, rating: $rating, totalStudents: $totalStudents, whatYouWillLearn: $whatYouWillLearn, requirements: $requirements, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $CourseCopyWith<$Res>  {
  factory $CourseCopyWith(Course value, $Res Function(Course) _then) = _$CourseCopyWithImpl;
@useResult
$Res call({
 String id, String name, String description, String categoryId, String instructorId, String? thumbnailUrl, double price, int duration, String level, double rating, int totalStudents, List<String>? whatYouWillLearn, List<String>? requirements, DateTime? createdAt, DateTime? updatedAt
});




}
/// @nodoc
class _$CourseCopyWithImpl<$Res>
    implements $CourseCopyWith<$Res> {
  _$CourseCopyWithImpl(this._self, this._then);

  final Course _self;
  final $Res Function(Course) _then;

/// Create a copy of Course
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? description = null,Object? categoryId = null,Object? instructorId = null,Object? thumbnailUrl = freezed,Object? price = null,Object? duration = null,Object? level = null,Object? rating = null,Object? totalStudents = null,Object? whatYouWillLearn = freezed,Object? requirements = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,instructorId: null == instructorId ? _self.instructorId : instructorId // ignore: cast_nullable_to_non_nullable
as String,thumbnailUrl: freezed == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String?,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as int,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as String,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double,totalStudents: null == totalStudents ? _self.totalStudents : totalStudents // ignore: cast_nullable_to_non_nullable
as int,whatYouWillLearn: freezed == whatYouWillLearn ? _self.whatYouWillLearn : whatYouWillLearn // ignore: cast_nullable_to_non_nullable
as List<String>?,requirements: freezed == requirements ? _self.requirements : requirements // ignore: cast_nullable_to_non_nullable
as List<String>?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Course].
extension CoursePatterns on Course {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Course value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Course() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Course value)  $default,){
final _that = this;
switch (_that) {
case _Course():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Course value)?  $default,){
final _that = this;
switch (_that) {
case _Course() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String description,  String categoryId,  String instructorId,  String? thumbnailUrl,  double price,  int duration,  String level,  double rating,  int totalStudents,  List<String>? whatYouWillLearn,  List<String>? requirements,  DateTime? createdAt,  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Course() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.categoryId,_that.instructorId,_that.thumbnailUrl,_that.price,_that.duration,_that.level,_that.rating,_that.totalStudents,_that.whatYouWillLearn,_that.requirements,_that.createdAt,_that.updatedAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String description,  String categoryId,  String instructorId,  String? thumbnailUrl,  double price,  int duration,  String level,  double rating,  int totalStudents,  List<String>? whatYouWillLearn,  List<String>? requirements,  DateTime? createdAt,  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Course():
return $default(_that.id,_that.name,_that.description,_that.categoryId,_that.instructorId,_that.thumbnailUrl,_that.price,_that.duration,_that.level,_that.rating,_that.totalStudents,_that.whatYouWillLearn,_that.requirements,_that.createdAt,_that.updatedAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String description,  String categoryId,  String instructorId,  String? thumbnailUrl,  double price,  int duration,  String level,  double rating,  int totalStudents,  List<String>? whatYouWillLearn,  List<String>? requirements,  DateTime? createdAt,  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Course() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.categoryId,_that.instructorId,_that.thumbnailUrl,_that.price,_that.duration,_that.level,_that.rating,_that.totalStudents,_that.whatYouWillLearn,_that.requirements,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Course implements Course {
  const _Course({required this.id, required this.name, required this.description, required this.categoryId, required this.instructorId, this.thumbnailUrl, required this.price, required this.duration, required this.level, this.rating = 0.0, this.totalStudents = 0, final  List<String>? whatYouWillLearn, final  List<String>? requirements, this.createdAt, this.updatedAt}): _whatYouWillLearn = whatYouWillLearn,_requirements = requirements;
  factory _Course.fromJson(Map<String, dynamic> json) => _$CourseFromJson(json);

@override final  String id;
@override final  String name;
@override final  String description;
@override final  String categoryId;
@override final  String instructorId;
@override final  String? thumbnailUrl;
@override final  double price;
@override final  int duration;
@override final  String level;
@override@JsonKey() final  double rating;
@override@JsonKey() final  int totalStudents;
 final  List<String>? _whatYouWillLearn;
@override List<String>? get whatYouWillLearn {
  final value = _whatYouWillLearn;
  if (value == null) return null;
  if (_whatYouWillLearn is EqualUnmodifiableListView) return _whatYouWillLearn;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<String>? _requirements;
@override List<String>? get requirements {
  final value = _requirements;
  if (value == null) return null;
  if (_requirements is EqualUnmodifiableListView) return _requirements;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  DateTime? createdAt;
@override final  DateTime? updatedAt;

/// Create a copy of Course
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CourseCopyWith<_Course> get copyWith => __$CourseCopyWithImpl<_Course>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CourseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Course&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.instructorId, instructorId) || other.instructorId == instructorId)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl)&&(identical(other.price, price) || other.price == price)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.level, level) || other.level == level)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.totalStudents, totalStudents) || other.totalStudents == totalStudents)&&const DeepCollectionEquality().equals(other._whatYouWillLearn, _whatYouWillLearn)&&const DeepCollectionEquality().equals(other._requirements, _requirements)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,categoryId,instructorId,thumbnailUrl,price,duration,level,rating,totalStudents,const DeepCollectionEquality().hash(_whatYouWillLearn),const DeepCollectionEquality().hash(_requirements),createdAt,updatedAt);

@override
String toString() {
  return 'Course(id: $id, name: $name, description: $description, categoryId: $categoryId, instructorId: $instructorId, thumbnailUrl: $thumbnailUrl, price: $price, duration: $duration, level: $level, rating: $rating, totalStudents: $totalStudents, whatYouWillLearn: $whatYouWillLearn, requirements: $requirements, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$CourseCopyWith<$Res> implements $CourseCopyWith<$Res> {
  factory _$CourseCopyWith(_Course value, $Res Function(_Course) _then) = __$CourseCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String description, String categoryId, String instructorId, String? thumbnailUrl, double price, int duration, String level, double rating, int totalStudents, List<String>? whatYouWillLearn, List<String>? requirements, DateTime? createdAt, DateTime? updatedAt
});




}
/// @nodoc
class __$CourseCopyWithImpl<$Res>
    implements _$CourseCopyWith<$Res> {
  __$CourseCopyWithImpl(this._self, this._then);

  final _Course _self;
  final $Res Function(_Course) _then;

/// Create a copy of Course
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? description = null,Object? categoryId = null,Object? instructorId = null,Object? thumbnailUrl = freezed,Object? price = null,Object? duration = null,Object? level = null,Object? rating = null,Object? totalStudents = null,Object? whatYouWillLearn = freezed,Object? requirements = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_Course(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,instructorId: null == instructorId ? _self.instructorId : instructorId // ignore: cast_nullable_to_non_nullable
as String,thumbnailUrl: freezed == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String?,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as int,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as String,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double,totalStudents: null == totalStudents ? _self.totalStudents : totalStudents // ignore: cast_nullable_to_non_nullable
as int,whatYouWillLearn: freezed == whatYouWillLearn ? _self._whatYouWillLearn : whatYouWillLearn // ignore: cast_nullable_to_non_nullable
as List<String>?,requirements: freezed == requirements ? _self._requirements : requirements // ignore: cast_nullable_to_non_nullable
as List<String>?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$Category {

 String get id; String get name; String? get description; String? get iconUrl;
/// Create a copy of Category
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CategoryCopyWith<Category> get copyWith => _$CategoryCopyWithImpl<Category>(this as Category, _$identity);

  /// Serializes this Category to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Category&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.iconUrl, iconUrl) || other.iconUrl == iconUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,iconUrl);

@override
String toString() {
  return 'Category(id: $id, name: $name, description: $description, iconUrl: $iconUrl)';
}


}

/// @nodoc
abstract mixin class $CategoryCopyWith<$Res>  {
  factory $CategoryCopyWith(Category value, $Res Function(Category) _then) = _$CategoryCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? description, String? iconUrl
});




}
/// @nodoc
class _$CategoryCopyWithImpl<$Res>
    implements $CategoryCopyWith<$Res> {
  _$CategoryCopyWithImpl(this._self, this._then);

  final Category _self;
  final $Res Function(Category) _then;

/// Create a copy of Category
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? description = freezed,Object? iconUrl = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,iconUrl: freezed == iconUrl ? _self.iconUrl : iconUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Category].
extension CategoryPatterns on Category {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Category value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Category() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Category value)  $default,){
final _that = this;
switch (_that) {
case _Category():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Category value)?  $default,){
final _that = this;
switch (_that) {
case _Category() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String? description,  String? iconUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Category() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.iconUrl);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String? description,  String? iconUrl)  $default,) {final _that = this;
switch (_that) {
case _Category():
return $default(_that.id,_that.name,_that.description,_that.iconUrl);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String? description,  String? iconUrl)?  $default,) {final _that = this;
switch (_that) {
case _Category() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.iconUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Category implements Category {
  const _Category({required this.id, required this.name, this.description, this.iconUrl});
  factory _Category.fromJson(Map<String, dynamic> json) => _$CategoryFromJson(json);

@override final  String id;
@override final  String name;
@override final  String? description;
@override final  String? iconUrl;

/// Create a copy of Category
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CategoryCopyWith<_Category> get copyWith => __$CategoryCopyWithImpl<_Category>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CategoryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Category&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.iconUrl, iconUrl) || other.iconUrl == iconUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,iconUrl);

@override
String toString() {
  return 'Category(id: $id, name: $name, description: $description, iconUrl: $iconUrl)';
}


}

/// @nodoc
abstract mixin class _$CategoryCopyWith<$Res> implements $CategoryCopyWith<$Res> {
  factory _$CategoryCopyWith(_Category value, $Res Function(_Category) _then) = __$CategoryCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? description, String? iconUrl
});




}
/// @nodoc
class __$CategoryCopyWithImpl<$Res>
    implements _$CategoryCopyWith<$Res> {
  __$CategoryCopyWithImpl(this._self, this._then);

  final _Category _self;
  final $Res Function(_Category) _then;

/// Create a copy of Category
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? description = freezed,Object? iconUrl = freezed,}) {
  return _then(_Category(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,iconUrl: freezed == iconUrl ? _self.iconUrl : iconUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$CourseProgress {

 String get id; String get userId; String get courseId; int get videosWatched; int get videosTotal; double get progressPercentage; DateTime? get completedAt;
/// Create a copy of CourseProgress
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CourseProgressCopyWith<CourseProgress> get copyWith => _$CourseProgressCopyWithImpl<CourseProgress>(this as CourseProgress, _$identity);

  /// Serializes this CourseProgress to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CourseProgress&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.courseId, courseId) || other.courseId == courseId)&&(identical(other.videosWatched, videosWatched) || other.videosWatched == videosWatched)&&(identical(other.videosTotal, videosTotal) || other.videosTotal == videosTotal)&&(identical(other.progressPercentage, progressPercentage) || other.progressPercentage == progressPercentage)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,courseId,videosWatched,videosTotal,progressPercentage,completedAt);

@override
String toString() {
  return 'CourseProgress(id: $id, userId: $userId, courseId: $courseId, videosWatched: $videosWatched, videosTotal: $videosTotal, progressPercentage: $progressPercentage, completedAt: $completedAt)';
}


}

/// @nodoc
abstract mixin class $CourseProgressCopyWith<$Res>  {
  factory $CourseProgressCopyWith(CourseProgress value, $Res Function(CourseProgress) _then) = _$CourseProgressCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String courseId, int videosWatched, int videosTotal, double progressPercentage, DateTime? completedAt
});




}
/// @nodoc
class _$CourseProgressCopyWithImpl<$Res>
    implements $CourseProgressCopyWith<$Res> {
  _$CourseProgressCopyWithImpl(this._self, this._then);

  final CourseProgress _self;
  final $Res Function(CourseProgress) _then;

/// Create a copy of CourseProgress
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? courseId = null,Object? videosWatched = null,Object? videosTotal = null,Object? progressPercentage = null,Object? completedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,courseId: null == courseId ? _self.courseId : courseId // ignore: cast_nullable_to_non_nullable
as String,videosWatched: null == videosWatched ? _self.videosWatched : videosWatched // ignore: cast_nullable_to_non_nullable
as int,videosTotal: null == videosTotal ? _self.videosTotal : videosTotal // ignore: cast_nullable_to_non_nullable
as int,progressPercentage: null == progressPercentage ? _self.progressPercentage : progressPercentage // ignore: cast_nullable_to_non_nullable
as double,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [CourseProgress].
extension CourseProgressPatterns on CourseProgress {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CourseProgress value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CourseProgress() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CourseProgress value)  $default,){
final _that = this;
switch (_that) {
case _CourseProgress():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CourseProgress value)?  $default,){
final _that = this;
switch (_that) {
case _CourseProgress() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  String courseId,  int videosWatched,  int videosTotal,  double progressPercentage,  DateTime? completedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CourseProgress() when $default != null:
return $default(_that.id,_that.userId,_that.courseId,_that.videosWatched,_that.videosTotal,_that.progressPercentage,_that.completedAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  String courseId,  int videosWatched,  int videosTotal,  double progressPercentage,  DateTime? completedAt)  $default,) {final _that = this;
switch (_that) {
case _CourseProgress():
return $default(_that.id,_that.userId,_that.courseId,_that.videosWatched,_that.videosTotal,_that.progressPercentage,_that.completedAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  String courseId,  int videosWatched,  int videosTotal,  double progressPercentage,  DateTime? completedAt)?  $default,) {final _that = this;
switch (_that) {
case _CourseProgress() when $default != null:
return $default(_that.id,_that.userId,_that.courseId,_that.videosWatched,_that.videosTotal,_that.progressPercentage,_that.completedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CourseProgress implements CourseProgress {
  const _CourseProgress({required this.id, required this.userId, required this.courseId, this.videosWatched = 0, this.videosTotal = 0, this.progressPercentage = 0.0, this.completedAt});
  factory _CourseProgress.fromJson(Map<String, dynamic> json) => _$CourseProgressFromJson(json);

@override final  String id;
@override final  String userId;
@override final  String courseId;
@override@JsonKey() final  int videosWatched;
@override@JsonKey() final  int videosTotal;
@override@JsonKey() final  double progressPercentage;
@override final  DateTime? completedAt;

/// Create a copy of CourseProgress
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CourseProgressCopyWith<_CourseProgress> get copyWith => __$CourseProgressCopyWithImpl<_CourseProgress>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CourseProgressToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CourseProgress&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.courseId, courseId) || other.courseId == courseId)&&(identical(other.videosWatched, videosWatched) || other.videosWatched == videosWatched)&&(identical(other.videosTotal, videosTotal) || other.videosTotal == videosTotal)&&(identical(other.progressPercentage, progressPercentage) || other.progressPercentage == progressPercentage)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,courseId,videosWatched,videosTotal,progressPercentage,completedAt);

@override
String toString() {
  return 'CourseProgress(id: $id, userId: $userId, courseId: $courseId, videosWatched: $videosWatched, videosTotal: $videosTotal, progressPercentage: $progressPercentage, completedAt: $completedAt)';
}


}

/// @nodoc
abstract mixin class _$CourseProgressCopyWith<$Res> implements $CourseProgressCopyWith<$Res> {
  factory _$CourseProgressCopyWith(_CourseProgress value, $Res Function(_CourseProgress) _then) = __$CourseProgressCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String courseId, int videosWatched, int videosTotal, double progressPercentage, DateTime? completedAt
});




}
/// @nodoc
class __$CourseProgressCopyWithImpl<$Res>
    implements _$CourseProgressCopyWith<$Res> {
  __$CourseProgressCopyWithImpl(this._self, this._then);

  final _CourseProgress _self;
  final $Res Function(_CourseProgress) _then;

/// Create a copy of CourseProgress
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? courseId = null,Object? videosWatched = null,Object? videosTotal = null,Object? progressPercentage = null,Object? completedAt = freezed,}) {
  return _then(_CourseProgress(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,courseId: null == courseId ? _self.courseId : courseId // ignore: cast_nullable_to_non_nullable
as String,videosWatched: null == videosWatched ? _self.videosWatched : videosWatched // ignore: cast_nullable_to_non_nullable
as int,videosTotal: null == videosTotal ? _self.videosTotal : videosTotal // ignore: cast_nullable_to_non_nullable
as int,progressPercentage: null == progressPercentage ? _self.progressPercentage : progressPercentage // ignore: cast_nullable_to_non_nullable
as double,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
