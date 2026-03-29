import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../theme/app_colors.dart';
import '../../../../features/barber/domain/entities/barber.dart';

class BarberCard extends StatelessWidget {
  final Barber barber;
  final bool isSelected;
  final VoidCallback onTap;

  const BarberCard({
    super.key,
    required this.barber,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '${barber.name}, ${barber.specialty.label}'
          '${isSelected ? ", selecionado" : ""}',
      button: true,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          width: 160,
          margin: const EdgeInsets.only(right: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppColors.primaryGold : Colors.transparent,
              width: 2.5,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Photo with shimmer placeholder
                CachedNetworkImage(
                  imageUrl: barber.photoUrl,
                  fit: BoxFit.cover,
                  placeholder: (_, _) => Shimmer.fromColors(
                    baseColor: AppColors.cardBackground,
                    highlightColor: AppColors.cardBackground.withValues(alpha: 0.5),
                    child: Container(color: AppColors.cardBackground),
                  ),
                  errorWidget: (_, _, _) => Container(
                    color: AppColors.cardBackground,
                    child: const Icon(Icons.person_rounded,
                        color: AppColors.textMuted, size: 40),
                  ),
                ),
                // Gradient overlay — lighter when selected
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: isSelected ? 0.55 : 0.72),
                        ],
                        stops: const [0.4, 1.0],
                      ),
                    ),
                  ),
                ),
                // Name + specialty at bottom
                Positioned(
                  left: 12,
                  right: 12,
                  bottom: 14,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        barber.name,
                        style: const TextStyle(
                          color: AppColors.textLight,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        barber.specialty.label,
                        style: const TextStyle(
                          color: AppColors.primaryGold,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
