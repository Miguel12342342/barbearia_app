import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/i_availability_repository.dart';

class AvailabilityRepositoryImpl implements IAvailabilityRepository {
  final FirebaseFirestore _firestore;

  AvailabilityRepositoryImpl(this._firestore);

  @override
  Future<Either<Failure, List<String>>> getAvailableSlots({
    required String barberId,
    required DateTime date,
    required int durationMinutes,
  }) async {
    try {
      final snapshot = await _firestore
          .collection('appointments')
          .where('barberId', isEqualTo: barberId)
          .get();

      final bookedTimes = <String>{};
      for (final doc in snapshot.docs) {
        final data = doc.data();
        if (data['status'] == 'canceled') continue;
        final ts = data['date'];
        if (ts is! Timestamp) continue;
        final aptDate = ts.toDate();
        if (aptDate.year == date.year &&
            aptDate.month == date.month &&
            aptDate.day == date.day) {
          final h = aptDate.hour.toString().padLeft(2, '0');
          final m = aptDate.minute.toString().padLeft(2, '0');
          bookedTimes.add('$h:$m');
        }
      }

      final slots = <String>[];
      var current = DateTime(2000, 1, 1, 9, 0);
      final workEnd = DateTime(2000, 1, 1, 18, 30);

      while (true) {
        final slotEnd = current.add(Duration(minutes: durationMinutes));
        if (slotEnd.isAfter(workEnd)) break;
        final h = current.hour.toString().padLeft(2, '0');
        final m = current.minute.toString().padLeft(2, '0');
        final label = '$h:$m';
        if (!bookedTimes.contains(label)) {
          slots.add(label);
        }
        current = current.add(const Duration(minutes: 30));
      }

      return Right(slots);
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message ?? 'Firebase error'));
    }
  }
}
