import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/router/app_router.dart' show markOnboardingDone;
import '../../../../core/theme/app_colors.dart';

const _kOnboardingKey = 'onboarding_complete';

Future<bool> hasSeenOnboarding() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool(_kOnboardingKey) ?? false;
}

Future<void> markOnboardingComplete() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool(_kOnboardingKey, true);
}

// ── Data ─────────────────────────────────────────────────────────────────────

class _OnboardingStep {
  final IconData icon;
  final String title;
  final String subtitle;

  const _OnboardingStep({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
}

const _steps = [
  _OnboardingStep(
    icon: Icons.auto_awesome_rounded,
    title: 'Bem-vindo ao\nCorte & Barba',
    subtitle:
        'Seu atelier de estilo pessoal.\nExperiência premium, do agendamento ao acabamento.',
  ),
  _OnboardingStep(
    icon: Icons.calendar_month_rounded,
    title: 'Agende com\nfacilidade',
    subtitle:
        'Escolha o serviço, o mestre e o horário.\nTudo em poucos toques, sem filas.',
  ),
  _OnboardingStep(
    icon: Icons.emoji_events_rounded,
    title: 'Fidelidade\nrecompensada',
    subtitle:
        'A cada corte, você acumula pontos.\nDesbloqueie benefícios exclusivos e serviços gratuitos.',
  ),
];

// ── Page ──────────────────────────────────────────────────────────────────────

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final _controller = PageController();
  int _current = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _next() {
    if (_current < _steps.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      _finish();
    }
  }

  Future<void> _finish() async {
    await markOnboardingComplete();
    markOnboardingDone(); // atualiza flag in-memory do router
    if (mounted) context.go('/auth');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Skip
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: _finish,
                child: const Text(
                  'Pular',
                  style: TextStyle(color: AppColors.textMuted, fontSize: 14),
                ),
              ),
            ),
            // Pages
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _steps.length,
                onPageChanged: (i) => setState(() => _current = i),
                itemBuilder: (_, i) => _StepPage(step: _steps[i]),
              ),
            ),
            // Dots
            _Dots(count: _steps.length, current: _current),
            const SizedBox(height: 32),
            // Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _next,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGold,
                    foregroundColor: AppColors.background,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    _current == _steps.length - 1 ? 'COMEÇAR' : 'PRÓXIMO',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

// ── Step Page ─────────────────────────────────────────────────────────────────

class _StepPage extends StatelessWidget {
  final _OnboardingStep step;
  const _StepPage({required this.step});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(32),
            ),
            child: Icon(step.icon, color: AppColors.primaryGold, size: 56),
          ),
          const SizedBox(height: 48),
          Text(
            step.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.textLight,
              fontSize: 32,
              fontWeight: FontWeight.w900,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            step.subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.textMuted,
              fontSize: 15,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Dots ──────────────────────────────────────────────────────────────────────

class _Dots extends StatelessWidget {
  final int count;
  final int current;
  const _Dots({required this.count, required this.current});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final isActive = i == current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: isActive ? AppColors.primaryGold : AppColors.textMuted,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}
