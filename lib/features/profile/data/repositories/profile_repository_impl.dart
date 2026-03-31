import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/client_profile.dart';
import '../../domain/repositories/i_profile_repository.dart';

class ProfileRepositoryImpl implements IProfileRepository {
  @override
  Future<Either<Failure, ClientProfile>> getProfile(String userId) async {
    final user = FirebaseAuth.instance.currentUser;

    // Use Firebase Auth as source of truth for personal data.
    // Style preferences start empty — user fills them in the app.
    return Right(
      ClientProfile(
        id: userId,
        name: user?.displayName ?? user?.email?.split('@').first ?? 'Usuário',
        email: user?.email ?? '',
        photoUrl: user?.photoURL,
        memberSince: user?.metadata.creationTime ?? DateTime.now(),
        tier: MemberTier.standard,
        stylePreferences: const StylePreferences(
          haircut: '',
          beardStyle: '',
          beardContour: '',
          favoriteProducts: [],
          preferredBarberId: '',
          preferredBarberName: '',
        ),
      ),
    );
  }

  @override
  Future<Either<Failure, Unit>> updateStylePreferences(
    String userId,
    StylePreferences preferences,
  ) async {
    // TODO: persist to Firestore
    await Future.delayed(const Duration(milliseconds: 400));
    return const Right(unit);
  }

  @override
  Future<Either<Failure, Unit>> updatePersonalData(
    String userId, {
    required String name,
    required String email,
  }) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.updateDisplayName(name);
        // Email update requires re-authentication — skip for now
      }
      return const Right(unit);
    } catch (_) {
      return const Right(unit);
    }
  }
}
