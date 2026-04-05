import 'package:fpdart/fpdart.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/appointment.dart';
import '../../domain/repositories/i_appointment_repository.dart';
import '../datasources/i_appointment_datasource.dart';
import '../mappers/appointment_mapper.dart';

class AppointmentRepositoryImpl implements IAppointmentRepository {
  final IAppointmentDataSource _dataSource;

  AppointmentRepositoryImpl(this._dataSource);

  @override
  Stream<Either<Failure, List<Appointment>>> watchAppointments(
      String userId) async* {
    try {
      await for (final models in _dataSource.watchAppointments(userId)) {
        try {
          yield Right(models.map(AppointmentMapper.toEntity).toList());
        } catch (e) {
          yield Left(ValidationFailure('Failed to parse appointments: $e'));
        }
      }
    } on ServerException catch (e) {
      yield Left(ServerFailure(e.message));
    } catch (e) {
      yield Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> bookAppointment(
      Appointment appointment) async {
    if (!appointment.date.isValid() || !appointment.clientPhone.isValid()) {
      return const Left(ValidationFailure('Dados do agendamento inválidos'));
    }

    try {
      final model = AppointmentMapper.toModel(appointment);
      await _dataSource.bookAppointment(model);
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> cancelAppointment(
      String appointmentId) async {
    try {
      await _dataSource.cancelAppointment(appointmentId);
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> rescheduleAppointment(
      String appointmentId, DateTime newDate) async {
    try {
      await _dataSource.rescheduleAppointment(appointmentId, newDate);
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> rateAppointment(
      String appointmentId, int score) async {
    try {
      await _dataSource.rateAppointment(appointmentId, score);
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
