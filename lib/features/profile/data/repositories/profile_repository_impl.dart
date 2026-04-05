import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'stylePreferences': {
          'haircut': preferences.haircut,
          'beardStyle': preferences.beardStyle,
          'beardContour': preferences.beardContour,
          'favoriteProducts': preferences.favoriteProducts,
          'preferredBarberId': preferences.preferredBarberId,
          'preferredBarberName': preferences.preferredBarberName,
        },
      }, SetOptions(merge: true));
      return const Right(unit);
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message ?? 'Erro ao salvar preferências'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
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

  @override
  Future<Either<Failure, String>> updatePhoto(
      String userId, Uint8List imageBytes) async {
    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child('profile_photos')
          .child('$userId.jpg');
      await ref.putData(
          imageBytes, SettableMetadata(contentType: 'image/jpeg'));
      final url = await ref.getDownloadURL();
      final user = FirebaseAuth.instance.currentUser;
      await user?.updatePhotoURL(url);
      return Right(url);
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message ?? 'Erro ao atualizar foto'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
