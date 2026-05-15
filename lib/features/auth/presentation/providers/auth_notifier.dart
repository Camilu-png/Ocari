import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

enum AuthStatus { authenticated, unauthenticated, loading }

class AppAuthState {
  final AuthStatus status;
  final supabase.User? user;

  const AppAuthState({
    this.status = AuthStatus.loading,
    this.user,
  });

  AppAuthState copyWith({AuthStatus? status, supabase.User? user}) {
    return AppAuthState(
      status: status ?? this.status,
      user: user ?? this.user,
    );
  }

  bool get isAuthenticated => status == AuthStatus.authenticated;
}

final supabaseAuthClientProvider = Provider<supabase.GoTrueClient>((ref) {
  return supabase.Supabase.instance.client.auth;
});

class AuthNotifier extends Notifier<AppAuthState> {
  StreamSubscription? _authSubscription;

  @override
  AppAuthState build() {
    final authClient = ref.watch(supabaseAuthClientProvider);

    _authSubscription = authClient.onAuthStateChange.listen((event) {
      final session = authClient.currentSession;
      if (session != null) {
        state = AppAuthState(
          status: AuthStatus.authenticated,
          user: session.user,
        );
      } else {
        state = const AppAuthState(status: AuthStatus.unauthenticated);
      }
    });

    ref.onDispose(() {
      _authSubscription?.cancel();
    });

    final initialSession = authClient.currentSession;
    if (initialSession != null) {
      return AppAuthState(
        status: AuthStatus.authenticated,
        user: initialSession.user,
      );
    }

    return const AppAuthState(status: AuthStatus.unauthenticated);
  }

  Future<void> logout() async {
    final authClient = ref.read(supabaseAuthClientProvider);
    await authClient.signOut();
    state = const AppAuthState(status: AuthStatus.unauthenticated);
  }
}

final authProvider = NotifierProvider<AuthNotifier, AppAuthState>(
  AuthNotifier.new,
);