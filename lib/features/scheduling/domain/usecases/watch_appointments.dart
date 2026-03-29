import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/appointment.dart';
import '../repositories/i_appointment_repository.dart';

class WatchAppointments {
  final IAppointmentRepository repository;

  WatchAppointments(this.repository);

  Stream<Either<Failure, List<Appointment>>> call(String userId) {
    return repository.watchAppointments(userId);
  }
}
