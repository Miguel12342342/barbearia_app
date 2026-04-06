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
