import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

enum AuthStatus { authenticated, unauthenticated, loading }

class AppAuthState {
  final AuthStatus status;
  final fb.User? user;

  const AppAuthState({
    this.status = AuthStatus.loading,
    this.user,
  });

  AppAuthState copyWith(
      {AuthStatus? status, fb.User? user, bool clearUser = false}) {
    return AppAuthState(
      status: status ?? this.status,
      user: clearUser ? null : (user ?? this.user),
    );
  }

  bool get isAuthenticated => status == AuthStatus.authenticated;
}

final firebaseAuthProvider = Provider<fb.FirebaseAuth>((ref) {
  return fb.FirebaseAuth.instance;
});

final firebaseFirestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

const _googleServerClientId = String.fromEnvironment('GOOGLE_SERVER_CLIENT_ID');

final googleSignInProvider = Provider<GoogleSignIn>((ref) {
  return GoogleSignIn(
    scopes: ['email', 'profile'],
    serverClientId:
        _googleServerClientId.isNotEmpty ? _googleServerClientId : null,
  );
});

class AuthNotifier extends Notifier<AppAuthState> {
  StreamSubscription? _authSubscription;

  @override
  AppAuthState build() {
    final auth = ref.watch(firebaseAuthProvider);

    _authSubscription = auth.authStateChanges().listen(
      (user) {
        if (user != null) {
          state = AppAuthState(
            status: AuthStatus.authenticated,
            user: user,
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

    final currentUser = auth.currentUser;
    if (currentUser != null) {
      return AppAuthState(
        status: AuthStatus.authenticated,
        user: currentUser,
      );
    }

    return const AppAuthState(status: AuthStatus.unauthenticated);
  }

  Future<void> logout() async {
    final auth = ref.read(firebaseAuthProvider);
    await auth.signOut();
    state = const AppAuthState(status: AuthStatus.unauthenticated);
    try {
      await ref.read(googleSignInProvider).signOut();
    } catch (_) {}
  }

  Future<({bool success, String? error})> signUp({
    required String email,
    required String password,
    String? name,
  }) async {
    try {
      final auth = ref.read(firebaseAuthProvider);
      final credential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (credential.user != null) {
        if (name != null && name.isNotEmpty) {
          await credential.user!.updateDisplayName(name);
        }
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
      final auth = ref.read(firebaseAuthProvider);
      final credential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (credential.user != null) {
        return (success: true, error: null);
      }
      return (success: false, error: 'Login failed');
    } on fb.FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password' ||
          e.code == 'invalid-credential') {
        return (success: false, error: 'Incorrect email or password.');
      }
      return (success: false, error: e.message ?? 'Authentication error');
    } catch (e) {
      final errStr = e.toString().toLowerCase();
      if (errStr.contains('socketexception') ||
          errStr.contains('connection') ||
          errStr.contains('failed host lookup') ||
          errStr.contains('network')) {
        return (
          success: false,
          error: 'Connection error. Please check your internet connection.'
        );
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
      final credential = fb.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final auth = ref.read(firebaseAuthProvider);
      final userCredential = await auth.signInWithCredential(credential);

      if (userCredential.user != null) {
        return (success: true, error: null);
      }
      return (success: false, error: 'Failed to sign in with Google');
    } catch (e) {
      return (success: false, error: e.toString());
    }
  }

  Future<({bool success, String? error})> signInWithApple() async {
    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final oauthCredential = fb.OAuthProvider('apple.com').credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      final auth = ref.read(firebaseAuthProvider);
      final userCredential = await auth.signInWithCredential(oauthCredential);

      if (userCredential.user != null) {
        if (appleCredential.givenName != null &&
            appleCredential.familyName != null) {
          await userCredential.user!.updateDisplayName(
            '${appleCredential.givenName} ${appleCredential.familyName}',
          );
        }
        return (success: true, error: null);
      }
      return (success: false, error: 'Failed to sign in with Apple');
    } on SignInWithAppleAuthorizationException catch (e) {
      if (e.code == AuthorizationErrorCode.canceled) {
        return (success: false, error: 'Apple sign in cancelled');
      }
      return (success: false, error: e.message);
    } catch (e) {
      return (success: false, error: e.toString());
    }
  }
}

final authProvider = NotifierProvider<AuthNotifier, AppAuthState>(
  AuthNotifier.new,
);
