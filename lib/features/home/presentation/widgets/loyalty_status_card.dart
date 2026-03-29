import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class LoyaltyStatusCard extends StatelessWidget {
  final int cutsCount;
  final int cutsRequired;

  const LoyaltyStatusCard({
    super.key,
    required this.cutsCount,
    this.cutsRequired = 10,
  });

  @override
  Widget build(BuildContext context) {
    final double progress = cutsCount / cutsRequired;
    final int remaining = cutsRequired - cutsCount;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.emoji_events, color: AppColors.primaryGold, size: 20),
              const SizedBox(width: 8),
              Text(
                'LOYALTY STATUS',
                style: TextStyle(
                  color: AppColors.textLight.withValues(alpha: 0.9),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '$cutsCount',
                style: const TextStyle(
                  color: AppColors.textLight,
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                  height: 1,
                ),
              ),
              Text(
                '/$cutsRequired',
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            remaining == 1
                ? 'Mais 1 corte para o seu próximo prêmio.'
                : 'Mais $remaining cortes para o seu próximo prêmio.',
            style: const TextStyle(
              color: AppColors.textMuted,
              fontSize: 13,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 24),
          // Animated progress bar
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: progress),
            duration: const Duration(milliseconds: 900),
            curve: Curves.easeOutCubic,
            builder: (_, value, _) {
              return Stack(
                children: [
                  Container(
                    height: 6,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  FractionallySizedBox(
                    widthFactor: value,
                    child: Container(
                      height: 6,
                      decoration: BoxDecoration(
                        color: AppColors.primaryGold,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '${(progress * 100).toInt()}% COMPLETE',
              style: const TextStyle(
                color: AppColors.primaryGold,
                fontSize: 9,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
