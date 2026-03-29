import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/presentation/widgets/atoms/gold_primary_button.dart';
import '../../../../core/presentation/widgets/atoms/app_divider_with_text.dart';
import '../../../../core/presentation/widgets/molecules/social_auth_button.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),
              // Logo
              const Text(
                'C&B',
                style: TextStyle(
                  color: AppColors.primaryGold,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 32),
              // Tab bar
              _buildTabBar(),
              const SizedBox(height: 32),
              // Tab content
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildLoginForm(),
                    _buildRegisterForm(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return TabBar(
      controller: _tabController,
      isScrollable: false,
      dividerColor: Colors.transparent,
      indicatorColor: AppColors.primaryGold,
      indicatorWeight: 2,
      labelStyle: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w900,
        letterSpacing: -0.5,
      ),
      unselectedLabelStyle: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w400,
      ),
      labelColor: AppColors.textLight,
      unselectedLabelColor: AppColors.textMuted,
      tabs: const [
        Tab(text: 'Entrar'),
        Tab(text: 'Criar Conta'),
      ],
    );
  }

  Widget _buildLoginForm() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          const Text(
            'Bem-vindo de volta ao seu atelier de estilo pessoal. Identifique-se para gerenciar seus horários.',
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 14,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 36),
          _buildInputField(
            label: 'EMAIL PROFISSIONAL',
            hint: 'seu@email.com',
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 28),
          _buildPasswordField(),
          const SizedBox(height: 36),
          GoldPrimaryButton(
            label: 'ACESSAR CONTA',
            trailingIcon: const Icon(
              Icons.arrow_forward_rounded,
              size: 18,
              color: AppColors.background,
            ),
            onPressed: () => _onLogin(),
          ),
          const SizedBox(height: 36),
          const AppDividerWithText(text: 'OU CONTINUE COM'),
          const SizedBox(height: 24),
          Row(
            children: [
              SocialAuthButton(
                provider: SocialProvider.google,
                onPressed: () {},
              ),
              const SizedBox(width: 12),
              SocialAuthButton(
                provider: SocialProvider.apple,
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 32),
          Center(
            child: RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                style: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 10,
                  letterSpacing: 0.8,
                ),
                children: [
                  TextSpan(text: 'AO ENTRAR, VOCÊ CONCORDA COM NOSSOS\n'),
                  TextSpan(
                    text: 'TERMOS DE SERVIÇO',
                    style: TextStyle(
                      color: AppColors.primaryGold,
                      decoration: TextDecoration.underline,
                      decorationColor: AppColors.primaryGold,
                    ),
                  ),
                  TextSpan(text: ' E '),
                  TextSpan(
                    text: 'PRIVACIDADE',
                    style: TextStyle(
                      color: AppColors.primaryGold,
                      decoration: TextDecoration.underline,
                      decorationColor: AppColors.primaryGold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildRegisterForm() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          const Text(
            'Crie sua conta e desbloqueie uma experiência premium de barbearia.',
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 14,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 36),
          _buildInputField(
            label: 'NOME COMPLETO',
            hint: 'Seu nome',
            controller: _nameController,
          ),
          const SizedBox(height: 28),
          _buildInputField(
            label: 'EMAIL',
            hint: 'seu@email.com',
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 28),
          _buildPasswordField(),
          const SizedBox(height: 36),
          GoldPrimaryButton(
            label: 'CRIAR CONTA',
            trailingIcon: const Icon(
              Icons.arrow_forward_rounded,
              size: 18,
              color: AppColors.background,
            ),
            onPressed: () {},
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required String hint,
    required TextEditingController controller,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.primaryGold,
            fontSize: 10,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(color: AppColors.textLight, fontSize: 15),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 15),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white24),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.primaryGold, width: 1.5),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 8),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'SENHA',
              style: TextStyle(
                color: AppColors.primaryGold,
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: const Text(
                'ESQUECEU?',
                style: TextStyle(
                  color: AppColors.primaryGold,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _passwordController,
          obscureText: _obscurePassword,
          style: const TextStyle(color: AppColors.textLight, fontSize: 15),
          decoration: InputDecoration(
            hintText: '••••••••',
            hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 15),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white24),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.primaryGold, width: 1.5),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 8),
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility_off : Icons.visibility,
                color: AppColors.textMuted,
                size: 18,
              ),
              onPressed: () =>
                  setState(() => _obscurePassword = !_obscurePassword),
            ),
          ),
        ),
      ],
    );
  }

  void _onLogin() {
    // Placeholder: replace with AuthBloc event when firebase_auth is wired
    if (_emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty) {
      context.go('/home');
    }
  }
}
