import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/barber.dart';

abstract class IBarberRepository {
  Future<Either<Failure, List<Barber>>> getBarbers();
  Future<Either<Failure, Barber>> getBarberById(String id);
}
