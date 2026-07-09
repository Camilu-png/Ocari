import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:ocari/features/auth/presentation/providers/auth_notifier.dart';
import 'package:ocari/features/auth/presentation/screens/login_screen.dart';
import 'package:ocari/features/auth/presentation/screens/register_screen.dart';
import 'package:ocari/features/onboarding/presentation/providers/onboarding_provider.dart';
import 'package:ocari/features/onboarding/presentation/screens/onboarding_dialog.dart';
import 'package:ocari/features/player/presentation/screens/player_screen.dart';
import 'package:ocari/features/songs/presentation/screens/songs_screen.dart';
import 'package:ocari/core/theme/debug_screen.dart';

final _routerKey = GlobalKey<NavigatorState>();

class _AppRedirectNotifier extends ChangeNotifier {
  final Ref _ref;
  bool _isAuthenticated = false;
  bool _onboardingCompleted = false;

  _AppRedirectNotifier(this._ref) {
    _ref.listen<AppAuthState>(authProvider, (previous, next) {
      final prev = _isAuthenticated;
      _isAuthenticated = next.status == AuthStatus.authenticated;
      if (prev != _isAuthenticated) notifyListeners();
    });
    _ref.listen<AsyncValue<bool>>(onboardingProvider, (previous, next) {
      final prev = _onboardingCompleted;
      _onboardingCompleted = next.asData?.value ?? false;
      if (prev != _onboardingCompleted) notifyListeners();
    });
  }

  bool get isAuthenticated => _isAuthenticated;
  bool get onboardingCompleted => _onboardingCompleted;
}

final _redirectNotifierProvider = Provider<_AppRedirectNotifier>((ref) {
  return _AppRedirectNotifier(ref);
});

final appRouter = Provider<GoRouter>((ref) {
  final notifier = ref.watch(_redirectNotifierProvider);
  return GoRouter(
    navigatorKey: _routerKey,
    initialLocation: '/login',
    refreshListenable: notifier,
    redirect: (context, state) {
      final isAuth = notifier.isAuthenticated;
      final onboardingDone = notifier.onboardingCompleted;
      final location = state.matchedLocation;
      final isOnLogin = location == '/login';
      final isOnRegister = location == '/register';
      final isOnDebug = location == '/debug';
      final isOnOnboarding = location == '/onboarding';

      if (!isAuth && !isOnLogin && !isOnRegister && !isOnDebug) {
        return '/login';
      }

      if (isAuth && (isOnLogin || isOnRegister)) {
        return '/songs';
      }

      if (isAuth && !onboardingDone && !isOnOnboarding) {
        return '/onboarding';
      }

      if (isAuth && onboardingDone && isOnOnboarding) {
        return '/songs';
      }

      return null;
    },
    routes: [
      if (kDebugMode)
        GoRoute(
          path: '/debug',
          builder: (context, state) => const DebugScreen(),
        ),
      GoRoute(
        path: '/',
        redirect: (context, state) => '/songs',
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingDialog(),
      ),
      GoRoute(
        path: '/songs',
        builder: (context, state) => const SongsScreen(),
      ),
      GoRoute(
        path: '/player/:songId',
        builder: (context, state) {
          final songId = state.pathParameters['songId'] ?? '';
          return PlayerScreen(songId: songId);
        },
      ),
    ],
  );
});
