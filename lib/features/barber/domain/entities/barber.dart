import 'package:equatable/equatable.dart';

enum BarberSpecialty { mestreBarber, visagista, colorista }

extension BarberSpecialtyLabel on BarberSpecialty {
  String get label {
    switch (this) {
      case BarberSpecialty.mestreBarber:
        return 'MESTRE BARBER';
      case BarberSpecialty.visagista:
        return 'VISAGISTA';
      case BarberSpecialty.colorista:
        return 'COLORISTA';
    }
  }

  static BarberSpecialty fromString(String value) {
    switch (value) {
      case 'visagista':
        return BarberSpecialty.visagista;
      case 'colorista':
        return BarberSpecialty.colorista;
      default:
        return BarberSpecialty.mestreBarber;
    }
  }
}

class Barber extends Equatable {
  final String id;
  final String name;
  final BarberSpecialty specialty;
  final String photoUrl;
  final bool isAvailable;

  const Barber({
    required this.id,
    required this.name,
    required this.specialty,
    required this.photoUrl,
    this.isAvailable = true,
  });

  @override
  List<Object?> get props => [id, name, specialty, photoUrl, isAvailable];
}
