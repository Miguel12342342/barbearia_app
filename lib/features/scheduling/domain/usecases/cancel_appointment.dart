import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../repositories/i_appointment_repository.dart';

class CancelAppointment {
  final IAppointmentRepository repository;

  CancelAppointment(this.repository);

  Future<Either<Failure, Unit>> call(String appointmentId) {
    if (appointmentId.trim().isEmpty) {
      return Future.value(
        const Left(ValidationFailure('appointmentId não pode ser vazio')),
      );
    }
    return repository.cancelAppointment(appointmentId);
  }
}
