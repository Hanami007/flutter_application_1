/// Enrollment entity — represents a user's purchase of a course.
class Enrollment {
  final String id;
  final String userId;
  final String courseId;
  final String paymentStatus; // pending | completed | refunded
  final DateTime enrolledAt;
  final DateTime? lastAccessedAt;
  final DateTime createdAt;

  const Enrollment({
    required this.id,
    required this.userId,
    required this.courseId,
    required this.paymentStatus,
    required this.enrolledAt,
    this.lastAccessedAt,
    required this.createdAt,
  });

  factory Enrollment.fromJson(Map<String, dynamic> json) {
    return Enrollment(
      id: json['id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      courseId: json['course_id']?.toString() ?? '',
      paymentStatus: json['payment_status']?.toString() ?? 'completed',
      enrolledAt: json['enrolled_at'] != null
          ? DateTime.parse(json['enrolled_at'].toString())
          : DateTime.now(),
      lastAccessedAt: json['last_accessed_at'] != null
          ? DateTime.parse(json['last_accessed_at'].toString())
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'].toString())
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'course_id': courseId,
        'payment_status': paymentStatus,
        'enrolled_at': enrolledAt.toIso8601String(),
        'last_accessed_at': lastAccessedAt?.toIso8601String(),
        'created_at': createdAt.toIso8601String(),
      };

  Enrollment copyWith({
    String? id,
    String? userId,
    String? courseId,
    String? paymentStatus,
    DateTime? enrolledAt,
    DateTime? lastAccessedAt,
    DateTime? createdAt,
  }) {
    return Enrollment(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      courseId: courseId ?? this.courseId,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      enrolledAt: enrolledAt ?? this.enrolledAt,
      lastAccessedAt: lastAccessedAt ?? this.lastAccessedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Enrollment &&
          other.id == id &&
          other.userId == userId &&
          other.courseId == courseId;

  @override
  int get hashCode => Object.hash(id, userId, courseId);

  @override
  String toString() =>
      'Enrollment(id: $id, userId: $userId, courseId: $courseId, '
      'paymentStatus: $paymentStatus)';
}

/// Certificate entity — issued when a course is 100% complete.
class Certificate {
  final String id;
  final String userId;
  final String courseId;
  final DateTime issuedAt;
  final String? certificateUrl;

  const Certificate({
    required this.id,
    required this.userId,
    required this.courseId,
    required this.issuedAt,
    this.certificateUrl,
  });

  factory Certificate.fromJson(Map<String, dynamic> json) {
    return Certificate(
      id: json['id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      courseId: json['course_id']?.toString() ?? '',
      issuedAt: json['issued_at'] != null
          ? DateTime.parse(json['issued_at'].toString())
          : DateTime.now(),
      certificateUrl: json['certificate_url']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'course_id': courseId,
        'issued_at': issuedAt.toIso8601String(),
        'certificate_url': certificateUrl,
      };
}

/// FavoriteCourse entity — a user's saved/favorited course.
class FavoriteCourse {
  final String id;
  final String userId;
  final String courseId;
  final DateTime createdAt;

  const FavoriteCourse({
    required this.id,
    required this.userId,
    required this.courseId,
    required this.createdAt,
  });

  factory FavoriteCourse.fromJson(Map<String, dynamic> json) {
    return FavoriteCourse(
      id: json['id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      courseId: json['course_id']?.toString() ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'].toString())
          : DateTime.now(),
    );
  }
}
