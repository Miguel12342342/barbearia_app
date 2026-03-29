import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/client_profile.dart';

abstract class IProfileRepository {
  Future<Either<Failure, ClientProfile>> getProfile(String userId);
  Future<Either<Failure, Unit>> updateStylePreferences(
    String userId,
    StylePreferences preferences,
  );
  Future<Either<Failure, Unit>> updatePersonalData(
    String userId, {
    required String name,
    required String email,
  });
}
