import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/service.dart';

abstract class IServiceRepository {
  Future<Either<Failure, List<Service>>> getServices();
  Future<Either<Failure, Service>> getServiceById(String id);
}
