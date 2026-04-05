import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/services/notification_service.dart';
import '../../../../injection_container.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../loyalty/presentation/cubit/loyalty_cubit.dart';
import '../../../scheduling/presentation/bloc/booking_bloc.dart';
import '../../../scheduling/presentation/bloc/booking_event.dart';
import '../../../scheduling/presentation/cubit/booking_form_cubit.dart';

class ShellPage extends StatelessWidget {
  final Widget child;

  const ShellPage({super.key, required this.child});

  static final scaffoldKey = GlobalKey<ScaffoldState>();

  static int _locationToIndex(String location) {
    if (location.startsWith('/booking')) return 1;
    if (location.startsWith('/loyalty')) return 2;
    if (location.startsWith('/history')) return 2;
    if (location.startsWith('/profile')) return 3;
    return 0;
  }

  static const _routes = ['/home', '/booking', '/loyalty', '/profile'];

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<BookingFormCubit>()),
        BlocProvider(create: (_) => sl<BookingBloc>()),
      ],
      child: _ShellScaffold(child: child),
    );
  }
}

// ── Shell Scaffold (StatefulWidget to trigger data loading once) ───────────────

class _ShellScaffold extends StatefulWidget {
  final Widget child;
  const _ShellScaffold({required this.child});

  @override
  State<_ShellScaffold> createState() => _ShellScaffoldState();
}

class _ShellScaffoldState extends State<_ShellScaffold> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final userId = context.read<AuthCubit>().state.userId ?? '';
      if (userId.isEmpty) return;
      context.read<BookingBloc>().add(LoadAppointmentsEvent(userId));
      context.read<LoyaltyCubit>().load(userId);
      sl<NotificationService>().saveToken(userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final currentIndex = ShellPage._locationToIndex(location);

    return Scaffold(
      key: ShellPage.scaffoldKey,
      backgroundColor: AppColors.background,
      drawer: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, authState) {
          final name = authState.displayName?.split(' ').first ??
              authState.email?.split('@').first ??
              '';
          return _AppDrawer(userName: name);
        },
      ),
      body: widget.child,
      floatingActionButton: currentIndex == 0 || currentIndex == 1
          ? FloatingActionButton(
              onPressed: () => context.go('/booking'),
              backgroundColor: AppColors.primaryGold,
              foregroundColor: AppColors.background,
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.add_rounded, size: 30),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: _BottomNav(
        currentIndex: currentIndex,
        onTap: (index) => context.go(ShellPage._routes[index]),
      ),
    );
  }
}

// ── Drawer ────────────────────────────────────────────────────────────────────

class _AppDrawer extends StatelessWidget {
  final String userName;

  const _AppDrawer({required this.userName});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.cardBackground,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: AppColors.background,
                    child: Icon(
                      Icons.person_rounded,
                      color: AppColors.textMuted,
                      size: 34,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    userName,
                    style: const TextStyle(
                      color: AppColors.textLight,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(color: AppColors.background, thickness: 1),
            _DrawerItem(
              icon: Icons.home_rounded,
              label: 'Home',
              onTap: () {
                Navigator.of(context).pop();
                context.go('/home');
              },
            ),
            _DrawerItem(
              icon: Icons.calendar_month_rounded,
              label: 'Agendamentos',
              onTap: () {
                Navigator.of(context).pop();
                context.go('/booking');
              },
            ),
            _DrawerItem(
              icon: Icons.emoji_events_rounded,
              label: 'Fidelidade',
              onTap: () {
                Navigator.of(context).pop();
                context.go('/loyalty');
              },
            ),
            _DrawerItem(
              icon: Icons.person_rounded,
              label: 'Perfil',
              onTap: () {
                Navigator.of(context).pop();
                context.go('/profile');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primaryGold),
      title: Text(
        label,
        style: const TextStyle(
          color: AppColors.textLight,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
    );
  }
}

// ── Bottom Nav ────────────────────────────────────────────────────────────────

class _BottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _BottomNav({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.5),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _NavItem(
                index: 0,
                icon: Icons.home_rounded,
                label: 'Home',
                currentIndex: currentIndex,
                onTap: onTap),
            _NavItem(
                index: 1,
                icon: Icons.calendar_month_rounded,
                label: 'Agendar',
                currentIndex: currentIndex,
                onTap: onTap),
            _NavItem(
                index: 2,
                icon: Icons.emoji_events_rounded,
                label: 'Fidelidade',
                currentIndex: currentIndex,
                onTap: onTap),
            _NavItem(
                index: 3,
                icon: Icons.person_rounded,
                label: 'Perfil',
                currentIndex: currentIndex,
                onTap: onTap),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final int index;
  final IconData icon;
  final String label;
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _NavItem({
    required this.index,
    required this.icon,
    required this.label,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = index == currentIndex;
    return Semantics(
      label: label,
      button: true,
      selected: isActive,
      child: GestureDetector(
        onTap: () => onTap(index),
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: isActive
              ? const EdgeInsets.symmetric(horizontal: 20, vertical: 12)
              : const EdgeInsets.all(12),
          decoration: isActive
              ? BoxDecoration(
                  color: AppColors.primaryGold,
                  borderRadius: BorderRadius.circular(12),
                )
              : null,
          child: Icon(
            icon,
            color: isActive ? AppColors.background : AppColors.textMuted,
            size: 26,
          ),
        ),
      ),
    );
  }
}
