import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

/// Animated horizontal progress bar in gold.
/// Drives its own entry animation via [TweenAnimationBuilder].
class GoldProgressBar extends StatelessWidget {
  final double progress; // 0.0 – 1.0
  final double height;
  final Duration duration;

  const GoldProgressBar({
    super.key,
    required this.progress,
    this.height = 6,
    this.duration = const Duration(milliseconds: 900),
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: progress.clamp(0.0, 1.0)),
      duration: duration,
      curve: Curves.easeOutCubic,
      builder: (_, value, _) {
        return Stack(
          children: [
            Container(
              height: height,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(height),
              ),
            ),
            FractionallySizedBox(
              widthFactor: value,
              child: Container(
                height: height,
                decoration: BoxDecoration(
                  color: AppColors.primaryGold,
                  borderRadius: BorderRadius.circular(height),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
