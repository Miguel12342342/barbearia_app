import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/locale/app_localizations.dart';
import '../../../../core/locale/locale_cubit.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/presentation/widgets/atoms/gold_progress_bar.dart';
import '../../../../core/presentation/widgets/atoms/status_pill.dart';
import '../../../../core/presentation/widgets/molecules/settings_menu_item.dart';
import '../../../profile/domain/entities/client_profile.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';
import '../../../home/presentation/pages/shell_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  static const _userId = AppConstants.kDevUserId;

  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().load(_userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu_rounded, color: AppColors.primaryGold),
          onPressed: () => ShellPage.scaffoldKey.currentState?.openDrawer(),
        ),
        title: const Text(
          'Corte & Barba',
          style: TextStyle(
            color: AppColors.primaryGold,
            fontWeight: FontWeight.w900,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state.status == ProfileStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primaryGold),
            );
          }
          if (state.status == ProfileStatus.error) {
            return Center(
              child: Text(state.errorMessage,
                  style: const TextStyle(color: AppColors.error)),
            );
          }
          final profile = state.profile;
          if (profile == null) return const SizedBox.shrink();

          return Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    _PhotoHeader(profile: profile, userId: _userId),
                    const SizedBox(height: 20),
                    _StylePreferencesCard(profile: profile, userId: _userId),
                    const SizedBox(height: 16),
                    _NextRewardCard(profile: profile),
                    const SizedBox(height: 16),
                    _SettingsCard(profile: profile, userId: _userId),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
              if (state.status == ProfileStatus.saving)
                const _SavingOverlay(),
            ],
          );
        },
      ),
    );
  }
}

// ── Photo Header ──────────────────────────────────────────────────────────────

class _PhotoHeader extends StatelessWidget {
  final ClientProfile profile;
  final String userId;

  const _PhotoHeader({required this.profile, required this.userId});

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
            _SheetHandle(),
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
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(l10n.cameraComingSoon),
                    backgroundColor: AppColors.cardBackground,
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_rounded,
                  color: AppColors.primaryGold),
              title: Text(l10n.chooseFromGallery,
                  style: const TextStyle(color: AppColors.textLight)),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(l10n.galleryComingSoon),
                    backgroundColor: AppColors.cardBackground,
                  ),
                );
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
                          errorBuilder: (ctx, e, stack) => const Icon(
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
          profile.memberSinceFormatted,
          style: const TextStyle(color: AppColors.textMuted, fontSize: 13),
        ),
      ],
    );
  }
}

// ── Style Preferences Card ────────────────────────────────────────────────────

class _StylePreferencesCard extends StatelessWidget {
  final ClientProfile profile;
  final String userId;

  const _StylePreferencesCard({required this.profile, required this.userId});

  void _openEditSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.cardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => BlocProvider.value(
        value: context.read<ProfileCubit>(),
        child: _StylePrefsEditSheet(profile: profile, userId: userId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final prefs = profile.stylePreferences;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.stylePreferences,
                style: const TextStyle(
                  color: AppColors.textLight,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: () => _openEditSheet(context),
                child: const Icon(Icons.auto_fix_high_rounded,
                    color: AppColors.primaryGold, size: 22),
              ),
            ],
          ),
          const SizedBox(height: 18),
          _PrefSection(label: l10n.haircutLabel, lines: [
            prefs.haircut,
            '${l10n.lastService}: ${prefs.lastServiceLabel}',
          ]),
          const SizedBox(height: 14),
          _PrefSection(label: l10n.beardStyleLabel, lines: [
            prefs.beardStyle,
            '${l10n.contour}: ${prefs.beardContour}',
          ]),
          const SizedBox(height: 14),
          _TagsSection(
              label: l10n.favoriteProductsLabel,
              tags: prefs.favoriteProducts),
          const SizedBox(height: 14),
          _PrefSection(
              label: l10n.preferredBarberLabel,
              lines: [prefs.preferredBarberName]),
        ],
      ),
    );
  }
}

class _PrefSection extends StatelessWidget {
  final String label;
  final List<String> lines;

