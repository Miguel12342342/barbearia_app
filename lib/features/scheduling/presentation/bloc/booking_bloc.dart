import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';

import '../../domain/usecases/book_appointment.dart';
import '../../domain/usecases/cancel_appointment.dart';
import '../../domain/usecases/watch_appointments.dart';
import 'booking_event.dart';
import 'booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final BookAppointment _bookAppointment;
  final CancelAppointment _cancelAppointment;
  final WatchAppointments _watchAppointments;

  BookingBloc({
    required BookAppointment bookAppointment,
    required CancelAppointment cancelAppointment,
    required WatchAppointments watchAppointments,
  })  : _bookAppointment = bookAppointment,
        _cancelAppointment = cancelAppointment,
        _watchAppointments = watchAppointments,
        super(const BookingState()) {
    on<LoadAppointmentsEvent>(
      _onLoadAppointments,
      transformer: restartable(),
    );
    on<BookAppointmentEvent>(
      _onBookAppointment,
      transformer: droppable(),
    );
    on<CancelAppointmentEvent>(
      _onCancelAppointment,
      transformer: droppable(),
    );
  }

  Future<void> _onLoadAppointments(
    LoadAppointmentsEvent event,
    Emitter<BookingState> emit,
  ) async {
    emit(state.copyWith(status: BookingStatus.loading));

    await emit.forEach(
      _watchAppointments(event.userId),
      onData: (eitherResult) => eitherResult.fold(
        (failure) => state.copyWith(
          status: BookingStatus.failure,
          errorMessage: failure.message,
        ),
        (appointments) => state.copyWith(
          status: BookingStatus.success,
          appointments: appointments,
        ),
      ),
      onError: (error, _) => state.copyWith(
        status: BookingStatus.failure,
        errorMessage: error.toString(),
      ),
    );
  }

  Future<void> _onBookAppointment(
    BookAppointmentEvent event,
    Emitter<BookingState> emit,
  ) async {
    emit(state.copyWith(status: BookingStatus.loading));

    final result = await _bookAppointment(event.appointment);

    result.fold(
      (failure) => emit(state.copyWith(
        status: BookingStatus.failure,
        errorMessage: failure.message,
      )),
      (_) => emit(state.copyWith(status: BookingStatus.success)),
    );
  }

  Future<void> _onCancelAppointment(
    CancelAppointmentEvent event,
    Emitter<BookingState> emit,
  ) async {
    emit(state.copyWith(status: BookingStatus.loading));

    final result = await _cancelAppointment(event.appointmentId);

    result.fold(
      (failure) => emit(state.copyWith(
        status: BookingStatus.failure,
        errorMessage: failure.message,
      )),
      (_) => emit(state.copyWith(status: BookingStatus.success)),
    );
  }
}
