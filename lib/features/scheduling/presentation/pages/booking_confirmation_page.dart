import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/locale/app_localizations.dart';
import '../../../../core/presentation/widgets/atoms/gold_primary_button.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/appointment.dart';

class BookingConfirmationPage extends StatelessWidget {
  final Appointment appointment;
  const BookingConfirmationPage({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final date = appointment.date.value.fold((_) => DateTime.now(), (d) => d);
    final dateLabel = DateFormat(l10n.bookingDateFormat, l10n.dateLocale).format(date);
    final timeLabel = DateFormat('HH:mm').format(date);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Spacer(),
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.5, end: 1.0),
                duration: const Duration(milliseconds: 700),
                curve: Curves.elasticOut,
                builder: (_, scale, child) =>
                    Transform.scale(scale: scale, child: child),
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: Colors.greenAccent,
                  size: 88,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                l10n.bookingConfirmedTitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.textLight,
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  height: 1.1,
                ),
              ),
              const Spacer(),
              _SummaryCard(
                serviceName: appointment.serviceName,
                barberName: appointment.barberName,
                dateLabel: dateLabel,
                timeLabel: timeLabel,
                l10n: l10n,
              ),
              const Spacer(),
              GoldPrimaryButton(
                label: l10n.goHome,
                onPressed: () => context.go('/home'),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => context.go('/booking'),
                child: Text(
                  l10n.viewMyAppointments,
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String serviceName;
  final String barberName;
  final String dateLabel;
  final String timeLabel;
  final AppLocalizations l10n;

  const _SummaryCard({
    required this.serviceName,
    required this.barberName,
    required this.dateLabel,
    required this.timeLabel,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _Row(label: l10n.serviceLabel, value: serviceName),
          const Divider(color: Colors.white10, height: 28),
          _Row(label: l10n.barberLabel, value: barberName),
          const Divider(color: Colors.white10, height: 28),
          _Row(label: l10n.dateLabel, value: dateLabel),
          const Divider(color: Colors.white10, height: 28),
          _Row(label: l10n.timeLabel, value: timeLabel),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  const _Row({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textMuted,
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.textLight,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
