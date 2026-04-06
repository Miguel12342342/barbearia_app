import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/pages/auth_page.dart';
import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/home/presentation/pages/shell_page.dart';
import '../../features/scheduling/domain/entities/appointment.dart';
import '../../features/scheduling/presentation/pages/booking_confirmation_page.dart';
import '../../features/scheduling/presentation/pages/booking_page.dart';
import '../../features/scheduling/presentation/pages/history_page.dart';
import '../../features/loyalty/presentation/pages/loyalty_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';

// Bridges Firebase auth stream into a GoRouter-compatible Listenable.
// Also tracks whether the first auth event has been received (resolved).
class _AuthRefreshStream extends ChangeNotifier {
  late final StreamSubscription<User?> _sub;
  bool resolved = false;

  _AuthRefreshStream(Stream<User?> stream) {
    _sub = stream.listen((_) {
      resolved = true;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}

final _authStream =
    _AuthRefreshStream(FirebaseAuth.instance.authStateChanges());

bool _onboardingChecked = false;
bool _onboardingComplete = false;

Future<void> initRouter() async {
  _onboardingComplete = await hasSeenOnboarding();
  _onboardingChecked = true;
}

/// Called by OnboardingPage after the user finishes — updates the in-memory
/// flag so the router redirect stops bouncing back to /onboarding.
void markOnboardingDone() {
  _onboardingComplete = true;
}

final appRouter = GoRouter(
  initialLocation: '/splash',
  debugLogDiagnostics: false,
  refreshListenable: _authStream,
  redirect: (context, state) {
    if (!_authStream.resolved) return '/splash';

    final loc = state.matchedLocation;
    final isLoggedIn = FirebaseAuth.instance.currentUser != null;

    // First-run onboarding (only for new unauthenticated users)
    if (_onboardingChecked && !_onboardingComplete && !isLoggedIn) {
      if (loc != '/onboarding') return '/onboarding';
      return null;
    }

    final isOnAuth = loc == '/auth';
    final isOnSplash = loc == '/splash';
    final isOnOnboarding = loc == '/onboarding';

    if (!isLoggedIn && !isOnAuth && !isOnOnboarding) return '/auth';
    if (isLoggedIn && (isOnAuth || isOnSplash || isOnOnboarding)) return '/home';
    return null;
  },
  routes: [
    GoRoute(
      path: '/onboarding',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const OnboardingPage(),
        transitionsBuilder: _fadeTransition,
      ),
    ),
    GoRoute(
      path: '/splash',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const SplashPage(),
        transitionsBuilder: _fadeTransition,
      ),
    ),
    GoRoute(
      path: '/auth',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const AuthPage(),
        transitionsBuilder: _fadeTransition,
      ),
    ),
    GoRoute(
      path: '/booking/confirmation',
      pageBuilder: (context, state) {
        final appointment = state.extra as Appointment;
        return CustomTransitionPage(
          key: state.pageKey,
          child: BookingConfirmationPage(appointment: appointment),
          transitionsBuilder: _fadeTransition,
        );
      },
    ),
    ShellRoute(
      pageBuilder: (context, state, child) => NoTransitionPage(
        key: state.pageKey,
        child: ShellPage(child: child),
      ),
      routes: [
        GoRoute(
          path: '/home',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: HomePage(),
          ),
        ),
        GoRoute(
          path: '/booking',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: BookingPage(),
          ),
        ),
        GoRoute(
          path: '/loyalty',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: LoyaltyPage(),
          ),
        ),
        GoRoute(
          path: '/profile',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: ProfilePage(),
          ),
        ),
        GoRoute(
          path: '/history',
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: HistoryPage()),
        ),
      ],
    ),
  ],
  errorPageBuilder: (context, state) => MaterialPage(
    child: Scaffold(
      backgroundColor: const Color(0xFF141414),
      body: Center(
        child: Text(
          'Página não encontrada: ${state.uri}',
          style: const TextStyle(color: Colors.white),
        ),
      ),
    ),
  ),
);

Widget _fadeTransition(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  return FadeTransition(opacity: animation, child: child);
}
