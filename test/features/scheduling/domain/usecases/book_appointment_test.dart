import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import 'package:barbearia_appzin/core/error/failures.dart';
import 'package:barbearia_appzin/features/scheduling/domain/entities/appointment.dart';
import 'package:barbearia_appzin/features/scheduling/domain/repositories/i_appointment_repository.dart';
import 'package:barbearia_appzin/features/scheduling/domain/usecases/book_appointment.dart';
import 'package:barbearia_appzin/features/scheduling/domain/value_objects/appointment_date.dart';
import 'package:barbearia_appzin/features/scheduling/domain/value_objects/appointment_status.dart';
import 'package:barbearia_appzin/features/scheduling/domain/value_objects/phone_number.dart';

class MockAppointmentRepository extends Mock implements IAppointmentRepository {}

void main() {
  late BookAppointment usecase;
  late MockAppointmentRepository mockRepository;

  setUp(() {
    mockRepository = MockAppointmentRepository();
    usecase = BookAppointment(mockRepository);
    
    // Register fallback value for mocktail
    registerFallbackValue(
      Appointment(
        id: 'test_id',
        userId: 'user_123',
        serviceId: 's1',
        date: AppointmentDate(DateTime.now().add(const Duration(days: 1))),
        clientPhone: PhoneNumber('11999999999'),
        status: AppointmentStatus.pending,
      ),
    );
  });

  group('BookAppointment UseCase BDD', () {
    final tAppointment = Appointment(
      id: 'test_id',
      userId: 'user_123',
      serviceId: 's1',
      date: AppointmentDate(DateTime.now().add(const Duration(days: 1))),
      clientPhone: PhoneNumber('11999999999'),
      status: AppointmentStatus.pending,
    );

    test(
      'Given a valid Appointment, '
      'When bookAppointment is called, '
      'Then it should return Right(unit) from repository',
      () async {
        // Arrange
        when(() => mockRepository.bookAppointment(any()))
            .thenAnswer((_) async => const Right(unit));

        // Act
        final result = await usecase(tAppointment);

        // Assert
        expect(result, const Right(unit));
        verify(() => mockRepository.bookAppointment(tAppointment)).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test(
      'Given the Firebase service is down, '
      'When bookAppointment is called, '
      'Then it should return Left(ServerFailure)',
      () async {
        // Arrange
        when(() => mockRepository.bookAppointment(any()))
            .thenAnswer((_) async => const Left(ServerFailure('Connection Timeout')));

        // Act
        final result = await usecase(tAppointment);

        // Assert
        expect(result, const Left(ServerFailure('Connection Timeout')));
        verify(() => mockRepository.bookAppointment(tAppointment)).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );
  });
}
