import '../domain/entities/enrollment.dart';

/// Mock enrollment data for development / offline mode.
///
/// These enrollments correspond to the two courses that have
/// course_progress rows in supabase_seed.sql for the test student
/// (id: 9999ee9d-ff46-4cb4-972c-f68482bf4f17).
class MockEnrollmentData {
  static const String _mockUserId = '9999ee9d-ff46-4cb4-972c-f68482bf4f17';

  static final List<Enrollment> mockEnrollments = [
    Enrollment(
      id: 'enroll-flutter-001',
      userId: _mockUserId,
      courseId: '1121ee2e-fa46-4bb4-952c-f68482bf4f22',
      paymentStatus: 'completed',
      enrolledAt: DateTime.now().subtract(const Duration(days: 10)),
      lastAccessedAt: DateTime.now().subtract(const Duration(hours: 3)),
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
    ),
    Enrollment(
      id: 'enroll-uiux-002',
      userId: _mockUserId,
      courseId: '2232ff3f-ab57-4cc5-a63d-a79493cf5a33',
      paymentStatus: 'completed',
      enrolledAt: DateTime.now().subtract(const Duration(days: 5)),
      lastAccessedAt: DateTime.now().subtract(const Duration(days: 1)),
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
  ];

  /// Returns enrollment if found, else null.
  static Enrollment? findByUserAndCourse(String userId, String courseId) {
    try {
      return mockEnrollments.firstWhere(
        (e) => e.userId == userId && e.courseId == courseId,
      );
    } catch (_) {
      return null;
    }
  }

  /// Returns all enrollments for a user.
  static List<Enrollment> forUser(String userId) {
    return mockEnrollments.where((e) => e.userId == userId).toList();
  }
}
