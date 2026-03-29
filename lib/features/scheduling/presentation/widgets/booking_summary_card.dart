import 'package:flutter/material.dart';
import '../../../../core/locale/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';

class BookingSummaryCard extends StatelessWidget {
  final String serviceName;
  final String servicePrice;
  final String barberName;
  final String dateAndTime;
  final VoidCallback onConfirm;
  final bool isLoading;

  const BookingSummaryCard({
    super.key,
    required this.serviceName,
    required this.servicePrice,
    required this.barberName,
    required this.dateAndTime,
    required this.onConfirm,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.bookingSummary,
              style: const TextStyle(
                  color: AppColors.textLight,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),

          _buildRow(l10n.serviceLabel, serviceName, servicePrice),
          const SizedBox(height: 16),
          _buildRow(l10n.barberLabel, barberName, null, hasCheck: true),
          const SizedBox(height: 16),
          _buildRow(l10n.dateTimeLabel, dateAndTime, null),

          const SizedBox(height: 24),
          const Divider(color: Colors.white24, height: 1),
          const SizedBox(height: 24),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.subtotal,
                      style: const TextStyle(
                          color: AppColors.textMuted, fontSize: 12)),
                  const SizedBox(height: 4),
                  Text(l10n.total,
                      style: const TextStyle(
                          color: AppColors.textLight,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(servicePrice,
                      style: const TextStyle(
                          color: AppColors.textMuted, fontSize: 12)),
                  const SizedBox(height: 4),
                  Text(servicePrice,
                      style: const TextStyle(
                          color: AppColors.primaryGold,
                          fontSize: 22,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isLoading ? null : onConfirm,
              child: isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                          color: AppColors.background, strokeWidth: 2))
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(l10n.confirmBooking),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward_rounded, size: 20),
                      ],
                    ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value, String? trailing,
      {bool hasCheck = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2)),
              const SizedBox(height: 4),
              Text(value,
                  style:
                      const TextStyle(color: AppColors.textLight, fontSize: 14)),
            ],
          ),
        ),
        if (trailing != null)
          Text(trailing,
              style: const TextStyle(
                  color: AppColors.primaryGold,
                  fontSize: 14,
                  fontWeight: FontWeight.bold)),
        if (hasCheck)
          const Icon(Icons.check_circle,
              color: AppColors.primaryGold, size: 16),
      ],
    );
  }
}
