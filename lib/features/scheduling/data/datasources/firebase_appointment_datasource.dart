import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/error/exceptions.dart';
import '../mappers/appointment_mapper.dart';
import '../models/appointment_model.dart';
import 'i_appointment_datasource.dart';

class FirebaseAppointmentDataSource implements IAppointmentDataSource {
  final FirebaseFirestore _firestore;

  FirebaseAppointmentDataSource(this._firestore);

  @override
  Stream<List<AppointmentModel>> watchAppointments(String userId) {
    try {
      return _firestore
          .collection('appointments')
          .where('userId', isEqualTo: userId)
          .snapshots()
          .map((snap) =>
              snap.docs.map(AppointmentMapper.fromFirestore).toList());
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Unknown Firebase error');
    }
  }

  @override
  Future<void> bookAppointment(AppointmentModel model) async {
    try {
      await _firestore
          .collection('appointments')
          .doc(model.id.isEmpty ? null : model.id)
          .set(AppointmentMapper.toMap(model));
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Failed to book appointment');
    }
  }

  @override
  Future<void> cancelAppointment(String appointmentId) async {
    try {
      await _firestore
          .collection('appointments')
          .doc(appointmentId)
          .update({'status': 'canceled'});
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Failed to cancel appointment');
    }
  }
}
