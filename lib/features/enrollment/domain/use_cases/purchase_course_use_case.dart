import '../entities/enrollment.dart';

/// Use case: Purchase a course by creating an enrollment record.
///
/// In production, this is called after a successful payment.
/// Returns the newly created [Enrollment].
class PurchaseCourseUseCase {
  final PurchaseCourseRepository _repository;

  PurchaseCourseUseCase(this._repository);

  Future<Enrollment> call({
    required String userId,
    required String courseId,
  }) async {
    if (userId.isEmpty) throw ArgumentError('userId cannot be empty');
    if (courseId.isEmpty) throw ArgumentError('courseId cannot be empty');

    return _repository.createEnrollment(userId, courseId);
  }
}

/// Minimal interface that the use case depends on.
abstract class PurchaseCourseRepository {
  Future<Enrollment> createEnrollment(String userId, String courseId);
}
