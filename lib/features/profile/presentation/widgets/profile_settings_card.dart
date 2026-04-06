import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/locale/app_localizations.dart';
import '../../../../../core/locale/locale_cubit.dart';
import '../../../../../core/presentation/widgets/atoms/app_card.dart';
import '../../../../../core/presentation/widgets/atoms/app_text_field.dart';
import '../../../../../core/presentation/widgets/atoms/sheet_handle.dart';
import '../../../../../core/presentation/widgets/molecules/settings_menu_item.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../domain/entities/client_profile.dart';
import '../cubit/profile_cubit.dart';

class ProfileSettingsCard extends StatefulWidget {
  final ClientProfile profile;
  final String userId;

  const ProfileSettingsCard({
    super.key,
    required this.profile,
    required this.userId,
  });

  @override
  State<ProfileSettingsCard> createState() => _ProfileSettingsCardState();
}

class _ProfileSettingsCardState extends State<ProfileSettingsCard> {
  bool _notificationsEnabled = true;
  late String _selectedLanguage;

  static const _languages = ['PT-BR', 'EN', 'ES'];

  static const _localeMap = {
    'PT-BR': Locale('pt', 'BR'),
    'EN': Locale('en'),
    'ES': Locale('es'),
  };

  static String _localeToLabel(Locale locale) {
    if (locale.languageCode == 'en') return 'EN';
    if (locale.languageCode == 'es') return 'ES';
    return 'PT-BR';
  }

  @override
  void initState() {
    super.initState();
    _selectedLanguage = _localeToLabel(context.read<LocaleCubit>().state);
  }

  void _openPersonalDataDialog() {
    showDialog(
      context: context,
      builder: (_) => BlocProvider.value(
        value: context.read<ProfileCubit>(),
        child: _PersonalDataDialog(
            profile: widget.profile, userId: widget.userId),
      ),
    );
  }