  const _PrefSection({required this.label, required this.lines});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.primaryGold,
            fontSize: 9,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: lines
                .mapIndexed((i, line) => Text(
                      line,
                      style: TextStyle(
                        color: i == 0
                            ? AppColors.textLight
                            : AppColors.textMuted,
                        fontSize: i == 0 ? 14 : 12,
                      ),
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }
}

class _TagsSection extends StatelessWidget {
  final String label;
  final List<String> tags;

  const _TagsSection({required this.label, required this.tags});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.primaryGold,
            fontSize: 9,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: tags
              .map((tag) => Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white12),
                    ),
                    child: Text(tag,
                        style: const TextStyle(
                            color: AppColors.textLight, fontSize: 13)),
                  ))
              .toList(),
        ),
      ],
    );
  }
}

// ── Style Prefs Edit Sheet ────────────────────────────────────────────────────

class _StylePrefsEditSheet extends StatefulWidget {
  final ClientProfile profile;
  final String userId;

  const _StylePrefsEditSheet({required this.profile, required this.userId});

  @override
  State<_StylePrefsEditSheet> createState() => _StylePrefsEditSheetState();
}

class _StylePrefsEditSheetState extends State<_StylePrefsEditSheet> {
  late final TextEditingController _haircutCtrl;
  late final TextEditingController _beardStyleCtrl;
  late final TextEditingController _beardContourCtrl;
  late final TextEditingController _productsCtrl;
  late final TextEditingController _barberCtrl;

  @override
  void initState() {
    super.initState();
    final p = widget.profile.stylePreferences;
    _haircutCtrl = TextEditingController(text: p.haircut);
    _beardStyleCtrl = TextEditingController(text: p.beardStyle);
    _beardContourCtrl = TextEditingController(text: p.beardContour);
    _productsCtrl =
        TextEditingController(text: p.favoriteProducts.join(', '));
    _barberCtrl = TextEditingController(text: p.preferredBarberName);
  }

  @override
  void dispose() {
    _haircutCtrl.dispose();
    _beardStyleCtrl.dispose();
    _beardContourCtrl.dispose();
    _productsCtrl.dispose();
    _barberCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    final products = _productsCtrl.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    final updated = widget.profile.stylePreferences.copyWith(
      haircut: _haircutCtrl.text.trim(),
      beardStyle: _beardStyleCtrl.text.trim(),
      beardContour: _beardContourCtrl.text.trim(),
      favoriteProducts: products,
      preferredBarberName: _barberCtrl.text.trim(),
    );

    if (!mounted) return;
    final ok = await context
        .read<ProfileCubit>()
        .updateStylePreferences(widget.userId, updated);

    if (!mounted) return;
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(ok ? l10n.preferencesSaved : l10n.saveError),
        backgroundColor: ok ? AppColors.primaryGold : AppColors.error,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _SheetHandle(),
            const SizedBox(height: 16),
            Text(
              l10n.editStylePreferences,
              style: const TextStyle(
                color: AppColors.textLight,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            _SheetField(
                label: l10n.haircutLabel, controller: _haircutCtrl),
            const SizedBox(height: 14),
            _SheetField(
                label: l10n.beardStyleLabel, controller: _beardStyleCtrl),
            const SizedBox(height: 14),
            _SheetField(
                label: l10n.beardContourLabel,
                controller: _beardContourCtrl),
            const SizedBox(height: 14),
            _SheetField(
              label: l10n.favoriteProductsLabel,
              controller: _productsCtrl,
              hint: l10n.separateByComma,
            ),
            const SizedBox(height: 14),
            _SheetField(
                label: l10n.preferredBarberLabel, controller: _barberCtrl),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGold,
                  foregroundColor: AppColors.background,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(
                  l10n.save,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SheetField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? hint;

  const _SheetField({
    required this.label,
    required this.controller,
    this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.primaryGold,
            fontSize: 9,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          style: const TextStyle(color: AppColors.textLight, fontSize: 14),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle:
                const TextStyle(color: AppColors.textMuted, fontSize: 13),
            filled: true,
            fillColor: AppColors.background,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          ),
        ),
      ],
    );
  }
}

// ── Next Reward Card ──────────────────────────────────────────────────────────

class _NextRewardCard extends StatelessWidget {
  final ClientProfile profile;

