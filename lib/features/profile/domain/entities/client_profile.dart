import 'package:equatable/equatable.dart';

enum MemberTier { standard, premium }

class StylePreferences extends Equatable {
  final String haircut;
  final DateTime? lastServiceDate;
  final String beardStyle;
  final String beardContour;
  final List<String> favoriteProducts;
  final String preferredBarberId;
  final String preferredBarberName;

  const StylePreferences({
    required this.haircut,
    this.lastServiceDate,
    required this.beardStyle,
    required this.beardContour,
    required this.favoriteProducts,
    required this.preferredBarberId,
    required this.preferredBarberName,
  });

  String get lastServiceLabel {
    if (lastServiceDate == null) return 'Nenhum serviço ainda';
    final diff = DateTime.now().difference(lastServiceDate!).inDays;
    if (diff == 0) return 'Hoje';
    if (diff == 1) return 'Ontem';
    return '$diff dias atrás';
  }

  StylePreferences copyWith({
    String? haircut,
    DateTime? lastServiceDate,
    String? beardStyle,
    String? beardContour,
    List<String>? favoriteProducts,
    String? preferredBarberId,
    String? preferredBarberName,
  }) {
    return StylePreferences(
      haircut: haircut ?? this.haircut,
      lastServiceDate: lastServiceDate ?? this.lastServiceDate,
      beardStyle: beardStyle ?? this.beardStyle,
      beardContour: beardContour ?? this.beardContour,
      favoriteProducts: favoriteProducts ?? this.favoriteProducts,
      preferredBarberId: preferredBarberId ?? this.preferredBarberId,
      preferredBarberName: preferredBarberName ?? this.preferredBarberName,
    );
  }

  @override
  List<Object?> get props => [
        haircut,
        lastServiceDate,
        beardStyle,
        beardContour,
        favoriteProducts,
        preferredBarberId,
        preferredBarberName,
      ];
}

class ClientProfile extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? photoUrl; // null = sem foto cadastrada
  final DateTime memberSince;
  final MemberTier tier;
  final StylePreferences stylePreferences;

  const ClientProfile({
    required this.id,
    required this.name,
    required this.email,
    this.photoUrl,
    required this.memberSince,
    required this.tier,
    required this.stylePreferences,
  });

  bool get isPremium => tier == MemberTier.premium;

  String get memberSinceFormatted {
    const months = [
      'Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho',
      'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro',
    ];
    return 'Cliente desde ${months[memberSince.month - 1]}, ${memberSince.year}';
  }

  ClientProfile copyWith({
    String? id,
    String? name,
    String? email,
    String? photoUrl,
    DateTime? memberSince,
    MemberTier? tier,
    StylePreferences? stylePreferences,
  }) {
    return ClientProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      memberSince: memberSince ?? this.memberSince,
      tier: tier ?? this.tier,
      stylePreferences: stylePreferences ?? this.stylePreferences,
    );
  }

  @override
  List<Object?> get props =>
      [id, name, email, photoUrl, memberSince, tier, stylePreferences];
}
