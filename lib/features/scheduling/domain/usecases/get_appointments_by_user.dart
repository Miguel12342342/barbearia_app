import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/appointment.dart';
import '../repositories/i_appointment_repository.dart';

/// Stream-based usecase — does not extend [UseCase] because
/// the base contract is Future-based. Stream usecases follow
/// the same pattern as [WatchAppointments].
class GetAppointmentsByUser {
  final IAppointmentRepository repository;

  GetAppointmentsByUser(this.repository);

  /// Returns a stream of appointments for [userId].
  /// Emits [Left<ValidationFailure>] if [userId] is empty.
  Stream<Either<Failure, List<Appointment>>> call(String userId) {
    if (userId.trim().isEmpty) {
      return Stream.value(
        const Left(ValidationFailure('UserId não pode ser vazio')),
      );
    }
    return repository.watchAppointments(userId);
  }
}
