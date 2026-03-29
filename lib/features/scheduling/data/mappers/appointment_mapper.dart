import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/appointment.dart';
import '../../domain/value_objects/appointment_date.dart';
import '../../domain/value_objects/appointment_status.dart';
import '../../domain/value_objects/phone_number.dart';
import '../models/appointment_model.dart';

class AppointmentMapper {
  AppointmentMapper._();

  static const _statusMap = {
    'pending': AppointmentStatus.pending,
    'confirmed': AppointmentStatus.confirmed,
    'canceled': AppointmentStatus.canceled,
  };

  /// Firestore DocumentSnapshot → AppointmentModel
  static AppointmentModel fromFirestore(DocumentSnapshot doc) {
    if (!doc.exists) throw const FormatException('Document does not exist');
    final data = doc.data() as Map<String, dynamic>? ?? {};

    return AppointmentModel(
      id: doc.id,
      userId: data['userId'] as String? ?? '',
      serviceId: data['serviceId'] as String? ?? '',
      barberId: data['barberId'] as String? ?? '',
      serviceName: data['serviceName'] as String? ?? '',
      barberName: data['barberName'] as String? ?? '',
      date: (data['date'] as Timestamp).toDate(),
      clientPhone: data['clientPhone'] as String? ?? '',
      status: data['status'] as String? ?? 'pending',
      isPremium: data['isPremium'] as bool? ?? false,
    );
  }

  /// AppointmentModel → AppointmentEntity
  static Appointment toEntity(AppointmentModel model) {
    return Appointment(
      id: model.id,
      userId: model.userId,
      serviceId: model.serviceId,
      barberId: model.barberId,
      serviceName: model.serviceName,
      barberName: model.barberName,
      date: AppointmentDate(model.date),
      clientPhone: PhoneNumber(model.clientPhone),
      status: _statusMap[model.status] ?? AppointmentStatus.pending,
      isPremium: model.isPremium,
    );
  }

  /// AppointmentEntity → AppointmentModel (for persistence)
  static AppointmentModel toModel(Appointment entity) {
    return AppointmentModel(
      id: entity.id,
      userId: entity.userId,
      serviceId: entity.serviceId,
      barberId: entity.barberId,
      serviceName: entity.serviceName,
      barberName: entity.barberName,
      date: entity.date.value.fold((_) => DateTime.now(), (d) => d),
      clientPhone: entity.clientPhone.value.fold((_) => '', (p) => p),
      status: entity.status.name,
      isPremium: entity.isPremium,
    );
  }

  /// AppointmentModel to Map (for Firestore write)
  static Map<String, dynamic> toMap(AppointmentModel model) {
    return {
      'userId': model.userId,
      'serviceId': model.serviceId,
      'barberId': model.barberId,
      'serviceName': model.serviceName,
      'barberName': model.barberName,
      'date': Timestamp.fromDate(model.date),
      'clientPhone': model.clientPhone,
      'status': model.status,
      'isPremium': model.isPremium,
    };
  }
}
