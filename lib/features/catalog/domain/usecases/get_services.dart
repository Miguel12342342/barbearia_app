import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/service.dart';
import '../repositories/i_service_repository.dart';

class GetServices implements UseCase<List<Service>, NoParams> {
  final IServiceRepository repository;

  GetServices(this.repository);

  @override
  Future<Either<Failure, List<Service>>> call(NoParams params) {
    return repository.getServices();
  }
}
