import 'package:equatable/equatable.dart';

class ServiceHistoryEntry extends Equatable {
  final String serviceName;
  final String barberName;
  final DateTime date;

  const ServiceHistoryEntry({
    required this.serviceName,
    required this.barberName,
    required this.date,
  });

  String get formattedDate {
    const months = [
      'JAN', 'FEV', 'MAR', 'ABR', 'MAI', 'JUN',
      'JUL', 'AGO', 'SET', 'OUT', 'NOV', 'DEZ',
    ];
    return '${date.day.toString().padLeft(2, '0')} ${months[date.month - 1]}';
  }

  @override
  List<Object?> get props => [serviceName, barberName, date];
}

class LoyaltyProgram extends Equatable {
  static const int defaultCutsToReward = 10;
  static const double vipDiscountRate = 0.15;
  static const int vipThreshold = 5;

  final String userId;
  final int currentCuts;
  final int cutsToNextReward;
  final String nextRewardDescription;
  final List<String> vipBenefits;
  final String memberQRCode;
  final List<ServiceHistoryEntry> serviceHistory;

  const LoyaltyProgram({
    required this.userId,
    required this.currentCuts,
    this.cutsToNextReward = defaultCutsToReward,
    required this.nextRewardDescription,
    required this.vipBenefits,
    required this.memberQRCode,
    required this.serviceHistory,
  });

  double get progressFraction =>
      (currentCuts / cutsToNextReward).clamp(0.0, 1.0);

  int get progressPercent => (progressFraction * 100).toInt();

  bool get isNextRewardUnlocked => currentCuts >= cutsToNextReward;

  bool get isVip => currentCuts >= vipThreshold;

  int get cutsRemaining =>
      (cutsToNextReward - currentCuts).clamp(0, cutsToNextReward);

  @override
  List<Object?> get props => [
        userId,
        currentCuts,
        cutsToNextReward,
        nextRewardDescription,
        vipBenefits,
        memberQRCode,
        serviceHistory,
      ];
}
