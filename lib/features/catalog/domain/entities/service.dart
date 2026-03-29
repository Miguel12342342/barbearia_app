import 'package:equatable/equatable.dart';

enum ServiceIconType { scissors, beard, combo, ritual }

class Service extends Equatable {
  final String id;
  final String name;
  final String description;
  final double priceAmount;
  final int durationMinutes;
  final ServiceIconType iconType;
  final bool isPremium;

  const Service({
    required this.id,
    required this.name,
    required this.description,
    required this.priceAmount,
    required this.durationMinutes,
    required this.iconType,
    this.isPremium = false,
  });

  String get formattedPrice {
    final formatted = priceAmount.toStringAsFixed(2).replaceAll('.', ',');
    return 'R\$ $formatted';
  }

  String get formattedDuration => '$durationMinutes MIN';

  @override
  List<Object?> get props =>
      [id, name, description, priceAmount, durationMinutes, iconType, isPremium];
}
