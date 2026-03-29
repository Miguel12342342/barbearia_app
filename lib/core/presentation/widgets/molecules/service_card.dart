import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../../features/catalog/domain/entities/service.dart';

class ServiceCard extends StatelessWidget {
  final Service service;
  final bool isSelected;
  final VoidCallback onTap;

  const ServiceCard({
    super.key,
    required this.service,
    required this.isSelected,
    required this.onTap,
  });

  IconData get _icon {
    switch (service.iconType) {
      case ServiceIconType.scissors:
        return Icons.content_cut_rounded;
      case ServiceIconType.beard:
        return Icons.face_retouching_natural_rounded;
      case ServiceIconType.combo:
        return Icons.star_rounded;
      case ServiceIconType.ritual:
        return Icons.spa_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final textColor = isSelected ? AppColors.background : AppColors.textLight;
    final subtitleColor =
        isSelected ? AppColors.background.withValues(alpha: 0.75) : AppColors.textMuted;
    final accentColor = isSelected ? AppColors.background : AppColors.primaryGold;

    return Semantics(
      label: '${service.name}, ${service.formattedPrice}, ${service.formattedDuration}'
          '${isSelected ? ", selecionado" : ""}',
      button: true,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          margin: const EdgeInsets.only(bottom: 16, left: 20, right: 20),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryGold : AppColors.cardBackground,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Stack(
            children: [
              Positioned(
                right: 0,
                top: 0,
                child: Text(
                  service.formattedDuration,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                    color: subtitleColor,
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(_icon, color: accentColor, size: 28),
                  const SizedBox(height: 20),
                  Text(
                    service.name,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    service.description,
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.4,
                      color: subtitleColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    service.formattedPrice,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: accentColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
