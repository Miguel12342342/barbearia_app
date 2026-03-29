import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/loyalty_program.dart';
import '../repositories/i_loyalty_repository.dart';

class GetLoyaltyProgram implements UseCase<LoyaltyProgram, String> {
  final ILoyaltyRepository repository;

  GetLoyaltyProgram(this.repository);

  @override
  Future<Either<Failure, LoyaltyProgram>> call(String userId) {
    if (userId.isEmpty) {
      return Future.value(const Left(ValidationFailure('UserId cannot be empty')));
    }
    return repository.getLoyaltyProgram(userId);
  }
}
