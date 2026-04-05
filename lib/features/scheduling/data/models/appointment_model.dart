/// Pure data model — no domain logic, only primitives.
/// Mirrors Firestore document structure exactly.
class AppointmentModel {
  final String id;
  final String userId;
  final String serviceId;
  final String barberId;
  final String serviceName;
  final String barberName;
  final DateTime date;
  final String clientPhone;
  final String status;
  final bool isPremium;
  final int? rating;

  const AppointmentModel({
    required this.id,
    required this.userId,
    required this.serviceId,
    this.barberId = '',
    this.serviceName = '',
    this.barberName = '',
    required this.date,
    required this.clientPhone,
    required this.status,
    required this.isPremium,
    this.rating,
  });
}
