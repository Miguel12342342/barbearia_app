import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/loyalty_program.dart';
import '../../domain/repositories/i_loyalty_repository.dart';

class LoyaltyRepositoryImpl implements ILoyaltyRepository {
  final FirebaseFirestore _firestore;

  LoyaltyRepositoryImpl(this._firestore);

  @override
  Future<Either<Failure, LoyaltyProgram>> getLoyaltyProgram(
      String userId) async {
    try {
      final snap = await _firestore
          .collection('appointments')
          .where('userId', isEqualTo: userId)
          .get();

      final activeDocs =
          snap.docs.where((d) => d['status'] != 'canceled').toList();

      final currentCuts = activeDocs.length;

      final history = activeDocs
          .map((d) {
            final data = d.data();
            final ts = data['date'] as Timestamp?;
            return ServiceHistoryEntry(
              serviceName: data['serviceName'] as String? ?? '',
              barberName: data['barberName'] as String? ?? '',
              date: ts?.toDate() ?? DateTime.now(),
            );
          })
          .toList()
        ..sort((a, b) => b.date.compareTo(a.date));

      return Right(
        LoyaltyProgram(
          userId: userId,
          currentCuts: currentCuts,
          cutsToNextReward: 10,
          nextRewardDescription: 'Master Grooming gratuito',
          vipBenefits: const [
            'Prioridade no agendamento',
            '15% de desconto em produtos de home care',
            'Acesso a horários exclusivos',
          ],
          memberQRCode: 'CB-$userId',
          serviceHistory: history,
        ),
      );
    } on FirebaseException catch (e) {
      return Left(
          ServerFailure(e.message ?? 'Erro ao carregar programa de fidelidade'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> redeemReward(String userId) async {
    await Future.delayed(const Duration(seconds: 1));
    return const Right(unit);
  }
}
