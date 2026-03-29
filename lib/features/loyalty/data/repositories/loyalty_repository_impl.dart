import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/loyalty_program.dart';
import '../../domain/repositories/i_loyalty_repository.dart';

/// Mock implementation — swap for FirebaseLoyaltyDataSource when ready.
class LoyaltyRepositoryImpl implements ILoyaltyRepository {
  @override
  Future<Either<Failure, LoyaltyProgram>> getLoyaltyProgram(
      String userId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return Right(
      LoyaltyProgram(
        userId: userId,
        currentCuts: 9,
        cutsToNextReward: 10,
        nextRewardDescription: 'Master Grooming gratuito',
        vipBenefits: [
          'Prioridade no agendamento',
          '15% de desconto em produtos de home care',
          'Acesso a horários exclusivos',
        ],
        memberQRCode: 'CB-$userId-VIP-2024',
        serviceHistory: [
          ServiceHistoryEntry(
            serviceName: 'Corte Degradê + Barba',
            barberName: 'Ricardo Silva',
            date: DateTime(2024, 10, 15),
          ),
          ServiceHistoryEntry(
            serviceName: 'Ajuste de Barba',
            barberName: 'Marcus V.',
            date: DateTime(2024, 9, 28),
          ),
          ServiceHistoryEntry(
            serviceName: 'Corte Clássico',
            barberName: 'Ricardo Silva',
            date: DateTime(2024, 9, 5),
          ),
          ServiceHistoryEntry(
            serviceName: 'Corte + Lavagem',
            barberName: 'Marcus V.',
            date: DateTime(2024, 8, 12),
          ),
        ],
      ),
    );
  }

  @override
  Future<Either<Failure, Unit>> redeemReward(String userId) async {
    await Future.delayed(const Duration(seconds: 1));
    return const Right(unit);
  }
}
