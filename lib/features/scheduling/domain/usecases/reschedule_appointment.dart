import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/i_appointment_repository.dart';

class RescheduleParams extends Equatable {
  final String appointmentId;
  final DateTime newDate;
  const RescheduleParams({required this.appointmentId, required this.newDate});

  @override
  List<Object?> get props => [appointmentId, newDate];
}

class RescheduleAppointment implements UseCase<Unit, RescheduleParams> {
  final IAppointmentRepository repository;
  RescheduleAppointment(this.repository);

  @override
  Future<Either<Failure, Unit>> call(RescheduleParams params) =>
      repository.rescheduleAppointment(params.appointmentId, params.newDate);
}
