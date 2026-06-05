// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'booking.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Booking _$BookingFromJson(Map<String, dynamic> json) {
  return _Booking.fromJson(json);
}

/// @nodoc
mixin _$Booking {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get classSessionId => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String? get attendanceStatus => throw _privateConstructorUsedError;
  DateTime? get bookingDate => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Booking to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Booking
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BookingCopyWith<Booking> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BookingCopyWith<$Res> {
  factory $BookingCopyWith(Booking value, $Res Function(Booking) then) =
      _$BookingCopyWithImpl<$Res, Booking>;
  @useResult
  $Res call({
    String id,
    String userId,
    String classSessionId,
    String status,
    String? attendanceStatus,
    DateTime? bookingDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class _$BookingCopyWithImpl<$Res, $Val extends Booking>
    implements $BookingCopyWith<$Res> {
  _$BookingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Booking
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? classSessionId = null,
    Object? status = null,
    Object? attendanceStatus = freezed,
    Object? bookingDate = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
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
            classSessionId: null == classSessionId
                ? _value.classSessionId
                : classSessionId // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            attendanceStatus: freezed == attendanceStatus
                ? _value.attendanceStatus
                : attendanceStatus // ignore: cast_nullable_to_non_nullable
                      as String?,
            bookingDate: freezed == bookingDate
                ? _value.bookingDate
                : bookingDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
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
abstract class _$$BookingImplCopyWith<$Res> implements $BookingCopyWith<$Res> {
  factory _$$BookingImplCopyWith(
    _$BookingImpl value,
    $Res Function(_$BookingImpl) then,
  ) = __$$BookingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String userId,
    String classSessionId,
    String status,
    String? attendanceStatus,
    DateTime? bookingDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class __$$BookingImplCopyWithImpl<$Res>
    extends _$BookingCopyWithImpl<$Res, _$BookingImpl>
    implements _$$BookingImplCopyWith<$Res> {
  __$$BookingImplCopyWithImpl(
    _$BookingImpl _value,
    $Res Function(_$BookingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Booking
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? classSessionId = null,
    Object? status = null,
    Object? attendanceStatus = freezed,
    Object? bookingDate = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$BookingImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        classSessionId: null == classSessionId
            ? _value.classSessionId
            : classSessionId // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        attendanceStatus: freezed == attendanceStatus
            ? _value.attendanceStatus
            : attendanceStatus // ignore: cast_nullable_to_non_nullable
                  as String?,
        bookingDate: freezed == bookingDate
            ? _value.bookingDate
            : bookingDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
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
class _$BookingImpl implements _Booking {
  const _$BookingImpl({
    required this.id,
    required this.userId,
    required this.classSessionId,
    this.status = 'confirmed',
    this.attendanceStatus,
    this.bookingDate,
    this.createdAt,
    this.updatedAt,
  });

  factory _$BookingImpl.fromJson(Map<String, dynamic> json) =>
      _$$BookingImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String classSessionId;
  @override
  @JsonKey()
  final String status;
  @override
  final String? attendanceStatus;
  @override
  final DateTime? bookingDate;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'Booking(id: $id, userId: $userId, classSessionId: $classSessionId, status: $status, attendanceStatus: $attendanceStatus, bookingDate: $bookingDate, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BookingImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.classSessionId, classSessionId) ||
                other.classSessionId == classSessionId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.attendanceStatus, attendanceStatus) ||
                other.attendanceStatus == attendanceStatus) &&
            (identical(other.bookingDate, bookingDate) ||
                other.bookingDate == bookingDate) &&
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
    userId,
    classSessionId,
    status,
    attendanceStatus,
    bookingDate,
    createdAt,
    updatedAt,
  );

  /// Create a copy of Booking
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BookingImplCopyWith<_$BookingImpl> get copyWith =>
      __$$BookingImplCopyWithImpl<_$BookingImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BookingImplToJson(this);
  }
}

abstract class _Booking implements Booking {
  const factory _Booking({
    required final String id,
    required final String userId,
    required final String classSessionId,
    final String status,
    final String? attendanceStatus,
    final DateTime? bookingDate,
    final DateTime? createdAt,
    final DateTime? updatedAt,
  }) = _$BookingImpl;

  factory _Booking.fromJson(Map<String, dynamic> json) = _$BookingImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get classSessionId;
  @override
  String get status;
  @override
  String? get attendanceStatus;
  @override
  DateTime? get bookingDate;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of Booking
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BookingImplCopyWith<_$BookingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ClassSession _$ClassSessionFromJson(Map<String, dynamic> json) {
  return _ClassSession.fromJson(json);
}

/// @nodoc
mixin _$ClassSession {
  String get id => throw _privateConstructorUsedError;
  String get courseId => throw _privateConstructorUsedError;
  String? get branchId => throw _privateConstructorUsedError;
  String get teacherId => throw _privateConstructorUsedError;
  String get sessionType => throw _privateConstructorUsedError;
  DateTime get startTime => throw _privateConstructorUsedError;
  DateTime get endTime => throw _privateConstructorUsedError;
  int? get capacity => throw _privateConstructorUsedError;
  int get enrolledCount => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String? get recordingUrl => throw _privateConstructorUsedError;
  String? get meetingLink => throw _privateConstructorUsedError;

  /// Serializes this ClassSession to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ClassSession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ClassSessionCopyWith<ClassSession> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ClassSessionCopyWith<$Res> {
  factory $ClassSessionCopyWith(
    ClassSession value,
    $Res Function(ClassSession) then,
  ) = _$ClassSessionCopyWithImpl<$Res, ClassSession>;
  @useResult
  $Res call({
    String id,
    String courseId,
    String? branchId,
    String teacherId,
    String sessionType,
    DateTime startTime,
    DateTime endTime,
    int? capacity,
    int enrolledCount,
    String status,
    String? recordingUrl,
    String? meetingLink,
  });
}

/// @nodoc
class _$ClassSessionCopyWithImpl<$Res, $Val extends ClassSession>
    implements $ClassSessionCopyWith<$Res> {
  _$ClassSessionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ClassSession
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? courseId = null,
    Object? branchId = freezed,
    Object? teacherId = null,
    Object? sessionType = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? capacity = freezed,
    Object? enrolledCount = null,
    Object? status = null,
    Object? recordingUrl = freezed,
    Object? meetingLink = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            courseId: null == courseId
                ? _value.courseId
                : courseId // ignore: cast_nullable_to_non_nullable
                      as String,
            branchId: freezed == branchId
                ? _value.branchId
                : branchId // ignore: cast_nullable_to_non_nullable
                      as String?,
            teacherId: null == teacherId
                ? _value.teacherId
                : teacherId // ignore: cast_nullable_to_non_nullable
                      as String,
            sessionType: null == sessionType
                ? _value.sessionType
                : sessionType // ignore: cast_nullable_to_non_nullable
                      as String,
            startTime: null == startTime
                ? _value.startTime
                : startTime // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            endTime: null == endTime
                ? _value.endTime
                : endTime // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            capacity: freezed == capacity
                ? _value.capacity
                : capacity // ignore: cast_nullable_to_non_nullable
                      as int?,
            enrolledCount: null == enrolledCount
                ? _value.enrolledCount
                : enrolledCount // ignore: cast_nullable_to_non_nullable
                      as int,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            recordingUrl: freezed == recordingUrl
                ? _value.recordingUrl
                : recordingUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            meetingLink: freezed == meetingLink
                ? _value.meetingLink
                : meetingLink // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ClassSessionImplCopyWith<$Res>
    implements $ClassSessionCopyWith<$Res> {
  factory _$$ClassSessionImplCopyWith(
    _$ClassSessionImpl value,
    $Res Function(_$ClassSessionImpl) then,
  ) = __$$ClassSessionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String courseId,
    String? branchId,
    String teacherId,
    String sessionType,
    DateTime startTime,
    DateTime endTime,
    int? capacity,
    int enrolledCount,
    String status,
    String? recordingUrl,
    String? meetingLink,
  });
}

/// @nodoc
class __$$ClassSessionImplCopyWithImpl<$Res>
    extends _$ClassSessionCopyWithImpl<$Res, _$ClassSessionImpl>
    implements _$$ClassSessionImplCopyWith<$Res> {
  __$$ClassSessionImplCopyWithImpl(
    _$ClassSessionImpl _value,
    $Res Function(_$ClassSessionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ClassSession
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? courseId = null,
    Object? branchId = freezed,
    Object? teacherId = null,
    Object? sessionType = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? capacity = freezed,
    Object? enrolledCount = null,
    Object? status = null,
    Object? recordingUrl = freezed,
    Object? meetingLink = freezed,
  }) {
    return _then(
      _$ClassSessionImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        courseId: null == courseId
            ? _value.courseId
            : courseId // ignore: cast_nullable_to_non_nullable
                  as String,
        branchId: freezed == branchId
            ? _value.branchId
            : branchId // ignore: cast_nullable_to_non_nullable
                  as String?,
        teacherId: null == teacherId
            ? _value.teacherId
            : teacherId // ignore: cast_nullable_to_non_nullable
                  as String,
        sessionType: null == sessionType
            ? _value.sessionType
            : sessionType // ignore: cast_nullable_to_non_nullable
                  as String,
        startTime: null == startTime
            ? _value.startTime
            : startTime // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        endTime: null == endTime
            ? _value.endTime
            : endTime // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        capacity: freezed == capacity
            ? _value.capacity
            : capacity // ignore: cast_nullable_to_non_nullable
                  as int?,
        enrolledCount: null == enrolledCount
            ? _value.enrolledCount
            : enrolledCount // ignore: cast_nullable_to_non_nullable
                  as int,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        recordingUrl: freezed == recordingUrl
            ? _value.recordingUrl
            : recordingUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        meetingLink: freezed == meetingLink
            ? _value.meetingLink
            : meetingLink // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ClassSessionImpl implements _ClassSession {
  const _$ClassSessionImpl({
    required this.id,
    required this.courseId,
    this.branchId,
    required this.teacherId,
    this.sessionType = 'online',
    required this.startTime,
    required this.endTime,
    this.capacity,
    this.enrolledCount = 0,
    this.status = 'scheduled',
    this.recordingUrl,
    this.meetingLink,
  });

  factory _$ClassSessionImpl.fromJson(Map<String, dynamic> json) =>
      _$$ClassSessionImplFromJson(json);

  @override
  final String id;
  @override
  final String courseId;
  @override
  final String? branchId;
  @override
  final String teacherId;
  @override
  @JsonKey()
  final String sessionType;
  @override
  final DateTime startTime;
  @override
  final DateTime endTime;
  @override
  final int? capacity;
  @override
  @JsonKey()
  final int enrolledCount;
  @override
  @JsonKey()
  final String status;
  @override
  final String? recordingUrl;
  @override
  final String? meetingLink;

  @override
  String toString() {
    return 'ClassSession(id: $id, courseId: $courseId, branchId: $branchId, teacherId: $teacherId, sessionType: $sessionType, startTime: $startTime, endTime: $endTime, capacity: $capacity, enrolledCount: $enrolledCount, status: $status, recordingUrl: $recordingUrl, meetingLink: $meetingLink)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ClassSessionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.courseId, courseId) ||
                other.courseId == courseId) &&
            (identical(other.branchId, branchId) ||
                other.branchId == branchId) &&
            (identical(other.teacherId, teacherId) ||
                other.teacherId == teacherId) &&
            (identical(other.sessionType, sessionType) ||
                other.sessionType == sessionType) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.capacity, capacity) ||
                other.capacity == capacity) &&
            (identical(other.enrolledCount, enrolledCount) ||
                other.enrolledCount == enrolledCount) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.recordingUrl, recordingUrl) ||
                other.recordingUrl == recordingUrl) &&
            (identical(other.meetingLink, meetingLink) ||
                other.meetingLink == meetingLink));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    courseId,
    branchId,
    teacherId,
    sessionType,
    startTime,
    endTime,
    capacity,
    enrolledCount,
    status,
    recordingUrl,
    meetingLink,
  );

  /// Create a copy of ClassSession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ClassSessionImplCopyWith<_$ClassSessionImpl> get copyWith =>
      __$$ClassSessionImplCopyWithImpl<_$ClassSessionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ClassSessionImplToJson(this);
  }
}