  const _NextRewardCard({required this.profile});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.nextReward,
            style: const TextStyle(
              color: AppColors.textLight,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 14),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '8 de 10 cortes realizados',
                style: TextStyle(color: AppColors.textMuted, fontSize: 13),
              ),
              Text(
                '80%',
                style: TextStyle(
                  color: AppColors.primaryGold,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const GoldProgressBar(progress: 0.8),
          const SizedBox(height: 12),
          RichText(
            text: const TextSpan(
              style: TextStyle(color: AppColors.textMuted, fontSize: 12),
              children: [
                TextSpan(
                    text: 'Faltam apenas 2 visitas para você ganhar uma '),
                TextSpan(
                  text: 'Limpeza de Pele Express',
                  style: TextStyle(
                    color: AppColors.primaryGold,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextSpan(text: '.'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Settings Card ─────────────────────────────────────────────────────────────

class _SettingsCard extends StatefulWidget {
  final ClientProfile profile;
  final String userId;

  const _SettingsCard({required this.profile, required this.userId});

  @override
  State<_SettingsCard> createState() => _SettingsCardState();
}

class _SettingsCardState extends State<_SettingsCard> {
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
    _selectedLanguage =
        _localeToLabel(context.read<LocaleCubit>().state);
  }

  // ── Dados Pessoais ──────────────────────────────────────────────────────────
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

  // ── Métodos de Pagamento ────────────────────────────────────────────────────
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
              _SheetHandle(),
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
              const SizedBox(height: 32),
              const Icon(Icons.credit_card_off_rounded,
                  color: AppColors.textMuted, size: 48),
              const SizedBox(height: 12),
              Text(
                l10n.noPaymentMethod,
                style:
                    const TextStyle(color: AppColors.textMuted, fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
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
                      style:
                          const TextStyle(color: AppColors.primaryGold)),
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

  // ── Privacidade e Segurança ─────────────────────────────────────────────────
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
            _SheetHandle(),
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
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(l10n.deleteAccountTitle,
            style: const TextStyle(
                color: AppColors.error, fontWeight: FontWeight.bold)),
        content: Text(
          l10n.deleteAccountMessage,
          style:
              const TextStyle(color: AppColors.textMuted, fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel,
                style: const TextStyle(color: AppColors.textMuted)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(l10n.authRequired),
                  backgroundColor: AppColors.cardBackground,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: Text(l10n.delete,
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  // ── Idioma ──────────────────────────────────────────────────────────────────
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

  // ── Sair da Conta ───────────────────────────────────────────────────────────
  void _confirmSignOut() {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(l10n.signOutTitle,
            style: const TextStyle(
                color: AppColors.textLight,
                fontWeight: FontWeight.bold)),
        content: Text(
          l10n.signOutMessage,
          style: const TextStyle(color: AppColors.textMuted),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel,
                style: const TextStyle(color: AppColors.textMuted)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.go('/auth');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: Text(l10n.signOutConfirm,
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
      ),
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
                  // ignore: deprecated_member_use
                  value: lang,
                  // ignore: deprecated_member_use
                  groupValue: _current,
                  activeColor: AppColors.primaryGold,
                  title: Text(lang,
                      style:
                          const TextStyle(color: AppColors.textLight)),
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
          _DialogField(label: l10n.name, controller: _nameCtrl),
          const SizedBox(height: 14),
          _DialogField(
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

class _DialogField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType keyboardType;

  const _DialogField({
    required this.label,
    required this.controller,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(color: AppColors.textLight),
      decoration: InputDecoration(
        labelText: label,
        labelStyle:
            const TextStyle(color: AppColors.textMuted, fontSize: 13),
        filled: true,
        fillColor: AppColors.background,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      ),
    );
  }
}

// ── Saving Overlay ────────────────────────────────────────────────────────────

class _SavingOverlay extends StatelessWidget {
  const _SavingOverlay();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black45,
      child: const Center(
        child: CircularProgressIndicator(color: AppColors.primaryGold),
      ),
    );
  }
}

// ── Sheet Handle ──────────────────────────────────────────────────────────────

class _SheetHandle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: Colors.white24,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}

// ── Extension ─────────────────────────────────────────────────────────────────

extension _IterableIndexed<T> on Iterable<T> {
  Iterable<R> mapIndexed<R>(R Function(int index, T item) f) {
    var i = 0;
    return map((item) => f(i++, item));
  }
}
