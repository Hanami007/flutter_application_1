// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Booking _$BookingFromJson(Map<String, dynamic> json) => _Booking(
  id: json['id'] as String,
  userId: json['userId'] as String,
  classSessionId: json['classSessionId'] as String,
  status: json['status'] as String? ?? 'confirmed',
  attendanceStatus: json['attendanceStatus'] as String?,
  bookingDate: json['bookingDate'] == null
      ? null
      : DateTime.parse(json['bookingDate'] as String),
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$BookingToJson(_Booking instance) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'classSessionId': instance.classSessionId,
  'status': instance.status,
  'attendanceStatus': instance.attendanceStatus,
  'bookingDate': instance.bookingDate?.toIso8601String(),
  'createdAt': instance.createdAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
};

_ClassSession _$ClassSessionFromJson(Map<String, dynamic> json) =>
    _ClassSession(
      id: json['id'] as String,
      courseId: json['courseId'] as String,
      branchId: json['branchId'] as String?,
      teacherId: json['teacherId'] as String,
      sessionType: json['sessionType'] as String? ?? 'online',
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      capacity: (json['capacity'] as num?)?.toInt(),
      enrolledCount: (json['enrolledCount'] as num?)?.toInt() ?? 0,
      status: json['status'] as String? ?? 'scheduled',
      recordingUrl: json['recordingUrl'] as String?,
      meetingLink: json['meetingLink'] as String?,
    );

Map<String, dynamic> _$ClassSessionToJson(_ClassSession instance) =>
    <String, dynamic>{
      'id': instance.id,
      'courseId': instance.courseId,
      'branchId': instance.branchId,
      'teacherId': instance.teacherId,
      'sessionType': instance.sessionType,
      'startTime': instance.startTime.toIso8601String(),
      'endTime': instance.endTime.toIso8601String(),
      'capacity': instance.capacity,
      'enrolledCount': instance.enrolledCount,
      'status': instance.status,
      'recordingUrl': instance.recordingUrl,
      'meetingLink': instance.meetingLink,
    };

_Branch _$BranchFromJson(Map<String, dynamic> json) => _Branch(
  id: json['id'] as String,
  name: json['name'] as String,
  address: json['address'] as String,
  city: json['city'] as String,
  state: json['state'] as String,
  zipCode: json['zipCode'] as String?,
  phone: json['phone'] as String?,
  latitude: (json['latitude'] as num?)?.toDouble(),
  longitude: (json['longitude'] as num?)?.toDouble(),
  capacity: (json['capacity'] as num?)?.toInt(),
);

Map<String, dynamic> _$BranchToJson(_Branch instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'address': instance.address,
  'city': instance.city,
  'state': instance.state,
  'zipCode': instance.zipCode,
  'phone': instance.phone,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'capacity': instance.capacity,
};
