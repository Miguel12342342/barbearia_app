import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/locale/app_localizations.dart';
import '../../../../../core/presentation/widgets/atoms/app_card.dart';
import '../../../../../core/presentation/widgets/atoms/app_text_field.dart';
import '../../../../../core/presentation/widgets/atoms/gold_primary_button.dart';
import '../../../../../core/presentation/widgets/atoms/sheet_handle.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../domain/entities/client_profile.dart';
import '../cubit/profile_cubit.dart';

class StylePreferencesCard extends StatelessWidget {
  final ClientProfile profile;
  final String userId;

  const StylePreferencesCard({
    super.key,
    required this.profile,
    required this.userId,
  });

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
    return AppCard(
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
            '${l10n.lastService}: ${l10n.lastServiceLabel(prefs.lastServiceDate)}',
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

// ── Pref Section ──────────────────────────────────────────────────────────────

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
            children: lines.indexed
                .map((e) => Text(
                      e.$2,
                      style: TextStyle(
                        color: e.$1 == 0
                            ? AppColors.textLight
                            : AppColors.textMuted,
                        fontSize: e.$1 == 0 ? 14 : 12,
                      ),
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }
}

// ── Tags Section ──────────────────────────────────────────────────────────────

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

// ── Edit Sheet ────────────────────────────────────────────────────────────────

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
    _productsCtrl = TextEditingController(text: p.favoriteProducts.join(', '));
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
            const SheetHandle(),
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
            AppTextField(label: l10n.haircutLabel, controller: _haircutCtrl),
            const SizedBox(height: 14),
            AppTextField(
                label: l10n.beardStyleLabel, controller: _beardStyleCtrl),
            const SizedBox(height: 14),
            AppTextField(
                label: l10n.beardContourLabel, controller: _beardContourCtrl),
            const SizedBox(height: 14),
            AppTextField(
              label: l10n.favoriteProductsLabel,
              controller: _productsCtrl,
              hint: l10n.separateByComma,
            ),
            const SizedBox(height: 14),
            AppTextField(
                label: l10n.preferredBarberLabel, controller: _barberCtrl),
            const SizedBox(height: 24),
            GoldPrimaryButton(label: l10n.save, onPressed: _save),
          ],
        ),
      ),
    );
  }
}
