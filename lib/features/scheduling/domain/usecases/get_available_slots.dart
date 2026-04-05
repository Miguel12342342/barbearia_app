import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/i_availability_repository.dart';

class GetAvailableSlotsParams extends Equatable {
  final String barberId;
  final DateTime date;
  final int durationMinutes;

  const GetAvailableSlotsParams({
    required this.barberId,
    required this.date,
    required this.durationMinutes,
  });

  @override
  List<Object?> get props => [barberId, date, durationMinutes];
}

class GetAvailableSlots
    implements UseCase<List<String>, GetAvailableSlotsParams> {
  final IAvailabilityRepository _repository;
  GetAvailableSlots(this._repository);

  @override
  Future<Either<Failure, List<String>>> call(
          GetAvailableSlotsParams params) =>
      _repository.getAvailableSlots(
        barberId: params.barberId,
        date: params.date,
        durationMinutes: params.durationMinutes,
      );
}
