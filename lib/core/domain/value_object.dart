import 'package:fpdart/fpdart.dart';
import '../error/failures.dart';

abstract class ValueObject<T> {
  const ValueObject();
  
  Either<Failure, T> get value;

  bool isValid() => value.isRight();

  // Helper to extract value or throw (use with caution, only when fully validated)
  T getOrCrash() {
    return value.fold(
      (f) => throw Exception('Unexpected error: $f'),
      (r) => r,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ValueObject<T> && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;
  
  @override
  String toString() => 'Value($value)';
}
