import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ocari/features/auth/presentation/providers/auth_notifier.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

class MockGoTrueClient extends Mock implements supabase.GoTrueClient {}

class FakeUser extends Fake implements supabase.User {}

class FakeSession extends Fake implements supabase.Session {}

void main() {
  late MockGoTrueClient mockAuthClient;
  late StreamController<supabase.AuthState> authEventController;

  setUpAll(() {
    registerFallbackValue(FakeUser());
    registerFallbackValue(FakeSession());
  });

  setUp(() {
    mockAuthClient = MockGoTrueClient();
    authEventController = StreamController<supabase.AuthState>.broadcast();

    when(() => mockAuthClient.onAuthStateChange)
        .thenAnswer((_) => authEventController.stream);
    when(() => mockAuthClient.currentSession).thenReturn(null);
    when(() => mockAuthClient.signOut()).thenAnswer((_) async {});
  });

  tearDown(() {
    authEventController.close();
  });

  group('AuthNotifier', () {
    test('initial state is unauthenticated when no session', () {
      final container = ProviderContainer(
        overrides: [
          supabaseAuthClientProvider.overrideWithValue(mockAuthClient),
        ],
      );

      final authState = container.read(authProvider);

      expect(authState.status, equals(AuthStatus.unauthenticated));
      expect(authState.user, isNull);

      container.dispose();
    });

    test('initial state is authenticated when session exists', () {
      final mockUser = _createMockUser('user-123');
      final mockSession = _createMockSession(mockUser);

      when(() => mockAuthClient.currentSession).thenReturn(mockSession);

      final container = ProviderContainer(
        overrides: [
          supabaseAuthClientProvider.overrideWithValue(mockAuthClient),
        ],
      );

      final authState = container.read(authProvider);

      expect(authState.status, equals(AuthStatus.authenticated));
      expect(authState.user, equals(mockUser));

      container.dispose();
    });

    test('logout calls signOut and updates state to unauthenticated', () async {
      final container = ProviderContainer(
        overrides: [
          supabaseAuthClientProvider.overrideWithValue(mockAuthClient),
        ],
      );

      expect(container.read(authProvider).status, equals(AuthStatus.unauthenticated));

      await container.read(authProvider.notifier).logout();

      verify(() => mockAuthClient.signOut()).called(1);

      expect(container.read(authProvider).status, equals(AuthStatus.unauthenticated));

      container.dispose();
    });

    test('signInWithEmailAndPassword success updates state to authenticated', () async {
      final mockUser = _createMockUser('user-123');
      final mockSession = _createMockSession(mockUser);
      final mockResponse = supabase.AuthResponse(session: mockSession, user: mockUser);

      when(() => mockAuthClient.signInWithPassword(
            email: 'test@example.com',
            password: 'password123',
          )).thenAnswer((_) async => mockResponse);

      final container = ProviderContainer(
        overrides: [
          supabaseAuthClientProvider.overrideWithValue(mockAuthClient),
        ],
      );

      final result = await container.read(authProvider.notifier).signInWithEmailAndPassword(
            email: 'test@example.com',
            password: 'password123',
          );

      expect(result.success, isTrue);
      expect(result.error, isNull);
      container.dispose();
    });

    test('signInWithEmailAndPassword failure invalid credentials returns error message', () async {
      when(() => mockAuthClient.signInWithPassword(
            email: 'test@example.com',
            password: 'wrongpassword',
          )).thenThrow(const supabase.AuthException('Invalid login credentials', statusCode: '400'));

      final container = ProviderContainer(
        overrides: [
          supabaseAuthClientProvider.overrideWithValue(mockAuthClient),
        ],
      );

      final result = await container.read(authProvider.notifier).signInWithEmailAndPassword(
            email: 'test@example.com',
            password: 'wrongpassword',
          );

      expect(result.success, isFalse);
      expect(result.error, equals('Incorrect email or password.'));
      container.dispose();
    });

    test('signInWithEmailAndPassword failure connection error returns connection message', () async {
      when(() => mockAuthClient.signInWithPassword(
            email: 'test@example.com',
            password: 'password123',
          )).thenThrow(const FormatException('SocketException: Failed host lookup'));

      final container = ProviderContainer(
        overrides: [
          supabaseAuthClientProvider.overrideWithValue(mockAuthClient),
        ],
      );

      final result = await container.read(authProvider.notifier).signInWithEmailAndPassword(
            email: 'test@example.com',
            password: 'password123',
          );

      expect(result.success, isFalse);
      expect(result.error, contains('Connection error'));
      container.dispose();
    });
  });
}

supabase.User _createMockUser(String id) {
  return supabase.User(
    id: id,
    appMetadata: {},
    userMetadata: {},
    aud: 'authenticated',
    email: 'test@example.com',
    createdAt: DateTime.now().toIso8601String(),
  );
}

supabase.Session _createMockSession(supabase.User user) {
  return supabase.Session(
    accessToken: 'mock-token',
    tokenType: 'Bearer',
    expiresIn: 3600,
    refreshToken: 'mock-refresh',
    user: user,
  );
}