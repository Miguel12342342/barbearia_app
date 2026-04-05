import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/i_appointment_repository.dart';

class RateParams extends Equatable {
  final String appointmentId;
  final int score;
  const RateParams({required this.appointmentId, required this.score});

  @override
  List<Object?> get props => [appointmentId, score];
}

class RateAppointment implements UseCase<Unit, RateParams> {
  final IAppointmentRepository repository;
  RateAppointment(this.repository);

  @override
  Future<Either<Failure, Unit>> call(RateParams params) =>
      repository.rateAppointment(params.appointmentId, params.score);
}
