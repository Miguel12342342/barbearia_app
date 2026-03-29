/// Single source of truth for app-wide constants.
/// Replace [kDevUserId] and [kDevPhone] with real auth values
/// when Firebase Auth is wired.
abstract class AppConstants {
  // ── Development placeholders ──────────────────────────────────────────────
  /// Temporary user ID used before Firebase Auth is integrated.
  static const String kDevUserId = 'user_123';

  /// Temporary phone number used before user profile is loaded.
  static const String kDevPhone = '11999999999';

  // ── Loyalty ───────────────────────────────────────────────────────────────
  static const int kLoyaltyCutsToReward = 10;
  static const int kLoyaltyVipThreshold = 5;
  static const double kVipDiscountRate = 0.15;

  // ── Scheduling ────────────────────────────────────────────────────────────
  /// Fallback available time slots before IAvailabilityRepository is wired.
  static const List<String> kDefaultTimeSlots = [
    '09:00', '10:30', '11:00', '14:00', '15:30', '17:00',
  ];

  /// Minimum hours before appointment for cancellation to be allowed.
  static const int kCancellationWindowHours = 2;
}
