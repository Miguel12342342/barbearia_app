import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/locale/app_localizations.dart';

class HomeHeader extends StatelessWidget {
  final String userName;

  const HomeHeader({
    super.key,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${l10n.welcomeBack}, ${userName.toUpperCase()}',
            style: const TextStyle(
              color: AppColors.primaryGold,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 2.0,
            ),
          ),
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 36,
                height: 1.1,
                fontWeight: FontWeight.w900,
                color: AppColors.textLight,
              ),
              children: [
                TextSpan(text: '${l10n.defineYour}\n'),
                TextSpan(
                  text: '${l10n.signature}\n',
                  style: const TextStyle(color: AppColors.primaryGold),
                ),
                TextSpan(text: l10n.look),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
