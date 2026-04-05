import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import 'package:barbearia_appzin/core/error/failures.dart';
import 'package:barbearia_appzin/features/scheduling/domain/entities/appointment.dart';
import 'package:barbearia_appzin/core/services/notification_service.dart';
import 'package:barbearia_appzin/features/scheduling/domain/usecases/book_appointment.dart';
import 'package:barbearia_appzin/features/scheduling/domain/usecases/cancel_appointment.dart';
import 'package:barbearia_appzin/features/scheduling/domain/usecases/rate_appointment.dart';
import 'package:barbearia_appzin/features/scheduling/domain/usecases/reschedule_appointment.dart';
import 'package:barbearia_appzin/features/scheduling/domain/usecases/watch_appointments.dart';
import 'package:barbearia_appzin/features/scheduling/domain/value_objects/appointment_date.dart';
import 'package:barbearia_appzin/features/scheduling/domain/value_objects/appointment_status.dart';
import 'package:barbearia_appzin/features/scheduling/domain/value_objects/phone_number.dart';
import 'package:barbearia_appzin/features/scheduling/presentation/bloc/booking_bloc.dart';
import 'package:barbearia_appzin/features/scheduling/presentation/bloc/booking_event.dart';
import 'package:barbearia_appzin/features/scheduling/presentation/bloc/booking_state.dart';

class MockBookAppointment extends Mock implements BookAppointment {}
class MockCancelAppointment extends Mock implements CancelAppointment {}
class MockWatchAppointments extends Mock implements WatchAppointments {}
class MockNotificationService extends Mock implements NotificationService {}
class MockRescheduleAppointment extends Mock implements RescheduleAppointment {}
class MockRateAppointment extends Mock implements RateAppointment {}

class FakeAppointment extends Fake implements Appointment {}

void main() {
  late BookingBloc bloc;
  late MockBookAppointment mockBookAppointment;
  late MockCancelAppointment mockCancelAppointment;
  late MockWatchAppointments mockWatchAppointments;
  late MockNotificationService mockNotificationService;

  setUpAll(() {
    registerFallbackValue(FakeAppointment());
  });

  setUp(() {
    mockBookAppointment = MockBookAppointment();
    mockCancelAppointment = MockCancelAppointment();
    mockWatchAppointments = MockWatchAppointments();
    mockNotificationService = MockNotificationService();
    when(() => mockNotificationService.scheduleAppointmentReminder(any()))
        .thenAnswer((_) async {});
    when(() => mockNotificationService.cancelReminder(any()))
        .thenAnswer((_) async {});
    bloc = BookingBloc(
      bookAppointment: mockBookAppointment,
      cancelAppointment: mockCancelAppointment,
      watchAppointments: mockWatchAppointments,
      notificationService: mockNotificationService,
      rescheduleAppointment: MockRescheduleAppointment(),
      rateAppointment: MockRateAppointment(),
    );
  });

  group('BookingBloc BDD', () {
    final tAppointment = Appointment(
      id: 'test_id',
      userId: 'user_123',
      serviceId: 's1',
      date: AppointmentDate(DateTime.now().add(const Duration(days: 1))),
      clientPhone: PhoneNumber('11999999999'),
      status: AppointmentStatus.pending,
    );

    blocTest<BookingBloc, BookingState>(
      'Given a valid appointment, '
      'When BookAppointmentEvent is added, '
      'Then it should emit [Loading, Success]',
      build: () {
        when(() => mockBookAppointment(any()))
            .thenAnswer((_) async => const Right(unit));
        return bloc;
      },
      act: (bloc) => bloc.add(BookAppointmentEvent(tAppointment)),
      expect: () => [
        const BookingState(status: BookingStatus.loading),
        BookingState(
            status: BookingStatus.success,
            lastBookedAppointment: tAppointment),
      ],
      verify: (_) {
        verify(() => mockBookAppointment(tAppointment)).called(1);
      },
    );

    blocTest<BookingBloc, BookingState>(
      'Given the user token is expired (Unauthorized), '
      'When BookAppointmentEvent is added, '
      'Then it should emit [Loading, Failure]',
      build: () {
        when(() => mockBookAppointment(any()))
            .thenAnswer((_) async => const Left(ServerFailure('Unauthorized: Please login again')));
        return bloc;
      },
      act: (bloc) => bloc.add(BookAppointmentEvent(tAppointment)),
      expect: () => [
        const BookingState(status: BookingStatus.loading),
        const BookingState(status: BookingStatus.failure, errorMessage: 'Unauthorized: Please login again'),
      ],
    );
  });
}
