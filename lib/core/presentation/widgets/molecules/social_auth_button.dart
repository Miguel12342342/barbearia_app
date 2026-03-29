import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

enum SocialProvider { google, apple }

class SocialAuthButton extends StatelessWidget {
  final SocialProvider provider;
  final VoidCallback? onPressed;

  const SocialAuthButton({
    super.key,
    required this.provider,
    this.onPressed,
  });

  String get _label =>
      provider == SocialProvider.google ? 'GOOGLE' : 'APPLE';

  IconData get _icon =>
      provider == SocialProvider.apple ? Icons.apple : Icons.g_mobiledata;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(_icon, color: AppColors.textLight, size: 22),
              const SizedBox(width: 10),
              Text(
                _label,
                style: const TextStyle(
                  color: AppColors.textLight,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
