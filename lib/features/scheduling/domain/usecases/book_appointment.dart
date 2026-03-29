import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/appointment.dart';
import '../repositories/i_appointment_repository.dart';

class BookAppointment implements UseCase<Unit, Appointment> {
  final IAppointmentRepository repository;

  BookAppointment(this.repository);

  @override
  Future<Either<Failure, Unit>> call(Appointment appointment) {
    return repository.bookAppointment(appointment);
  }
}
