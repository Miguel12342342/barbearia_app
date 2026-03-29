import 'package:equatable/equatable.dart';
import '../value_objects/appointment_date.dart';
import '../value_objects/appointment_status.dart';
import '../value_objects/phone_number.dart';

class Appointment extends Equatable {
  final String id;
  final String userId;
  final String serviceId;
  final String barberId;
  final String serviceName;
  final String barberName;
  final AppointmentDate date;
  final PhoneNumber clientPhone;
  final AppointmentStatus status;
  final bool isPremium;

  const Appointment({
    required this.id,
    required this.userId,
    required this.serviceId,
    this.barberId = '',
    this.serviceName = '',
    this.barberName = '',
    required this.date,
    required this.clientPhone,
    required this.status,
    this.isPremium = false,
  });

  bool canBeCanceled() {
    // Example business logic: Can only be canceled if not already canceled
    // and if the appointment date is at least 2 hours in the future.
    if (status == AppointmentStatus.canceled) return false;
    
    return date.value.fold(
      (failure) => false,
      (dateTime) {
        final difference = dateTime.difference(DateTime.now());
        return difference.inHours >= 2;
      },
    );
  }

  bool isPremiumService() {
    return isPremium;
  }
  
  Appointment copyWith({
    String? id,
    String? userId,
    String? serviceId,
    String? barberId,
    String? serviceName,
    String? barberName,
    AppointmentDate? date,
    PhoneNumber? clientPhone,
    AppointmentStatus? status,
    bool? isPremium,
  }) {
    return Appointment(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      serviceId: serviceId ?? this.serviceId,
      barberId: barberId ?? this.barberId,
      serviceName: serviceName ?? this.serviceName,
      barberName: barberName ?? this.barberName,
      date: date ?? this.date,
      clientPhone: clientPhone ?? this.clientPhone,
      status: status ?? this.status,
      isPremium: isPremium ?? this.isPremium,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        serviceId,
        barberId,
        serviceName,
        barberName,
        date,
        clientPhone,
        status,
        isPremium,
      ];
}