  void _openPaymentMethods() {
    final l10n = AppLocalizations.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetCtx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SheetHandle(),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  l10n.paymentMethods,
                  style: const TextStyle(
                      color: AppColors.textLight,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 24),
              // Mock card visual
              Container(
                width: double.infinity,
                height: 100,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF2A2A2A), Color(0xFF1A1A1A)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white10),
                ),
                padding: const EdgeInsets.all(20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 44,
                      height: 32,
                      decoration: BoxDecoration(
                        color: AppColors.primaryGold.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                            color: AppColors.primaryGold.withValues(alpha: 0.4)),
                      ),
                      child: const Icon(Icons.credit_card_rounded,
                          color: AppColors.primaryGold, size: 20),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.noPaymentMethod,
                          style: const TextStyle(
                              color: AppColors.textMuted, fontSize: 12),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l10n.comingSoon,
                          style: const TextStyle(
                            color: AppColors.primaryGold,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pop(sheetCtx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(l10n.comingSoon),
                        backgroundColor: AppColors.cardBackground,
                      ),
                    );
                  },
                  icon: const Icon(Icons.add_rounded,
                      color: AppColors.primaryGold),
                  label: Text(l10n.addCard,
                      style: const TextStyle(color: AppColors.primaryGold)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.primaryGold),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openPrivacySecurity() {
    final l10n = AppLocalizations.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetCtx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 20),
            const SheetHandle(),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  l10n.privacySecurity,
                  style: const TextStyle(
                      color: AppColors.textLight,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.lock_outline_rounded,
                  color: AppColors.primaryGold),
              title: Text(l10n.changePassword,
                  style: const TextStyle(color: AppColors.textLight)),
              trailing: const Icon(Icons.chevron_right_rounded,
                  color: AppColors.textMuted),
              onTap: () {
                Navigator.pop(sheetCtx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(l10n.authRequired),
                    backgroundColor: AppColors.cardBackground,
                  ),
                );
              },
            ),
            const Divider(color: Colors.white10, height: 1, indent: 56),
            ListTile(
              leading: const Icon(Icons.download_rounded,
                  color: AppColors.primaryGold),
              title: Text(l10n.downloadMyData,
                  style: const TextStyle(color: AppColors.textLight)),
              trailing: const Icon(Icons.chevron_right_rounded,
                  color: AppColors.textMuted),
              onTap: () {
                Navigator.pop(sheetCtx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(l10n.comingSoon),
                    backgroundColor: AppColors.cardBackground,
                  ),
                );
              },
            ),
            const Divider(color: Colors.white10, height: 1, indent: 56),
            ListTile(
              leading: const Icon(Icons.delete_forever_rounded,
                  color: AppColors.error),
              title: Text(l10n.deleteAccount,
                  style: const TextStyle(color: AppColors.error)),
              trailing: const Icon(Icons.chevron_right_rounded,
                  color: AppColors.textMuted),
              onTap: () {
                Navigator.pop(sheetCtx);
                _confirmDeleteAccount();
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _confirmDeleteAccount() {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (ctx) => _ConfirmDialog(
        title: l10n.deleteAccountTitle,
        titleColor: AppColors.error,
        message: l10n.deleteAccountMessage,
        confirmLabel: l10n.delete,
        cancelLabel: l10n.cancel,
        onConfirm: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.authRequired),
              backgroundColor: AppColors.cardBackground,
            ),
          );
        },
      ),
    );
  }

  void _openLanguagePicker() {
    showDialog(
      context: context,
      builder: (_) => _LanguagePickerDialog(
        selectedLanguage: _selectedLanguage,
        languages: _languages,
        onSelected: (lang) {
          setState(() => _selectedLanguage = lang);
          context.read<LocaleCubit>().setLocale(_localeMap[lang]!);
        },
      ),
    );
  }

  void _confirmSignOut() {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (ctx) => _ConfirmDialog(
        title: l10n.signOutTitle,
        message: l10n.signOutMessage,
        confirmLabel: l10n.signOutConfirm,
        cancelLabel: l10n.cancel,
        onConfirm: () => context.read<AuthCubit>().signOut(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 16, 12, 4),
            child: Text(
              l10n.settings,
              style: const TextStyle(
                color: AppColors.textLight,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Divider(color: Colors.white10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              children: [
                SettingsMenuItem(
                  icon: Icons.person_outline_rounded,
                  label: l10n.personalData,
                  onTap: _openPersonalDataDialog,
                ),
                const Divider(color: Colors.white10, height: 1),
                SettingsMenuItem(
                  icon: Icons.notifications_none_rounded,
                  label: l10n.notifications,
                  trailing: Switch(
                    value: _notificationsEnabled,
                    onChanged: (val) =>
                        setState(() => _notificationsEnabled = val),
                    activeThumbColor: AppColors.primaryGold,
                    activeTrackColor:
                        AppColors.primaryGold.withValues(alpha: 0.3),
                  ),
                ),
                const Divider(color: Colors.white10, height: 1),
                SettingsMenuItem(
                  icon: Icons.credit_card_rounded,
                  label: l10n.paymentMethods,
                  onTap: _openPaymentMethods,
                ),
                const Divider(color: Colors.white10, height: 1),
                SettingsMenuItem(
                  icon: Icons.security_rounded,
                  label: l10n.privacySecurity,
                  onTap: _openPrivacySecurity,
                ),
                const Divider(color: Colors.white10, height: 1),
                SettingsMenuItem(
                  icon: Icons.language_rounded,
                  label: l10n.language,
                  trailing: Text(
                    _selectedLanguage,
                    style: const TextStyle(
                      color: AppColors.primaryGold,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: _openLanguagePicker,
                ),
                const Divider(color: Colors.white10, height: 1),
                SettingsMenuItem(
                  icon: Icons.logout_rounded,
                  label: l10n.signOut,
                  labelColor: AppColors.error,
                  trailing: const SizedBox.shrink(),
                  onTap: _confirmSignOut,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

// ── Confirm Dialog ────────────────────────────────────────────────────────────

class _ConfirmDialog extends StatelessWidget {
  final String title;
  final Color titleColor;
  final String message;
  final String confirmLabel;
  final String cancelLabel;
  final VoidCallback onConfirm;

  const _ConfirmDialog({
    required this.title,
    this.titleColor = AppColors.textLight,
    required this.message,
    required this.confirmLabel,
    required this.cancelLabel,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.cardBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(title,
          style: TextStyle(color: titleColor, fontWeight: FontWeight.bold)),
      content: Text(message,
          style: const TextStyle(color: AppColors.textMuted, fontSize: 13)),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(cancelLabel,
              style: const TextStyle(color: AppColors.textMuted)),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            onConfirm();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.error,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8)),
          ),
          child: Text(confirmLabel,
              style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}

// ── Language Picker Dialog ────────────────────────────────────────────────────

class _LanguagePickerDialog extends StatefulWidget {
  final String selectedLanguage;
  final List<String> languages;
  final ValueChanged<String> onSelected;

  const _LanguagePickerDialog({
    required this.selectedLanguage,
    required this.languages,
    required this.onSelected,
  });

  @override
  State<_LanguagePickerDialog> createState() => _LanguagePickerDialogState();
}

class _LanguagePickerDialogState extends State<_LanguagePickerDialog> {
  late String _current;

  @override
  void initState() {
    super.initState();
    _current = widget.selectedLanguage;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      backgroundColor: AppColors.cardBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        l10n.language,
        style: const TextStyle(
            color: AppColors.textLight, fontWeight: FontWeight.bold),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: widget.languages
            .map((lang) => RadioListTile<String>(
                  value: lang,
                  // ignore: deprecated_member_use
                  groupValue: _current,
                  activeColor: AppColors.primaryGold,
                  title: Text(lang,
                      style: const TextStyle(color: AppColors.textLight)),
                  // ignore: deprecated_member_use
                  onChanged: (val) {
                    setState(() => _current = val!);
                    widget.onSelected(val!);
                    Navigator.of(context).pop();
                  },
                ))
            .toList(),
      ),
    );
  }
}

// ── Personal Data Dialog ──────────────────────────────────────────────────────

class _PersonalDataDialog extends StatefulWidget {
  final ClientProfile profile;
  final String userId;

  const _PersonalDataDialog({required this.profile, required this.userId});

  @override
  State<_PersonalDataDialog> createState() => _PersonalDataDialogState();
}

class _PersonalDataDialogState extends State<_PersonalDataDialog> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _emailCtrl;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.profile.name);
    _emailCtrl = TextEditingController(text: widget.profile.email);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    if (!mounted) return;
    final ok = await context.read<ProfileCubit>().updatePersonalData(
          widget.userId,
          name: _nameCtrl.text.trim(),
          email: _emailCtrl.text.trim(),
        );
    if (!mounted) return;
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(ok ? l10n.dataUpdated : l10n.saveError),
        backgroundColor: ok ? AppColors.primaryGold : AppColors.error,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      backgroundColor: AppColors.cardBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        l10n.personalData,
        style: const TextStyle(
            color: AppColors.textLight, fontWeight: FontWeight.bold),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppTextField(label: l10n.name, controller: _nameCtrl),
          const SizedBox(height: 14),
          AppTextField(
            label: l10n.email,
            controller: _emailCtrl,
            keyboardType: TextInputType.emailAddress,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel,
              style: const TextStyle(color: AppColors.textMuted)),
        ),
        ElevatedButton(
          onPressed: _save,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryGold,
            foregroundColor: AppColors.background,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8)),
          ),
          child: Text(l10n.save,
              style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}
