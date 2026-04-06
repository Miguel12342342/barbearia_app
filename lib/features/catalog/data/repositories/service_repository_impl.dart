import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/service.dart';
import '../../domain/repositories/i_service_repository.dart';

/// Mock implementation — swap for FirebaseServiceDataSource when ready.
class ServiceRepositoryImpl implements IServiceRepository {
  static const _services = [
    Service(
      id: 's1',
      name: 'Corte',
      description: 'Degradês e tesoura clássica.',
      localizedNames: {'en': 'Haircut', 'es': 'Corte de cabello'},
      localizedDescriptions: {
        'en': 'Fade and classic scissors cut.',
        'es': 'Degradado y corte con tijera clásica.',
      },
      priceAmount: 85.0,
      durationMinutes: 30,
      iconType: ServiceIconType.scissors,
    ),
    Service(
      id: 's2',
      name: 'Barba',
      description: 'Toalha quente e navalha.',
      localizedNames: {'en': 'Beard', 'es': 'Barba'},
      localizedDescriptions: {
        'en': 'Hot towel and straight razor.',
        'es': 'Toalla caliente y navaja.',
      },
      priceAmount: 65.0,
      durationMinutes: 30,
      iconType: ServiceIconType.beard,
    ),
    Service(
      id: 's3',
      name: 'Combo',
      description: 'Experiência completa.',
      localizedNames: {'en': 'Combo', 'es': 'Combo'},
      localizedDescriptions: {
        'en': 'Full experience.',
        'es': 'Experiencia completa.',
      },
      priceAmount: 130.0,
      durationMinutes: 60,
      iconType: ServiceIconType.combo,
      isPremium: true,
    ),
    Service(
      id: 's4',
      name: 'The Royal Ritual',
      description: 'Experiência completa incluindo vapor facial e massagem.',
      localizedNames: {'en': 'The Royal Ritual', 'es': 'El Ritual Real'},
      localizedDescriptions: {
        'en': 'Full experience with facial steam and massage.',
        'es': 'Experiencia completa con vapor facial y masaje.',
      },
      priceAmount: 85.0,
      durationMinutes: 75,
      iconType: ServiceIconType.ritual,
      isPremium: true,
    ),
  ];

  @override
  Future<Either<Failure, List<Service>>> getServices() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return const Right(_services);
  }

  @override
  Future<Either<Failure, Service>> getServiceById(String id) async {
    await Future.delayed(const Duration(milliseconds: 150));
    try {
      final service = _services.firstWhere((s) => s.id == id);
      return Right(service);
    } catch (_) {
      return const Left(ServerFailure('Serviço não encontrado'));
    }
  }
}
