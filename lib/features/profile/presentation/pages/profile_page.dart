import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/presentation/widgets/organisms/brand_app_bar.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../home/presentation/pages/shell_page.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';
import '../widgets/next_reward_card.dart';
import '../widgets/profile_photo_header.dart';
import '../widgets/profile_settings_card.dart';
import '../widgets/style_preferences_card.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String get _userId => context.read<AuthCubit>().state.userId ?? '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final uid = _userId;
      if (uid.isNotEmpty) context.read<ProfileCubit>().load(uid);
    });
  }

  void _loadIfNeeded(AuthState authState) {
    final uid = authState.userId ?? '';
    if (uid.isEmpty) return;
    final profileState = context.read<ProfileCubit>().state;
    if (profileState.status == ProfileStatus.initial ||
        profileState.status == ProfileStatus.error) {
      context.read<ProfileCubit>().load(uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listenWhen: (prev, curr) =>
          prev.userId != curr.userId && curr.userId != null,
      listener: (_, authState) => _loadIfNeeded(authState),
      child: Scaffold(
      backgroundColor: AppColors.background,
      appBar: BrandAppBar(
        onMenuTap: () => ShellPage.scaffoldKey.currentState?.openDrawer(),
      ),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state.status == ProfileStatus.initial ||
              state.status == ProfileStatus.loading) {
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
                    ProfilePhotoHeader(profile: profile, userId: _userId),
                    const SizedBox(height: 20),
                    StylePreferencesCard(profile: profile, userId: _userId),
                    const SizedBox(height: 16),
                    const NextRewardCard(),
                    const SizedBox(height: 16),
                    ProfileSettingsCard(profile: profile, userId: _userId),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
              if (state.status == ProfileStatus.saving)
                Container(
                  color: Colors.black45,
                  child: const Center(
                    child: CircularProgressIndicator(
                        color: AppColors.primaryGold),
                  ),
                ),
            ],
          );
        },
      ),
      ),
    );
  }
}
