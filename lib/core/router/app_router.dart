import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/pages/auth_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/home/presentation/pages/shell_page.dart';
import '../../features/scheduling/presentation/pages/booking_page.dart';
import '../../features/loyalty/presentation/pages/loyalty_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';

// Bridges Firebase auth stream into a GoRouter-compatible Listenable
class _AuthRefreshStream extends ChangeNotifier {
  late final StreamSubscription<User?> _sub;

  _AuthRefreshStream(Stream<User?> stream) {
    notifyListeners();
    _sub = stream.listen((_) => notifyListeners());
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}

final appRouter = GoRouter(
  initialLocation: '/home',
  debugLogDiagnostics: false,
  refreshListenable:
      _AuthRefreshStream(FirebaseAuth.instance.authStateChanges()),
  redirect: (context, state) {
    final isLoggedIn = FirebaseAuth.instance.currentUser != null;
    final isOnAuth = state.matchedLocation == '/auth';

    if (!isLoggedIn && !isOnAuth) return '/auth';
    if (isLoggedIn && isOnAuth) return '/home';
    return null;
  },
  routes: [
    GoRoute(
      path: '/auth',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const AuthPage(),
        transitionsBuilder: _fadeTransition,
      ),
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
