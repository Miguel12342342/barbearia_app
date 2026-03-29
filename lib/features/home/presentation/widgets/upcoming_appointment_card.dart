import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/presentation/widgets/atoms/status_pill.dart';

class UpcomingAppointmentCard extends StatelessWidget {
  final String? serviceName;
  final String? barberName;
  final String? timeLabel;
  final String? dateLabel;
  final VoidCallback? onCheckIn;
  final String? backgroundImageUrl;

  const UpcomingAppointmentCard({
    super.key,
    this.serviceName,
    this.barberName,
    this.timeLabel,
    this.dateLabel,
    this.onCheckIn,
    this.backgroundImageUrl,
  });

  bool get _hasAppointment =>
      serviceName != null && timeLabel != null && dateLabel != null;

  @override
  Widget build(BuildContext context) {
    if (!_hasAppointment) return _buildEmptyState();
    return _buildCard();
  }

  Widget _buildCard() {
    return Semantics(
      label:
          '$serviceName com $barberName às $timeLabel, $dateLabel. Botão de check-in disponível.',
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            // Background photo
            Positioned.fill(
              child: CachedNetworkImage(
                imageUrl: backgroundImageUrl ??
                    'https://images.unsplash.com/photo-1503951914875-452162b0f3f1?q=80&w=600&auto=format&fit=crop',
                fit: BoxFit.cover,
                errorWidget: (_, _, _) =>
                    Container(color: AppColors.cardBackground),
              ),
            ),
            // Dark overlay
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.55),
                      Colors.black.withValues(alpha: 0.82),
                    ],
                  ),
                ),
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const StatusPill(
                          label: 'UPCOMING', variant: PillVariant.upcoming),
                      const Icon(Icons.calendar_today_outlined,
                          color: AppColors.textLight, size: 20),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    serviceName!,
                    style: const TextStyle(
                      color: AppColors.textLight,
                      fontSize: 24,
                      height: 1.2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (barberName != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Com $barberName',
                      style: const TextStyle(
                          color: AppColors.textMuted, fontSize: 14),
                    ),
                  ],
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            timeLabel!,
                            style: const TextStyle(
                              color: AppColors.primaryGold,
                              fontSize: 32,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            dateLabel!.toUpperCase(),
                            style: const TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: onCheckIn,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryGold,
                          foregroundColor: AppColors.background,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'CHECK IN',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, letterSpacing: 1.0),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primaryGold.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.calendar_today_outlined,
                color: AppColors.primaryGold, size: 24),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Nenhum agendamento próximo',
                  style: TextStyle(
                    color: AppColors.textLight,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Agende seu próximo horário agora.',
                  style: TextStyle(color: AppColors.textMuted, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
