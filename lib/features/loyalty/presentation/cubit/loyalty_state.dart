import 'package:equatable/equatable.dart';
import '../../domain/entities/loyalty_program.dart';

enum LoyaltyStatus { initial, loading, loaded, redeeming, error }

class LoyaltyState extends Equatable {
  final LoyaltyStatus status;
  final LoyaltyProgram? program;
  final String errorMessage;

  const LoyaltyState({
    this.status = LoyaltyStatus.initial,
    this.program,
    this.errorMessage = '',
  });

  LoyaltyState copyWith({
    LoyaltyStatus? status,
    LoyaltyProgram? program,
    String? errorMessage,
  }) {
    return LoyaltyState(
      status: status ?? this.status,
      program: program ?? this.program,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, program, errorMessage];
}
