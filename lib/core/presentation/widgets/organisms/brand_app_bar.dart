import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

/// The branded AppBar used on every shell page.
/// Pass [onMenuTap] to open the drawer,
/// and [actions] for page-specific trailing widgets.
class BrandAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onMenuTap;
  final List<Widget>? actions;

  const BrandAppBar({
    super.key,
    required this.onMenuTap,
    this.actions,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.menu_rounded, color: AppColors.primaryGold),
        onPressed: onMenuTap,
      ),
      title: const Text(
        'Corte & Barba',
        style: TextStyle(
          color: AppColors.primaryGold,
          fontWeight: FontWeight.w900,
          fontSize: 20,
          letterSpacing: -0.5,
        ),
      ),
      centerTitle: true,
      actions: actions,
    );
  }
}
