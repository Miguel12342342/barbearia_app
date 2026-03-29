import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

enum PillVariant { upcoming, confirmed, pending, canceled, vip }

class StatusPill extends StatelessWidget {
  final String label;
  final PillVariant variant;

  const StatusPill({
    super.key,
    required this.label,
    this.variant = PillVariant.upcoming,
  });

  Color get _bg {
    switch (variant) {
      case PillVariant.upcoming:
        return AppColors.primaryGold.withValues(alpha: 0.15);
      case PillVariant.confirmed:
        return Colors.green.withValues(alpha: 0.15);
      case PillVariant.pending:
        return Colors.orange.withValues(alpha: 0.15);
      case PillVariant.canceled:
        return AppColors.error.withValues(alpha: 0.15);
      case PillVariant.vip:
        return AppColors.primaryGold.withValues(alpha: 0.2);
    }
  }

  Color get _fg {
    switch (variant) {
      case PillVariant.confirmed:
        return Colors.greenAccent;
      case PillVariant.pending:
        return Colors.orange;
      case PillVariant.canceled:
        return AppColors.error;
      default:
        return AppColors.primaryGold;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _fg.withValues(alpha: 0.35)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: _fg,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
