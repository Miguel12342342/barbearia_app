import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/appointment.dart';

abstract class IAppointmentRepository {
  Stream<Either<Failure, List<Appointment>>> watchAppointments(String userId);
  Future<Either<Failure, Unit>> bookAppointment(Appointment appointment);
  Future<Either<Failure, Unit>> cancelAppointment(String appointmentId);
  Future<Either<Failure, Unit>> rescheduleAppointment(
      String appointmentId, DateTime newDate);
  Future<Either<Failure, Unit>> rateAppointment(String appointmentId, int score);
}
