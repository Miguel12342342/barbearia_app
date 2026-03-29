import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/client_profile.dart';
import '../../domain/repositories/i_profile_repository.dart';

/// Mock implementation — swap for FirebaseProfileDataSource when ready.
class ProfileRepositoryImpl implements IProfileRepository {
  @override
  Future<Either<Failure, ClientProfile>> getProfile(String userId) async {
    await Future.delayed(const Duration(milliseconds: 350));
    return Right(
      ClientProfile(
        id: userId,
        name: 'Ricardo Oliveira',
        email: 'ricardo@email.com',
        photoUrl: null, // null = sem foto; Firebase Auth preencherá isso
        memberSince: DateTime(2022, 10, 1),
        tier: MemberTier.premium,
        stylePreferences: StylePreferences(
          haircut: 'Mid Fade Textured Top',
          lastServiceDate: DateTime.now().subtract(const Duration(days: 12)),
          beardStyle: 'Short Boxed Beard',
          beardContour: 'Navalha premium',
          favoriteProducts: ['Pomada Matte', 'Óleo de Sândalo'],
          preferredBarberId: 'b3',
          preferredBarberName: 'Mestre André',
        ),
      ),
    );
  }

  @override
  Future<Either<Failure, Unit>> updateStylePreferences(
    String userId,
    StylePreferences preferences,
  ) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return const Right(unit);
  }

  @override
  Future<Either<Failure, Unit>> updatePersonalData(
    String userId, {
    required String name,
    required String email,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return const Right(unit);
  }
}
