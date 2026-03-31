import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/i_loyalty_repository.dart';
import '../../domain/usecases/get_loyalty_program.dart';
import 'loyalty_state.dart';

class LoyaltyCubit extends Cubit<LoyaltyState> {
  final GetLoyaltyProgram _getLoyaltyProgram;
  final ILoyaltyRepository _repository;

  LoyaltyCubit({
    required GetLoyaltyProgram getLoyaltyProgram,
    required ILoyaltyRepository repository,
  })  : _getLoyaltyProgram = getLoyaltyProgram,
        _repository = repository,
        super(const LoyaltyState());

  Future<void> load(String userId) async {
    if (isClosed) return;
    emit(state.copyWith(status: LoyaltyStatus.loading));
    final result = await _getLoyaltyProgram(userId);
    if (isClosed) return;
    result.fold(
      (failure) => emit(state.copyWith(
        status: LoyaltyStatus.error,
        errorMessage: failure.message,
      )),
      (program) => emit(state.copyWith(
        status: LoyaltyStatus.loaded,
        program: program,
      )),
    );
  }

  Future<void> redeemReward(String userId) async {
    if (isClosed) return;
    emit(state.copyWith(status: LoyaltyStatus.redeeming));
    final result = await _repository.redeemReward(userId);
    if (isClosed) return;
    result.fold(
      (failure) => emit(state.copyWith(
        status: LoyaltyStatus.error,
        errorMessage: failure.message,
      )),
      (_) => load(userId),
    );
  }
}
