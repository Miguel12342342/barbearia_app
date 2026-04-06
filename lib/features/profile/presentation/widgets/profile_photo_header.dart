import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../core/locale/app_localizations.dart';
import '../../../../../core/presentation/widgets/atoms/sheet_handle.dart';
import '../../../../../core/presentation/widgets/atoms/status_pill.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../domain/entities/client_profile.dart';
import '../cubit/profile_cubit.dart';

class ProfilePhotoHeader extends StatelessWidget {
  final ClientProfile profile;
  final String userId;

  const ProfilePhotoHeader({
    super.key,
    required this.profile,
    required this.userId,
  });

  void _onPhotoTap(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            const SheetHandle(),
            const SizedBox(height: 20),
            Text(
              l10n.photoPickerTitle,
              style: const TextStyle(
                color: AppColors.textLight,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.camera_alt_rounded,
                  color: AppColors.primaryGold),
              title: Text(l10n.takePhoto,
                  style: const TextStyle(color: AppColors.textLight)),
              onTap: () async {
                Navigator.pop(context);
                final cubit = context.read<ProfileCubit>();
                final file = await ImagePicker().pickImage(
                  source: ImageSource.camera,
                  maxWidth: 512,
                  maxHeight: 512,
                  imageQuality: 80,
                );
                if (file == null) return;
                final bytes = await file.readAsBytes();
                await cubit.updatePhoto(userId, bytes);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_rounded,
                  color: AppColors.primaryGold),
              title: Text(l10n.chooseFromGallery,
                  style: const TextStyle(color: AppColors.textLight)),
              onTap: () async {
                Navigator.pop(context);
                final cubit = context.read<ProfileCubit>();
                final file = await ImagePicker().pickImage(
                  source: ImageSource.gallery,
                  maxWidth: 512,
                  maxHeight: 512,
                  imageQuality: 80,
                );
                if (file == null) return;
                final bytes = await file.readAsBytes();
                await cubit.updatePhoto(userId, bytes);
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => _onPhotoTap(context),
          child: Stack(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: profile.photoUrl != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          profile.photoUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stack) => const Icon(
                            Icons.person_rounded,
                            color: AppColors.textMuted,
                            size: 48,
                          ),
                        ),
                      )
                    : const Icon(
                        Icons.person_rounded,
                        color: AppColors.textMuted,
                        size: 48,
                      ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryGold,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.edit_rounded,
                      color: AppColors.background, size: 16),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        StatusPill(
          label: profile.isPremium
              ? AppLocalizations.of(context).memberPremium
              : AppLocalizations.of(context).memberStandard,
          variant: PillVariant.vip,
        ),
        const SizedBox(height: 12),
        Text(
          profile.name,
          style: const TextStyle(
            color: AppColors.textLight,
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          AppLocalizations.of(context).memberSinceLabel(profile.memberSince),
          style: const TextStyle(color: AppColors.textMuted, fontSize: 13),
        ),
      ],
    );
  }
}
