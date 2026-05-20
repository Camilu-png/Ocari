import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/providers/auth_notifier.dart'
    show authProvider, AuthStatus;
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/player/presentation/screens/player_screen.dart';
import '../../features/songs/presentation/screens/songs_screen.dart';
import '../theme/debug_screen.dart';

final _routerKey = GlobalKey<NavigatorState>();

class _AuthRedirectNotifier extends ChangeNotifier {
  final Ref _ref;
  bool _isAuthenticated = false;

  _AuthRedirectNotifier(this._ref) {
    _ref.listen<dynamic>(authProvider, (previous, next) {
      final authState = next;
      final wasAuthenticated = _isAuthenticated;
      _isAuthenticated = authState.status == AuthStatus.authenticated;
      if (wasAuthenticated != _isAuthenticated) {
        notifyListeners();
      }
    });
  }

  bool get isAuthenticated => _isAuthenticated;
}

final _authRedirectNotifierProvider = Provider<_AuthRedirectNotifier>((ref) {
  return _AuthRedirectNotifier(ref);
});

final appRouter = Provider<GoRouter>((ref) {
  final authNotifier = ref.watch(_authRedirectNotifierProvider);
  return GoRouter(
    navigatorKey: _routerKey,
    initialLocation: '/songs',
    refreshListenable: authNotifier,
    redirect: (context, state) {
      final isAuth = authNotifier.isAuthenticated;
      final isOnLogin = state.matchedLocation == '/login';
      final isOnRegister = state.matchedLocation == '/register';
      final isOnDebug = state.matchedLocation == '/debug';

      if (!isAuth && !isOnLogin && !isOnRegister && !isOnDebug) {
        return '/login';
      }

      if (isAuth && (isOnLogin || isOnRegister)) {
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