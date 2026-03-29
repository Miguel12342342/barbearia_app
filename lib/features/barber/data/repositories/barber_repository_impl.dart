import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/barber.dart';
import '../../domain/repositories/i_barber_repository.dart';

/// Mock implementation — swap for FirebaseBarberDataSource when ready.
class BarberRepositoryImpl implements IBarberRepository {
  static const _barbers = [
    Barber(
      id: 'b1',
      name: 'Arthur Santos',
      specialty: BarberSpecialty.mestreBarber,
      photoUrl:
          'https://images.unsplash.com/photo-1621592484082-2d05b1290d7a?q=80&w=300&auto=format&fit=crop',
    ),
    Barber(
      id: 'b2',
      name: 'Lucas Rocha',
      specialty: BarberSpecialty.visagista,
      photoUrl:
          'https://images.unsplash.com/photo-1599566150163-29194dcaad36?q=80&w=300&auto=format&fit=crop',
    ),
    Barber(
      id: 'b3',
      name: 'Ricardo Silva',
      specialty: BarberSpecialty.mestreBarber,
      photoUrl:
          'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?q=80&w=300&auto=format&fit=crop',
    ),
    Barber(
      id: 'b4',
      name: 'Marcus V.',
      specialty: BarberSpecialty.colorista,
      photoUrl:
          'https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?q=80&w=300&auto=format&fit=crop',
    ),
  ];

  @override
  Future<Either<Failure, List<Barber>>> getBarbers() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return const Right(_barbers);
  }

  @override
  Future<Either<Failure, Barber>> getBarberById(String id) async {
    await Future.delayed(const Duration(milliseconds: 150));
    try {
      final barber = _barbers.firstWhere((b) => b.id == id);
      return Right(barber);
    } catch (_) {
      return const Left(ServerFailure('Barbeiro não encontrado'));
    }
  }
}
