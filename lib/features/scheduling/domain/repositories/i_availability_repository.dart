import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';

abstract class IAvailabilityRepository {
  Future<Either<Failure, List<String>>> getAvailableSlots({
    required String barberId,
    required DateTime date,
    required int durationMinutes,
  });
}
