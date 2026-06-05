import '../entities/enrollment.dart';

/// Use case: Check if a user has purchased a specific course.
///
/// Returns [Enrollment] if found, or null if the user has not purchased the course.
class CheckEnrollmentUseCase {
  final CheckEnrollmentRepository _repository;

  CheckEnrollmentUseCase(this._repository);

  Future<Enrollment?> call({
    required String userId,
    required String courseId,
  }) async {
    if (userId.isEmpty || courseId.isEmpty) return null;
    return _repository.checkEnrollment(userId, courseId);
  }
}

/// Minimal interface that the use case depends on.
abstract class CheckEnrollmentRepository {
  Future<Enrollment?> checkEnrollment(String userId, String courseId);
}
