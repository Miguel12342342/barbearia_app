import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../catalog/domain/entities/service.dart';
import '../../../catalog/presentation/cubit/catalog_cubit.dart';
import '../../../catalog/presentation/cubit/catalog_state.dart';

class CuratedServicesList extends StatelessWidget {
  const CuratedServicesList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CatalogCubit, CatalogState>(
      builder: (context, state) {
        if (state.status == CatalogStatus.loading ||
            state.status == CatalogStatus.initial) {
          return const Padding(
            padding: EdgeInsets.all(40),
            child: Center(
              child: CircularProgressIndicator(
                color: AppColors.primaryGold,
                strokeWidth: 2,
              ),
            ),
          );
        }
        if (state.status == CatalogStatus.error) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              state.errorMessage,
              style: const TextStyle(color: AppColors.error),
            ),
          );
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Curated Services',
                style: TextStyle(
                  color: AppColors.textLight,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              ...state.services.map((s) => _ServiceCard(service: s)),
              const SizedBox(height: 100),
            ],
          ),
        );
      },
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final Service service;

  const _ServiceCard({required this.service});

  IconData get _icon {
    switch (service.iconType) {
      case ServiceIconType.scissors:
        return Icons.content_cut;
      case ServiceIconType.beard:
        return Icons.face_retouching_natural;
      case ServiceIconType.combo:
        return Icons.auto_awesome;
      case ServiceIconType.ritual:
        return Icons.spa;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(_icon, color: AppColors.primaryGold, size: 24),
          ),
          const SizedBox(height: 16),
          Text(
            service.name,
            style: const TextStyle(
              color: AppColors.textLight,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            service.description,
            style: const TextStyle(
              color: AppColors.textMuted,
              fontSize: 13,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                service.formattedPrice,
                style: const TextStyle(
                  color: AppColors.primaryGold,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                service.formattedDuration,
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
