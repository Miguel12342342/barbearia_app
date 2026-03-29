import 'package:fpdart/fpdart.dart';
import '../../../../core/domain/value_object.dart';
import '../../../../core/error/failures.dart';

class PhoneNumber extends ValueObject<String> {
  @override
  final Either<Failure, String> value;

  factory PhoneNumber(String input) {
    return PhoneNumber._(_validatePhoneNumber(input));
  }

  const PhoneNumber._(this.value);

  static Either<Failure, String> _validatePhoneNumber(String input) {
    // Basic validation for Brazil phone typical format: 10 or 11 digits
    final cleaned = input.replaceAll(RegExp(r'\D'), '');
    if (cleaned.length >= 10 && cleaned.length <= 11) {
      return Right(cleaned);
    }
    return Left(ValidationFailure('Invalid phone number.'));
  }
}
