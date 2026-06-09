// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'booking.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Booking {

 String get id; String get userId; String get classSessionId; String get status; String? get attendanceStatus; DateTime? get bookingDate; DateTime? get createdAt; DateTime? get updatedAt;
/// Create a copy of Booking
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookingCopyWith<Booking> get copyWith => _$BookingCopyWithImpl<Booking>(this as Booking, _$identity);

  /// Serializes this Booking to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Booking&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.classSessionId, classSessionId) || other.classSessionId == classSessionId)&&(identical(other.status, status) || other.status == status)&&(identical(other.attendanceStatus, attendanceStatus) || other.attendanceStatus == attendanceStatus)&&(identical(other.bookingDate, bookingDate) || other.bookingDate == bookingDate)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,classSessionId,status,attendanceStatus,bookingDate,createdAt,updatedAt);

@override
String toString() {
  return 'Booking(id: $id, userId: $userId, classSessionId: $classSessionId, status: $status, attendanceStatus: $attendanceStatus, bookingDate: $bookingDate, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $BookingCopyWith<$Res>  {
  factory $BookingCopyWith(Booking value, $Res Function(Booking) _then) = _$BookingCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String classSessionId, String status, String? attendanceStatus, DateTime? bookingDate, DateTime? createdAt, DateTime? updatedAt
});




}
/// @nodoc
class _$BookingCopyWithImpl<$Res>
    implements $BookingCopyWith<$Res> {
  _$BookingCopyWithImpl(this._self, this._then);

  final Booking _self;
  final $Res Function(Booking) _then;

/// Create a copy of Booking
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? classSessionId = null,Object? status = null,Object? attendanceStatus = freezed,Object? bookingDate = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,classSessionId: null == classSessionId ? _self.classSessionId : classSessionId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,attendanceStatus: freezed == attendanceStatus ? _self.attendanceStatus : attendanceStatus // ignore: cast_nullable_to_non_nullable
as String?,bookingDate: freezed == bookingDate ? _self.bookingDate : bookingDate // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Booking].
extension BookingPatterns on Booking {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Booking value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Booking() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Booking value)  $default,){
final _that = this;
switch (_that) {
case _Booking():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Booking value)?  $default,){
final _that = this;
switch (_that) {
case _Booking() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  String classSessionId,  String status,  String? attendanceStatus,  DateTime? bookingDate,  DateTime? createdAt,  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Booking() when $default != null:
return $default(_that.id,_that.userId,_that.classSessionId,_that.status,_that.attendanceStatus,_that.bookingDate,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  String classSessionId,  String status,  String? attendanceStatus,  DateTime? bookingDate,  DateTime? createdAt,  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Booking():
return $default(_that.id,_that.userId,_that.classSessionId,_that.status,_that.attendanceStatus,_that.bookingDate,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  String classSessionId,  String status,  String? attendanceStatus,  DateTime? bookingDate,  DateTime? createdAt,  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Booking() when $default != null:
return $default(_that.id,_that.userId,_that.classSessionId,_that.status,_that.attendanceStatus,_that.bookingDate,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Booking implements Booking {
  const _Booking({required this.id, required this.userId, required this.classSessionId, this.status = 'confirmed', this.attendanceStatus, this.bookingDate, this.createdAt, this.updatedAt});
  factory _Booking.fromJson(Map<String, dynamic> json) => _$BookingFromJson(json);

@override final  String id;
@override final  String userId;
@override final  String classSessionId;
@override@JsonKey() final  String status;
@override final  String? attendanceStatus;
@override final  DateTime? bookingDate;
@override final  DateTime? createdAt;
@override final  DateTime? updatedAt;

/// Create a copy of Booking
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookingCopyWith<_Booking> get copyWith => __$BookingCopyWithImpl<_Booking>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BookingToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Booking&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.classSessionId, classSessionId) || other.classSessionId == classSessionId)&&(identical(other.status, status) || other.status == status)&&(identical(other.attendanceStatus, attendanceStatus) || other.attendanceStatus == attendanceStatus)&&(identical(other.bookingDate, bookingDate) || other.bookingDate == bookingDate)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,classSessionId,status,attendanceStatus,bookingDate,createdAt,updatedAt);

@override
String toString() {
  return 'Booking(id: $id, userId: $userId, classSessionId: $classSessionId, status: $status, attendanceStatus: $attendanceStatus, bookingDate: $bookingDate, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$BookingCopyWith<$Res> implements $BookingCopyWith<$Res> {
  factory _$BookingCopyWith(_Booking value, $Res Function(_Booking) _then) = __$BookingCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String classSessionId, String status, String? attendanceStatus, DateTime? bookingDate, DateTime? createdAt, DateTime? updatedAt
});




}
/// @nodoc
class __$BookingCopyWithImpl<$Res>
    implements _$BookingCopyWith<$Res> {
  __$BookingCopyWithImpl(this._self, this._then);

  final _Booking _self;
  final $Res Function(_Booking) _then;

/// Create a copy of Booking
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? classSessionId = null,Object? status = null,Object? attendanceStatus = freezed,Object? bookingDate = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_Booking(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,classSessionId: null == classSessionId ? _self.classSessionId : classSessionId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,attendanceStatus: freezed == attendanceStatus ? _self.attendanceStatus : attendanceStatus // ignore: cast_nullable_to_non_nullable
as String?,bookingDate: freezed == bookingDate ? _self.bookingDate : bookingDate // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$ClassSession {

 String get id; String get courseId; String? get branchId; String get teacherId; String get sessionType; DateTime get startTime; DateTime get endTime; int? get capacity; int get enrolledCount; String get status; String? get recordingUrl; String? get meetingLink;
/// Create a copy of ClassSession
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ClassSessionCopyWith<ClassSession> get copyWith => _$ClassSessionCopyWithImpl<ClassSession>(this as ClassSession, _$identity);

  /// Serializes this ClassSession to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ClassSession&&(identical(other.id, id) || other.id == id)&&(identical(other.courseId, courseId) || other.courseId == courseId)&&(identical(other.branchId, branchId) || other.branchId == branchId)&&(identical(other.teacherId, teacherId) || other.teacherId == teacherId)&&(identical(other.sessionType, sessionType) || other.sessionType == sessionType)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.capacity, capacity) || other.capacity == capacity)&&(identical(other.enrolledCount, enrolledCount) || other.enrolledCount == enrolledCount)&&(identical(other.status, status) || other.status == status)&&(identical(other.recordingUrl, recordingUrl) || other.recordingUrl == recordingUrl)&&(identical(other.meetingLink, meetingLink) || other.meetingLink == meetingLink));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,courseId,branchId,teacherId,sessionType,startTime,endTime,capacity,enrolledCount,status,recordingUrl,meetingLink);

@override
String toString() {
  return 'ClassSession(id: $id, courseId: $courseId, branchId: $branchId, teacherId: $teacherId, sessionType: $sessionType, startTime: $startTime, endTime: $endTime, capacity: $capacity, enrolledCount: $enrolledCount, status: $status, recordingUrl: $recordingUrl, meetingLink: $meetingLink)';
}


}

/// @nodoc
abstract mixin class $ClassSessionCopyWith<$Res>  {
  factory $ClassSessionCopyWith(ClassSession value, $Res Function(ClassSession) _then) = _$ClassSessionCopyWithImpl;
@useResult
$Res call({
 String id, String courseId, String? branchId, String teacherId, String sessionType, DateTime startTime, DateTime endTime, int? capacity, int enrolledCount, String status, String? recordingUrl, String? meetingLink
});




}
/// @nodoc
class _$ClassSessionCopyWithImpl<$Res>
    implements $ClassSessionCopyWith<$Res> {
  _$ClassSessionCopyWithImpl(this._self, this._then);

  final ClassSession _self;
  final $Res Function(ClassSession) _then;

/// Create a copy of ClassSession
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? courseId = null,Object? branchId = freezed,Object? teacherId = null,Object? sessionType = null,Object? startTime = null,Object? endTime = null,Object? capacity = freezed,Object? enrolledCount = null,Object? status = null,Object? recordingUrl = freezed,Object? meetingLink = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,courseId: null == courseId ? _self.courseId : courseId // ignore: cast_nullable_to_non_nullable
as String,branchId: freezed == branchId ? _self.branchId : branchId // ignore: cast_nullable_to_non_nullable
as String?,teacherId: null == teacherId ? _self.teacherId : teacherId // ignore: cast_nullable_to_non_nullable
as String,sessionType: null == sessionType ? _self.sessionType : sessionType // ignore: cast_nullable_to_non_nullable
as String,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as DateTime,endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as DateTime,capacity: freezed == capacity ? _self.capacity : capacity // ignore: cast_nullable_to_non_nullable
as int?,enrolledCount: null == enrolledCount ? _self.enrolledCount : enrolledCount // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,recordingUrl: freezed == recordingUrl ? _self.recordingUrl : recordingUrl // ignore: cast_nullable_to_non_nullable
as String?,meetingLink: freezed == meetingLink ? _self.meetingLink : meetingLink // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ClassSession].
extension ClassSessionPatterns on ClassSession {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ClassSession value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ClassSession() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ClassSession value)  $default,){
final _that = this;
switch (_that) {
case _ClassSession():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ClassSession value)?  $default,){
final _that = this;
switch (_that) {
case _ClassSession() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String courseId,  String? branchId,  String teacherId,  String sessionType,  DateTime startTime,  DateTime endTime,  int? capacity,  int enrolledCount,  String status,  String? recordingUrl,  String? meetingLink)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ClassSession() when $default != null:
return $default(_that.id,_that.courseId,_that.branchId,_that.teacherId,_that.sessionType,_that.startTime,_that.endTime,_that.capacity,_that.enrolledCount,_that.status,_that.recordingUrl,_that.meetingLink);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String courseId,  String? branchId,  String teacherId,  String sessionType,  DateTime startTime,  DateTime endTime,  int? capacity,  int enrolledCount,  String status,  String? recordingUrl,  String? meetingLink)  $default,) {final _that = this;
switch (_that) {
case _ClassSession():
return $default(_that.id,_that.courseId,_that.branchId,_that.teacherId,_that.sessionType,_that.startTime,_that.endTime,_that.capacity,_that.enrolledCount,_that.status,_that.recordingUrl,_that.meetingLink);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String courseId,  String? branchId,  String teacherId,  String sessionType,  DateTime startTime,  DateTime endTime,  int? capacity,  int enrolledCount,  String status,  String? recordingUrl,  String? meetingLink)?  $default,) {final _that = this;
switch (_that) {
case _ClassSession() when $default != null:
return $default(_that.id,_that.courseId,_that.branchId,_that.teacherId,_that.sessionType,_that.startTime,_that.endTime,_that.capacity,_that.enrolledCount,_that.status,_that.recordingUrl,_that.meetingLink);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ClassSession implements ClassSession {
  const _ClassSession({required this.id, required this.courseId, this.branchId, required this.teacherId, this.sessionType = 'online', required this.startTime, required this.endTime, this.capacity, this.enrolledCount = 0, this.status = 'scheduled', this.recordingUrl, this.meetingLink});
  factory _ClassSession.fromJson(Map<String, dynamic> json) => _$ClassSessionFromJson(json);

@override final  String id;
@override final  String courseId;
@override final  String? branchId;
@override final  String teacherId;
@override@JsonKey() final  String sessionType;
@override final  DateTime startTime;
@override final  DateTime endTime;
@override final  int? capacity;
@override@JsonKey() final  int enrolledCount;
@override@JsonKey() final  String status;
@override final  String? recordingUrl;
@override final  String? meetingLink;

/// Create a copy of ClassSession
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ClassSessionCopyWith<_ClassSession> get copyWith => __$ClassSessionCopyWithImpl<_ClassSession>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ClassSessionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ClassSession&&(identical(other.id, id) || other.id == id)&&(identical(other.courseId, courseId) || other.courseId == courseId)&&(identical(other.branchId, branchId) || other.branchId == branchId)&&(identical(other.teacherId, teacherId) || other.teacherId == teacherId)&&(identical(other.sessionType, sessionType) || other.sessionType == sessionType)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.capacity, capacity) || other.capacity == capacity)&&(identical(other.enrolledCount, enrolledCount) || other.enrolledCount == enrolledCount)&&(identical(other.status, status) || other.status == status)&&(identical(other.recordingUrl, recordingUrl) || other.recordingUrl == recordingUrl)&&(identical(other.meetingLink, meetingLink) || other.meetingLink == meetingLink));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,courseId,branchId,teacherId,sessionType,startTime,endTime,capacity,enrolledCount,status,recordingUrl,meetingLink);

