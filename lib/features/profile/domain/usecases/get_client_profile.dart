import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/client_profile.dart';
import '../repositories/i_profile_repository.dart';

class GetClientProfile implements UseCase<ClientProfile, String> {
  final IProfileRepository repository;

  GetClientProfile(this.repository);

  @override
  Future<Either<Failure, ClientProfile>> call(String userId) {
    if (userId.isEmpty) {
      return Future.value(const Left(ValidationFailure('UserId cannot be empty')));
    }
    return repository.getProfile(userId);
  }
}
