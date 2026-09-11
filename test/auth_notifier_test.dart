import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ocari/features/auth/presentation/providers/auth_notifier.dart';

class MockFirebaseAuth extends Mock implements fb.FirebaseAuth {}

class MockUserCredential extends Mock implements fb.UserCredential {}

class FakeUser extends Fake implements fb.User {
  @override
  String get uid => 'user-123';

  @override
  String? get email => 'test@example.com';

  @override
  String? get displayName => 'Test User';
}

void main() {
  late MockFirebaseAuth mockAuth;
  late StreamController<fb.User?> authStateController;

  setUpAll(() {
    registerFallbackValue(FakeUser());
  });

  setUp(() {
    mockAuth = MockFirebaseAuth();
    authStateController = StreamController<fb.User?>.broadcast();

    when(() => mockAuth.authStateChanges())
        .thenAnswer((_) => authStateController.stream);
    when(() => mockAuth.currentUser).thenReturn(null);
  });

  tearDown(() {
    authStateController.close();
  });

  group('AuthNotifier', () {
    test('initial state is unauthenticated when no user', () {
      final container = ProviderContainer(
        overrides: [
          firebaseAuthProvider.overrideWithValue(mockAuth),
        ],
      );

      final authState = container.read(authProvider);

      expect(authState.status, equals(AuthStatus.unauthenticated));
      expect(authState.user, isNull);

      container.dispose();
    });

    test('initial state is authenticated when user exists', () {
      final fakeUser = FakeUser();
      when(() => mockAuth.currentUser).thenReturn(fakeUser);

      final container = ProviderContainer(
        overrides: [
          firebaseAuthProvider.overrideWithValue(mockAuth),
        ],
      );

      final authState = container.read(authProvider);

      expect(authState.status, equals(AuthStatus.authenticated));
      expect(authState.user, isNotNull);

      container.dispose();
    });

    test('logout calls signOut and updates state to unauthenticated', () async {
      when(() => mockAuth.signOut()).thenAnswer((_) async {});

      final container = ProviderContainer(
        overrides: [
          firebaseAuthProvider.overrideWithValue(mockAuth),
        ],
      );

      expect(container.read(authProvider).status,
          equals(AuthStatus.unauthenticated));

      await container.read(authProvider.notifier).logout();

      verify(() => mockAuth.signOut()).called(1);

      expect(container.read(authProvider).status,
          equals(AuthStatus.unauthenticated));

      container.dispose();
    });

    test('signInWithEmailAndPassword success updates state', () async {
      final fakeUser = FakeUser();
      final mockCredential = MockUserCredential();
      when(() => mockCredential.user).thenReturn(fakeUser);

      when(() => mockAuth.signInWithEmailAndPassword(
            email: 'test@example.com',
            password: 'password123',
          )).thenAnswer((_) async => mockCredential);

      final container = ProviderContainer(
        overrides: [
          firebaseAuthProvider.overrideWithValue(mockAuth),
        ],
      );

      final result =
          await container.read(authProvider.notifier).signInWithEmailAndPassword(
                email: 'test@example.com',
                password: 'password123',
              );

      expect(result.success, isTrue);
      expect(result.error, isNull);
      container.dispose();
    });

    test('signInWithEmailAndPassword wrong password returns error', () async {
      when(() => mockAuth.signInWithEmailAndPassword(
            email: 'test@example.com',
            password: 'wrongpassword',
          )).thenThrow(fb.FirebaseAuthException(
        code: 'invalid-credential',
        message: 'Invalid credentials',
      ));

      final container = ProviderContainer(
        overrides: [
          firebaseAuthProvider.overrideWithValue(mockAuth),
        ],
      );

      final result =
          await container.read(authProvider.notifier).signInWithEmailAndPassword(
                email: 'test@example.com',
                password: 'wrongpassword',
              );

      expect(result.success, isFalse);
      expect(result.error, contains('Incorrect email or password'));
      container.dispose();
    });

    test('signInWithEmailAndPassword network error returns connection message',
        () async {
      when(() => mockAuth.signInWithEmailAndPassword(
            email: 'test@example.com',
            password: 'password123',
          )).thenThrow(Exception('SocketException: Failed host lookup'));

      final container = ProviderContainer(
        overrides: [
          firebaseAuthProvider.overrideWithValue(mockAuth),
        ],
      );

      final result =
          await container.read(authProvider.notifier).signInWithEmailAndPassword(
                email: 'test@example.com',
                password: 'password123',
              );

      expect(result.success, isFalse);
      expect(result.error, contains('Connection error'));
      container.dispose();
    });
  });
}
