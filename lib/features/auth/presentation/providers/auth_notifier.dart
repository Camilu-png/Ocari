import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

enum AuthStatus { authenticated, unauthenticated, loading }

class AppAuthState {
  final AuthStatus status;
  final supabase.User? user;

  const AppAuthState({
    this.status = AuthStatus.loading,
    this.user,
  });

  AppAuthState copyWith({AuthStatus? status, supabase.User? user, bool clearUser = false}) {
    return AppAuthState(
      status: status ?? this.status,
      user: clearUser ? null : (user ?? this.user),
    );
  }

  bool get isAuthenticated => status == AuthStatus.authenticated;
}

final supabaseAuthClientProvider = Provider<supabase.GoTrueClient>((ref) {
  return supabase.Supabase.instance.client.auth;
});

final googleSignInProvider = Provider<GoogleSignIn>((ref) {
  return GoogleSignIn(
    scopes: ['email', 'profile'],
    serverClientId: '744538709104-namv6gt3mfki4i8png1ntg96recealk8.apps.googleusercontent.com',
  );
});

class AuthNotifier extends Notifier<AppAuthState> {
  StreamSubscription? _authSubscription;

  @override
  AppAuthState build() {
    final authClient = ref.watch(supabaseAuthClientProvider);

    _authSubscription = authClient.onAuthStateChange.listen(
      (event) {
        final session = authClient.currentSession;
        if (session != null) {
          state = AppAuthState(
            status: AuthStatus.authenticated,
            user: session.user,
          );
        } else {
          state = const AppAuthState(status: AuthStatus.unauthenticated);
        }
      },
      onError: (error) {
        state = const AppAuthState(status: AuthStatus.unauthenticated);
      },
    );

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

  Future<({bool success, String? error})> signUp({
    required String email,
    required String password,
    String? name,
  }) async {
    try {
      final authClient = ref.read(supabaseAuthClientProvider);
      final data = name != null ? {'full_name': name} : null;
      final response = await authClient.signUp(
        email: email,
        password: password,
        data: data,
      );
      if (response.user != null) {
        return (success: true, error: null);
      }
      return (success: false, error: 'Failed to create user');
    } catch (e) {
      return (success: false, error: e.toString());
    }
  }

  Future<({bool success, String? error})> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final authClient = ref.read(supabaseAuthClientProvider);
      final response = await authClient.signInWithPassword(
        email: email,
        password: password,
      );
      if (response.user != null) {
        return (success: true, error: null);
      }
      return (success: false, error: 'Login failed');
    } on supabase.AuthException catch (e) {
      final message = e.message.toLowerCase();
      if (message.contains('invalid') || message.contains('credentials') || message.contains('grant')) {
        return (success: false, error: 'Incorrect email or password.');
      }
      return (success: false, error: e.message);
    } catch (e) {
      final errStr = e.toString().toLowerCase();
      if (errStr.contains('socketexception') ||
          errStr.contains('connection') ||
          errStr.contains('failed host lookup') ||
          errStr.contains('network')) {
        return (success: false, error: 'Connection error. Please check your internet connection.');
      }
      return (success: false, error: 'An unexpected error occurred.');
    }
  }

  Future<({bool success, String? error})> signInWithGoogle() async {
    try {
      final googleSignIn = ref.read(googleSignInProvider);

      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        return (success: false, error: 'Google sign in cancelled');
      }

      final googleAuth = await googleUser.authentication;
      final idToken = googleAuth.idToken;

      if (idToken == null) {
        return (success: false, error: 'Failed to get Google ID token');
      }

      final authClient = ref.read(supabaseAuthClientProvider);
      final response = await authClient.signInWithIdToken(
        provider: supabase.OAuthProvider.google,
        idToken: idToken,
      );

      if (response.user != null) {
        return (success: true, error: null);
      }
      return (success: false, error: 'Failed to sign in with Supabase');
    } catch (e) {
      return (success: false, error: e.toString());
    }
  }
}

final authProvider = NotifierProvider<AuthNotifier, AppAuthState>(
  AuthNotifier.new,
);

final authStateStreamProvider = StreamProvider<AppAuthState>((ref) {
  final authClient = ref.watch(supabaseAuthClientProvider);
  return authClient.onAuthStateChange.map((event) {
    final session = authClient.currentSession;
    if (session != null) {
      return AppAuthState(
        status: AuthStatus.authenticated,
        user: session.user,
      );
    }
    return const AppAuthState(status: AuthStatus.unauthenticated);
  });
});
