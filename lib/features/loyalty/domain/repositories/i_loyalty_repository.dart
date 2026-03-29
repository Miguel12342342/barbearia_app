import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/loyalty_program.dart';

abstract class ILoyaltyRepository {
  Future<Either<Failure, LoyaltyProgram>> getLoyaltyProgram(String userId);
  Future<Either<Failure, Unit>> redeemReward(String userId);
}
