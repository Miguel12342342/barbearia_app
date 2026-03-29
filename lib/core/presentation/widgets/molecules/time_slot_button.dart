import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

class TimeSlotButton extends StatelessWidget {
  final String time;
  final bool isSelected;
  final bool isAvailable;
  final VoidCallback? onTap;

  const TimeSlotButton({
    super.key,
    required this.time,
    required this.isSelected,
    this.isAvailable = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Horário $time${isSelected ? ", selecionado" : ""}${!isAvailable ? ", indisponível" : ""}',
      button: isAvailable,
      child: GestureDetector(
        onTap: isAvailable ? onTap : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryGold : Colors.transparent,
            border: Border.all(
              color: isSelected
                  ? AppColors.primaryGold
                  : isAvailable
                      ? AppColors.cardBackground
                      : Colors.white10,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Text(
            time,
            style: TextStyle(
              color: isSelected
                  ? AppColors.background
                  : isAvailable
                      ? AppColors.textLight
                      : AppColors.textMuted.withValues(alpha: 0.4),
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }
}
