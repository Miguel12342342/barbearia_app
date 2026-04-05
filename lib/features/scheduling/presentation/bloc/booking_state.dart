import 'package:equatable/equatable.dart';
import '../../domain/entities/appointment.dart';

enum BookingStatus { initial, loading, success, failure }

class BookingState extends Equatable {
  final BookingStatus status;
  final List<Appointment> appointments;
  final String errorMessage;
  final Appointment? lastBookedAppointment;

  const BookingState({
    this.status = BookingStatus.initial,
    this.appointments = const [],
    this.errorMessage = '',
    this.lastBookedAppointment,
  });

  BookingState copyWith({
    BookingStatus? status,
    List<Appointment>? appointments,
    String? errorMessage,
    Appointment? lastBookedAppointment,
  }) {
    return BookingState(
      status: status ?? this.status,
      appointments: appointments ?? this.appointments,
      errorMessage: errorMessage ?? this.errorMessage,
      lastBookedAppointment: lastBookedAppointment ?? this.lastBookedAppointment,
    );
  }

  @override
  List<Object?> get props => [status, appointments, errorMessage, lastBookedAppointment];
}