abstract class _ClassSession implements ClassSession {
  const factory _ClassSession({
    required final String id,
    required final String courseId,
    final String? branchId,
    required final String teacherId,
    final String sessionType,
    required final DateTime startTime,
    required final DateTime endTime,
    final int? capacity,
    final int enrolledCount,
    final String status,
    final String? recordingUrl,
    final String? meetingLink,
  }) = _$ClassSessionImpl;

  factory _ClassSession.fromJson(Map<String, dynamic> json) =
      _$ClassSessionImpl.fromJson;

  @override
  String get id;
  @override
  String get courseId;
  @override
  String? get branchId;
  @override
  String get teacherId;
  @override
  String get sessionType;
  @override
  DateTime get startTime;
  @override
  DateTime get endTime;
  @override
  int? get capacity;
  @override
  int get enrolledCount;
  @override
  String get status;
  @override
  String? get recordingUrl;
  @override
  String? get meetingLink;

  /// Create a copy of ClassSession
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ClassSessionImplCopyWith<_$ClassSessionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Branch _$BranchFromJson(Map<String, dynamic> json) {
  return _Branch.fromJson(json);
}

/// @nodoc
mixin _$Branch {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get address => throw _privateConstructorUsedError;
  String get city => throw _privateConstructorUsedError;
  String get state => throw _privateConstructorUsedError;
  String? get zipCode => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  double? get latitude => throw _privateConstructorUsedError;
  double? get longitude => throw _privateConstructorUsedError;
  int? get capacity => throw _privateConstructorUsedError;

  /// Serializes this Branch to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Branch
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BranchCopyWith<Branch> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BranchCopyWith<$Res> {
  factory $BranchCopyWith(Branch value, $Res Function(Branch) then) =
      _$BranchCopyWithImpl<$Res, Branch>;
  @useResult
  $Res call({
    String id,
    String name,
    String address,
    String city,
    String state,
    String? zipCode,
    String? phone,
    double? latitude,
    double? longitude,
    int? capacity,
  });
}

/// @nodoc
class _$BranchCopyWithImpl<$Res, $Val extends Branch>
    implements $BranchCopyWith<$Res> {
  _$BranchCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Branch
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? address = null,
    Object? city = null,
    Object? state = null,
    Object? zipCode = freezed,
    Object? phone = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? capacity = freezed,
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
            address: null == address
                ? _value.address
                : address // ignore: cast_nullable_to_non_nullable
                      as String,
            city: null == city
                ? _value.city
                : city // ignore: cast_nullable_to_non_nullable
                      as String,
            state: null == state
                ? _value.state
                : state // ignore: cast_nullable_to_non_nullable
                      as String,
            zipCode: freezed == zipCode
                ? _value.zipCode
                : zipCode // ignore: cast_nullable_to_non_nullable
                      as String?,
            phone: freezed == phone
                ? _value.phone
                : phone // ignore: cast_nullable_to_non_nullable
                      as String?,
            latitude: freezed == latitude
                ? _value.latitude
                : latitude // ignore: cast_nullable_to_non_nullable
                      as double?,
            longitude: freezed == longitude
                ? _value.longitude
                : longitude // ignore: cast_nullable_to_non_nullable
                      as double?,
            capacity: freezed == capacity
                ? _value.capacity
                : capacity // ignore: cast_nullable_to_non_nullable
                      as int?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BranchImplCopyWith<$Res> implements $BranchCopyWith<$Res> {
  factory _$$BranchImplCopyWith(
    _$BranchImpl value,
    $Res Function(_$BranchImpl) then,
  ) = __$$BranchImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String address,
    String city,
    String state,
    String? zipCode,
    String? phone,
    double? latitude,
    double? longitude,
    int? capacity,
  });
}

/// @nodoc
class __$$BranchImplCopyWithImpl<$Res>
    extends _$BranchCopyWithImpl<$Res, _$BranchImpl>
    implements _$$BranchImplCopyWith<$Res> {
  __$$BranchImplCopyWithImpl(
    _$BranchImpl _value,
    $Res Function(_$BranchImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Branch
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? address = null,
    Object? city = null,
    Object? state = null,
    Object? zipCode = freezed,
    Object? phone = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? capacity = freezed,
  }) {
    return _then(
      _$BranchImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        address: null == address
            ? _value.address
            : address // ignore: cast_nullable_to_non_nullable
                  as String,
        city: null == city
            ? _value.city
            : city // ignore: cast_nullable_to_non_nullable
                  as String,
        state: null == state
            ? _value.state
            : state // ignore: cast_nullable_to_non_nullable
                  as String,
        zipCode: freezed == zipCode
            ? _value.zipCode
            : zipCode // ignore: cast_nullable_to_non_nullable
                  as String?,
        phone: freezed == phone
            ? _value.phone
            : phone // ignore: cast_nullable_to_non_nullable
                  as String?,
        latitude: freezed == latitude
            ? _value.latitude
            : latitude // ignore: cast_nullable_to_non_nullable
                  as double?,
        longitude: freezed == longitude
            ? _value.longitude
            : longitude // ignore: cast_nullable_to_non_nullable
                  as double?,
        capacity: freezed == capacity
            ? _value.capacity
            : capacity // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BranchImpl implements _Branch {
  const _$BranchImpl({
    required this.id,
    required this.name,
    required this.address,
    required this.city,
    required this.state,
    this.zipCode,
    this.phone,
    this.latitude,
    this.longitude,
    this.capacity,
  });

  factory _$BranchImpl.fromJson(Map<String, dynamic> json) =>
      _$$BranchImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String address;
  @override
  final String city;
  @override
  final String state;
  @override
  final String? zipCode;
  @override
  final String? phone;
  @override
  final double? latitude;
  @override
  final double? longitude;
  @override
  final int? capacity;

  @override
  String toString() {
    return 'Branch(id: $id, name: $name, address: $address, city: $city, state: $state, zipCode: $zipCode, phone: $phone, latitude: $latitude, longitude: $longitude, capacity: $capacity)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BranchImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.state, state) || other.state == state) &&
            (identical(other.zipCode, zipCode) || other.zipCode == zipCode) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.capacity, capacity) ||
                other.capacity == capacity));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    address,
    city,
    state,
    zipCode,
    phone,
    latitude,
    longitude,
    capacity,
  );

  /// Create a copy of Branch
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BranchImplCopyWith<_$BranchImpl> get copyWith =>
      __$$BranchImplCopyWithImpl<_$BranchImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BranchImplToJson(this);
  }
}

abstract class _Branch implements Branch {
  const factory _Branch({
    required final String id,
    required final String name,
    required final String address,
    required final String city,
    required final String state,
    final String? zipCode,
    final String? phone,
    final double? latitude,
    final double? longitude,
    final int? capacity,
  }) = _$BranchImpl;

  factory _Branch.fromJson(Map<String, dynamic> json) = _$BranchImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get address;
  @override
  String get city;
  @override
  String get state;
  @override
  String? get zipCode;
  @override
  String? get phone;
  @override
  double? get latitude;
  @override
  double? get longitude;
  @override
  int? get capacity;

  /// Create a copy of Branch
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BranchImplCopyWith<_$BranchImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
