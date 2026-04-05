import 'dart:typed_data';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/client_profile.dart';
import '../../domain/repositories/i_profile_repository.dart';
import '../../domain/usecases/get_client_profile.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetClientProfile _getClientProfile;
  final IProfileRepository _repository;

  ProfileCubit({
    required GetClientProfile getClientProfile,
    required IProfileRepository repository,
  })  : _getClientProfile = getClientProfile,
        _repository = repository,
        super(const ProfileState());

  Future<void> load(String userId) async {
    if (isClosed) return;
    emit(state.copyWith(status: ProfileStatus.loading));
    final result = await _getClientProfile(userId);
    if (isClosed) return;
    result.fold(
      (failure) => emit(state.copyWith(
        status: ProfileStatus.error,
        errorMessage: failure.message,
      )),
      (profile) => emit(state.copyWith(
        status: ProfileStatus.loaded,
        profile: profile,
      )),
    );
  }

  Future<bool> updateStylePreferences(
    String userId,
    StylePreferences preferences,
  ) async {
    if (isClosed) return false;
    emit(state.copyWith(status: ProfileStatus.saving));
    final result = await _repository.updateStylePreferences(userId, preferences);
    if (isClosed) return false;
    return result.fold(
      (failure) {
        emit(state.copyWith(
          status: ProfileStatus.error,
          errorMessage: failure.message,
        ));
        return false;
      },
      (_) {
        emit(state.copyWith(
          status: ProfileStatus.loaded,
          profile: state.profile?.copyWith(stylePreferences: preferences),
        ));
        return true;
      },
    );
  }

  Future<bool> updatePhoto(String userId, Uint8List imageBytes) async {
    if (isClosed) return false;
    emit(state.copyWith(status: ProfileStatus.saving));
    final result = await _repository.updatePhoto(userId, imageBytes);
    if (isClosed) return false;
    return result.fold(
      (failure) {
        emit(state.copyWith(
          status: ProfileStatus.error,
          errorMessage: failure.message,
        ));
        return false;
      },
      (url) {
        emit(state.copyWith(
          status: ProfileStatus.loaded,
          profile: state.profile?.copyWith(photoUrl: url),
        ));
        return true;
      },
    );
  }

  Future<bool> updatePersonalData(
    String userId, {
    required String name,
    required String email,
  }) async {
    if (isClosed) return false;
    emit(state.copyWith(status: ProfileStatus.saving));
    final result = await _repository.updatePersonalData(
      userId,
      name: name,
      email: email,
    );
    if (isClosed) return false;
    return result.fold(
      (failure) {
        emit(state.copyWith(
          status: ProfileStatus.error,
          errorMessage: failure.message,
        ));
        return false;
      },
      (_) {
        emit(state.copyWith(
          status: ProfileStatus.loaded,
          profile: state.profile?.copyWith(name: name, email: email),
        ));
        return true;
      },
    );
  }
}
