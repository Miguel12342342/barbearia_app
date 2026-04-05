import '../models/appointment_model.dart';

/// Contract for appointment data sources.
/// Only uses models and primitives — no domain entities cross this boundary.
abstract class IAppointmentDataSource {
  Stream<List<AppointmentModel>> watchAppointments(String userId);
  Future<void> bookAppointment(AppointmentModel model);
  Future<void> cancelAppointment(String appointmentId);
  Future<void> rescheduleAppointment(String appointmentId, DateTime newDate);
  Future<void> rateAppointment(String appointmentId, int score);
}