@override
String toString() {
  return 'ClassSession(id: $id, courseId: $courseId, branchId: $branchId, teacherId: $teacherId, sessionType: $sessionType, startTime: $startTime, endTime: $endTime, capacity: $capacity, enrolledCount: $enrolledCount, status: $status, recordingUrl: $recordingUrl, meetingLink: $meetingLink)';
}


}

/// @nodoc
abstract mixin class _$ClassSessionCopyWith<$Res> implements $ClassSessionCopyWith<$Res> {
  factory _$ClassSessionCopyWith(_ClassSession value, $Res Function(_ClassSession) _then) = __$ClassSessionCopyWithImpl;
@override @useResult
$Res call({
 String id, String courseId, String? branchId, String teacherId, String sessionType, DateTime startTime, DateTime endTime, int? capacity, int enrolledCount, String status, String? recordingUrl, String? meetingLink
});




}
/// @nodoc
class __$ClassSessionCopyWithImpl<$Res>
    implements _$ClassSessionCopyWith<$Res> {
  __$ClassSessionCopyWithImpl(this._self, this._then);

  final _ClassSession _self;
  final $Res Function(_ClassSession) _then;

/// Create a copy of ClassSession
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? courseId = null,Object? branchId = freezed,Object? teacherId = null,Object? sessionType = null,Object? startTime = null,Object? endTime = null,Object? capacity = freezed,Object? enrolledCount = null,Object? status = null,Object? recordingUrl = freezed,Object? meetingLink = freezed,}) {
  return _then(_ClassSession(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,courseId: null == courseId ? _self.courseId : courseId // ignore: cast_nullable_to_non_nullable
as String,branchId: freezed == branchId ? _self.branchId : branchId // ignore: cast_nullable_to_non_nullable
as String?,teacherId: null == teacherId ? _self.teacherId : teacherId // ignore: cast_nullable_to_non_nullable
as String,sessionType: null == sessionType ? _self.sessionType : sessionType // ignore: cast_nullable_to_non_nullable
as String,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as DateTime,endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as DateTime,capacity: freezed == capacity ? _self.capacity : capacity // ignore: cast_nullable_to_non_nullable
as int?,enrolledCount: null == enrolledCount ? _self.enrolledCount : enrolledCount // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,recordingUrl: freezed == recordingUrl ? _self.recordingUrl : recordingUrl // ignore: cast_nullable_to_non_nullable
as String?,meetingLink: freezed == meetingLink ? _self.meetingLink : meetingLink // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$Branch {

 String get id; String get name; String get address; String get city; String get state; String? get zipCode; String? get phone; double? get latitude; double? get longitude; int? get capacity;
/// Create a copy of Branch
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BranchCopyWith<Branch> get copyWith => _$BranchCopyWithImpl<Branch>(this as Branch, _$identity);

  /// Serializes this Branch to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Branch&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.address, address) || other.address == address)&&(identical(other.city, city) || other.city == city)&&(identical(other.state, state) || other.state == state)&&(identical(other.zipCode, zipCode) || other.zipCode == zipCode)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.capacity, capacity) || other.capacity == capacity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,address,city,state,zipCode,phone,latitude,longitude,capacity);

@override
String toString() {
  return 'Branch(id: $id, name: $name, address: $address, city: $city, state: $state, zipCode: $zipCode, phone: $phone, latitude: $latitude, longitude: $longitude, capacity: $capacity)';
}


}

/// @nodoc
abstract mixin class $BranchCopyWith<$Res>  {
  factory $BranchCopyWith(Branch value, $Res Function(Branch) _then) = _$BranchCopyWithImpl;
@useResult
$Res call({
 String id, String name, String address, String city, String state, String? zipCode, String? phone, double? latitude, double? longitude, int? capacity
});




}
/// @nodoc
class _$BranchCopyWithImpl<$Res>
    implements $BranchCopyWith<$Res> {
  _$BranchCopyWithImpl(this._self, this._then);

  final Branch _self;
  final $Res Function(Branch) _then;

/// Create a copy of Branch
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? address = null,Object? city = null,Object? state = null,Object? zipCode = freezed,Object? phone = freezed,Object? latitude = freezed,Object? longitude = freezed,Object? capacity = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String,zipCode: freezed == zipCode ? _self.zipCode : zipCode // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,capacity: freezed == capacity ? _self.capacity : capacity // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [Branch].
extension BranchPatterns on Branch {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Branch value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Branch() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Branch value)  $default,){
final _that = this;
switch (_that) {
case _Branch():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Branch value)?  $default,){
final _that = this;
switch (_that) {
case _Branch() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String address,  String city,  String state,  String? zipCode,  String? phone,  double? latitude,  double? longitude,  int? capacity)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Branch() when $default != null:
return $default(_that.id,_that.name,_that.address,_that.city,_that.state,_that.zipCode,_that.phone,_that.latitude,_that.longitude,_that.capacity);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String address,  String city,  String state,  String? zipCode,  String? phone,  double? latitude,  double? longitude,  int? capacity)  $default,) {final _that = this;
switch (_that) {
case _Branch():
return $default(_that.id,_that.name,_that.address,_that.city,_that.state,_that.zipCode,_that.phone,_that.latitude,_that.longitude,_that.capacity);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String address,  String city,  String state,  String? zipCode,  String? phone,  double? latitude,  double? longitude,  int? capacity)?  $default,) {final _that = this;
switch (_that) {
case _Branch() when $default != null:
return $default(_that.id,_that.name,_that.address,_that.city,_that.state,_that.zipCode,_that.phone,_that.latitude,_that.longitude,_that.capacity);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Branch implements Branch {
  const _Branch({required this.id, required this.name, required this.address, required this.city, required this.state, this.zipCode, this.phone, this.latitude, this.longitude, this.capacity});
  factory _Branch.fromJson(Map<String, dynamic> json) => _$BranchFromJson(json);

@override final  String id;
@override final  String name;
@override final  String address;
@override final  String city;
@override final  String state;
@override final  String? zipCode;
@override final  String? phone;
@override final  double? latitude;
@override final  double? longitude;
@override final  int? capacity;

/// Create a copy of Branch
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BranchCopyWith<_Branch> get copyWith => __$BranchCopyWithImpl<_Branch>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BranchToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Branch&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.address, address) || other.address == address)&&(identical(other.city, city) || other.city == city)&&(identical(other.state, state) || other.state == state)&&(identical(other.zipCode, zipCode) || other.zipCode == zipCode)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.capacity, capacity) || other.capacity == capacity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,address,city,state,zipCode,phone,latitude,longitude,capacity);

@override
String toString() {
  return 'Branch(id: $id, name: $name, address: $address, city: $city, state: $state, zipCode: $zipCode, phone: $phone, latitude: $latitude, longitude: $longitude, capacity: $capacity)';
}


}

/// @nodoc
abstract mixin class _$BranchCopyWith<$Res> implements $BranchCopyWith<$Res> {
  factory _$BranchCopyWith(_Branch value, $Res Function(_Branch) _then) = __$BranchCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String address, String city, String state, String? zipCode, String? phone, double? latitude, double? longitude, int? capacity
});




}
/// @nodoc
class __$BranchCopyWithImpl<$Res>
    implements _$BranchCopyWith<$Res> {
  __$BranchCopyWithImpl(this._self, this._then);

  final _Branch _self;
  final $Res Function(_Branch) _then;

/// Create a copy of Branch
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? address = null,Object? city = null,Object? state = null,Object? zipCode = freezed,Object? phone = freezed,Object? latitude = freezed,Object? longitude = freezed,Object? capacity = freezed,}) {
  return _then(_Branch(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String,zipCode: freezed == zipCode ? _self.zipCode : zipCode // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,capacity: freezed == capacity ? _self.capacity : capacity // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
