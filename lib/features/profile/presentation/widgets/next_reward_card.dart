import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/locale/app_localizations.dart';
import '../../../../../core/presentation/widgets/atoms/app_card.dart';
import '../../../../../core/presentation/widgets/atoms/gold_progress_bar.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../loyalty/presentation/cubit/loyalty_cubit.dart';
import '../../../loyalty/presentation/cubit/loyalty_state.dart';

class NextRewardCard extends StatelessWidget {
  const NextRewardCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocBuilder<LoyaltyCubit, LoyaltyState>(
      builder: (context, state) {
        final program = state.program;
        final cuts = program?.currentCuts ?? 0;
        final total = program?.cutsToNextReward ?? 10;
        final progress = program?.progressFraction ?? 0.0;
        final percent = program?.progressPercent ?? 0;
        final remaining = program?.cutsRemaining ?? total;
        final reward = program?.nextRewardDescription ?? '';

        return AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.nextReward,
                style: const TextStyle(
                  color: AppColors.textLight,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$cuts de $total cortes realizados',
                    style: const TextStyle(
                        color: AppColors.textMuted, fontSize: 13),
                  ),
                  Text(
                    '$percent%',
                    style: const TextStyle(
                      color: AppColors.primaryGold,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              GoldProgressBar(progress: progress),
              if (reward.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  l10n.cutsRemainingAlert(remaining),
                  style: const TextStyle(
                      color: AppColors.textMuted, fontSize: 12),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
