import 'package:equatable/equatable.dart';
import '../../../barber/domain/entities/barber.dart';
import '../../../catalog/domain/entities/service.dart';

enum BookingFormStatus { idle, loadingData, ready, error }

class BookingFormState extends Equatable {
  final BookingFormStatus status;
  final List<Service> services;
  final List<Barber> barbers;
  final Service? selectedService;
  final Barber? selectedBarber;
  final DateTime? selectedDate;
  final String? selectedTime;
  final String errorMessage;

  const BookingFormState({
    this.status = BookingFormStatus.idle,
    this.services = const [],
    this.barbers = const [],
    this.selectedService,
    this.selectedBarber,
    this.selectedDate,
    this.selectedTime,
    this.errorMessage = '',
  });

  bool get isComplete =>
      selectedService != null &&
      selectedBarber != null &&
      selectedDate != null &&
      selectedTime != null;

  BookingFormState copyWith({
    BookingFormStatus? status,
    List<Service>? services,
    List<Barber>? barbers,
    Service? selectedService,
    Barber? selectedBarber,
    DateTime? selectedDate,
    String? selectedTime,
    String? errorMessage,
    bool clearSelectedTime = false,
  }) {
    return BookingFormState(
      status: status ?? this.status,
      services: services ?? this.services,
      barbers: barbers ?? this.barbers,
      selectedService: selectedService ?? this.selectedService,
      selectedBarber: selectedBarber ?? this.selectedBarber,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedTime: clearSelectedTime ? null : (selectedTime ?? this.selectedTime),
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        services,
        barbers,
        selectedService,
        selectedBarber,
        selectedDate,
        selectedTime,
        errorMessage,
      ];
}
