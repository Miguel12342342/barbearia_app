import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

class DayPill extends StatelessWidget {
  final DateTime date;
  final bool isSelected;
  final VoidCallback onTap;

  static const _weekdays = {
    1: 'SEG', 2: 'TER', 3: 'QUA',
    4: 'QUI', 5: 'SEX', 6: 'SÁB', 7: 'DOM',
  };

  const DayPill({
    super.key,
    required this.date,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final label = _weekdays[date.weekday]!;
    return Semantics(
      label: '$label ${date.day}${isSelected ? ", selecionado" : ""}',
      button: true,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: 58,
          margin: const EdgeInsets.only(right: 12),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryGold : AppColors.cardBackground,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: TextStyle(
                  color:
                      isSelected ? AppColors.background : AppColors.textMuted,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${date.day}',
                style: TextStyle(
                  color:
                      isSelected ? AppColors.background : AppColors.textLight,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
