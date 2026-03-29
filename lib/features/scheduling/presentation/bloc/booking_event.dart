import 'package:equatable/equatable.dart';
import '../../domain/entities/appointment.dart';

abstract class BookingEvent extends Equatable {
  const BookingEvent();

  @override
  List<Object?> get props => [];
}

class LoadAppointmentsEvent extends BookingEvent {
  final String userId;
  const LoadAppointmentsEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}

class BookAppointmentEvent extends BookingEvent {
  final Appointment appointment;
  const BookAppointmentEvent(this.appointment);

  @override
  List<Object?> get props => [appointment];
}

class CancelAppointmentEvent extends BookingEvent {
  final String appointmentId;
  const CancelAppointmentEvent(this.appointmentId);

  @override
  List<Object?> get props => [appointmentId];
}
