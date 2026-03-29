import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/barber.dart';
import '../repositories/i_barber_repository.dart';

class GetBarbers implements UseCase<List<Barber>, NoParams> {
  final IBarberRepository repository;

  GetBarbers(this.repository);

  @override
  Future<Either<Failure, List<Barber>>> call(NoParams params) {
    return repository.getBarbers();
  }
}
