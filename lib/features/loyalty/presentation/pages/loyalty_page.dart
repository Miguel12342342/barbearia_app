import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../../core/locale/app_localizations.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../loyalty/domain/entities/loyalty_program.dart';
import '../../../../core/presentation/widgets/atoms/gold_progress_bar.dart';
import '../../../../core/presentation/widgets/atoms/gold_primary_button.dart';
import '../../../../core/presentation/widgets/molecules/history_list_item.dart';
import '../cubit/loyalty_cubit.dart';
import '../cubit/loyalty_state.dart';
import '../../../home/presentation/pages/shell_page.dart';

class LoyaltyPage extends StatefulWidget {
  const LoyaltyPage({super.key});

  @override
  State<LoyaltyPage> createState() => _LoyaltyPageState();
}

class _LoyaltyPageState extends State<LoyaltyPage> {
  String get _userId =>
      context.read<AuthCubit>().state.userId ?? '';

  @override
  void initState() {
    super.initState();
    context.read<LoyaltyCubit>().load(_userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu_rounded, color: AppColors.primaryGold),
          onPressed: () => ShellPage.scaffoldKey.currentState?.openDrawer(),
        ),
        title: const Text(
          'Corte & Barba',
          style: TextStyle(
            color: AppColors.primaryGold,
            fontWeight: FontWeight.w900,
            fontSize: 20,
            letterSpacing: -0.5,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: BlocBuilder<LoyaltyCubit, LoyaltyState>(
          builder: (context, state) {
            if (state.status == LoyaltyStatus.loading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primaryGold),
              );
            }
            if (state.status == LoyaltyStatus.error) {
              return Center(
                child: Text(
                  state.errorMessage,
                  style: const TextStyle(color: AppColors.error),
                ),
              );
            }
            final program = state.program;
            if (program == null) return const SizedBox.shrink();

            final l10n = AppLocalizations.of(context);
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  // Header
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w900,
                        height: 1.1,
                      ),
                      children: [
                        TextSpan(
                          text: '${l10n.loyaltyTitle1}\n',
                          style: const TextStyle(color: AppColors.textLight),
                        ),
                        TextSpan(
                          text: l10n.loyaltyTitle2,
                          style: const TextStyle(color: AppColors.primaryGold),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    l10n.loyaltySubtitle,
                    style: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 13,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Status card
                  _buildStatusCard(context, program.currentCuts, program.cutsToNextReward,
                      program.progressFraction, program.progressPercent),
                  const SizedBox(height: 16),

                  // Next reward alert
                  if (!program.isNextRewardUnlocked)
                    _buildRewardAlert(context, program.cutsRemaining,
                        program.nextRewardDescription),
                  if (program.isNextRewardUnlocked)
                    _buildRewardUnlocked(context, program.nextRewardDescription),
                  const SizedBox(height: 16),

                  // VIP Benefits
                  if (program.isVip) _buildVipCard(context, program.vipBenefits),
                  const SizedBox(height: 16),

                  // QR Code member card
                  _buildQrCard(context, program.memberQRCode,
                      state.status == LoyaltyStatus.redeeming),
                  const SizedBox(height: 28),

                  // History
                  _buildHistorySection(context, program),
                  const SizedBox(height: 80),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatusCard(
      BuildContext context, int cuts, int total, double progress, int percent) {
    final l10n = AppLocalizations.of(context);
    final authState = context.read<AuthCubit>().state;
    final firstName = authState.displayName?.split(' ').first ??
        authState.email?.split('@').first ??
        '';
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.currentStatus,
            style: const TextStyle(
              color: AppColors.textMuted,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.almostThere,
                    style: const TextStyle(color: AppColors.textLight, fontSize: 18),
                  ),
                  Text(
                    firstName,
                    style: const TextStyle(
                      color: AppColors.textLight,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '$cuts',
                      style: const TextStyle(
                        color: AppColors.textLight,
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        height: 1,
                      ),
                    ),
                    TextSpan(
                      text: '/$total',
                      style: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Semantics(
            label: l10n.loyaltyProgressLabel(percent),
            child: GoldProgressBar(progress: progress),
          ),
        ],
      ),
    );
  }

  Widget _buildRewardAlert(BuildContext context, int remaining, String reward) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.primaryGold.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border:
            Border.all(color: AppColors.primaryGold.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.emoji_events_rounded,
              color: AppColors.primaryGold, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.cutsRemainingAlert(remaining),
                  style: const TextStyle(
                    color: AppColors.primaryGold,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.completeVisitMessage(10 - remaining + 1, reward),
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRewardUnlocked(BuildContext context, String reward) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle_rounded, color: Colors.greenAccent, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              l10n.rewardAvailableMessage(reward),
              style: const TextStyle(
                color: Colors.greenAccent,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVipCard(BuildContext context, List<String> benefits) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.star_rounded,
                  color: AppColors.primaryGold, size: 20),
              const SizedBox(width: 10),
              Text(
                l10n.vipBenefits,
                style: const TextStyle(
                  color: AppColors.textLight,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...benefits.map(
            (b) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Icon(Icons.circle,
                        color: AppColors.primaryGold, size: 6),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      b,
                      style: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQrCard(
      BuildContext context, String qrData, bool isRedeeming) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: QrImageView(
              data: qrData,
              version: QrVersions.auto,
              size: 72,
              backgroundColor: Colors.white,
              eyeStyle: const QrEyeStyle(
                eyeShape: QrEyeShape.square,
                color: Colors.black,
              ),
              dataModuleStyle: const QrDataModuleStyle(
                dataModuleShape: QrDataModuleShape.square,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context).memberCode,
                  style: const TextStyle(
                    color: AppColors.textLight,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  AppLocalizations.of(context).memberCodeSubtitle,
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: isRedeeming
                ? null
                : () => context
                    .read<LoyaltyCubit>()
                    .redeemReward(context.read<AuthCubit>().state.userId ?? ''),
            child: Text(
              isRedeeming ? '...' : AppLocalizations.of(context).redeem,
              style: const TextStyle(
                color: AppColors.primaryGold,
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistorySection(BuildContext context, LoyaltyProgram program) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.history_rounded,
                color: AppColors.primaryGold, size: 18),
            const SizedBox(width: 8),
            Text(
              l10n.recentHistory,
              style: const TextStyle(
                color: AppColors.textLight,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ...program.serviceHistory.take(4).indexed.map((e) => Column(
              children: [
                HistoryListItem(entry: e.$2),
                if (e.$1 < 3) const Divider(color: Colors.white10, height: 1),
              ],
            )),
        const SizedBox(height: 16),
        GoldPrimaryButton(
          label: l10n.viewFullHistory,
          onPressed: () {},
        ),
      ],
    );
  }
}
