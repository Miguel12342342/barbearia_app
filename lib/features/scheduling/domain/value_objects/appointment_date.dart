import 'package:fpdart/fpdart.dart';
import '../../../../core/domain/value_object.dart';
import '../../../../core/error/failures.dart';

class AppointmentDate extends ValueObject<DateTime> {
  @override
  final Either<Failure, DateTime> value;

  factory AppointmentDate(DateTime input) {
    return AppointmentDate._(_validateAppointmentDate(input));
  }

  const AppointmentDate._(this.value);

  static Either<Failure, DateTime> _validateAppointmentDate(DateTime input) {
    if (input.isBefore(DateTime.now())) {
      return Left(ValidationFailure('Appointment date must be in the future.'));
    }
    return Right(input);
  }
}
