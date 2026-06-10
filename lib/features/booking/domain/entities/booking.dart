import 'package:freezed_annotation/freezed_annotation.dart';

part 'booking.freezed.dart';
part 'booking.g.dart';

@freezed
abstract class Booking with _$Booking {
  const factory Booking({
    required String id,
    required String userId,
    required String classSessionId,
    @Default('confirmed') String status,
    String? attendanceStatus,
    DateTime? bookingDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Booking;

  factory Booking.fromJson(Map<String, dynamic> json) => _$BookingFromJson(json);
}

@freezed
abstract class ClassSession with _$ClassSession {
  const factory ClassSession({
    required String id,
    required String courseId,
    String? branchId,
    required String teacherId,
    @Default('online') String sessionType,
    required DateTime startTime,
    required DateTime endTime,
    int? capacity,
    @Default(0) int enrolledCount,
    @Default('scheduled') String status,
    String? recordingUrl,
    String? meetingLink,
  }) = _ClassSession;

  factory ClassSession.fromJson(Map<String, dynamic> json) => 
      _$ClassSessionFromJson(json);
}

@freezed
abstract class Branch with _$Branch {
  const factory Branch({
    required String id,
    required String name,
    required String address,
    required String city,
    required String state,
    String? zipCode,
    String? phone,
    double? latitude,
    double? longitude,
    int? capacity,
  }) = _Branch;

  factory Branch.fromJson(Map<String, dynamic> json) => _$BranchFromJson(json);
}
