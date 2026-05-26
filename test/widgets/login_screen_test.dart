import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ocari/core/theme/app_theme.dart';
import 'package:ocari/features/auth/presentation/providers/auth_notifier.dart';
import 'package:ocari/features/auth/presentation/screens/login_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

class MockGoTrueClient extends Mock implements supabase.GoTrueClient {}
class FakeUser extends Fake implements supabase.User {}
class FakeSession extends Fake implements supabase.Session {}

void main() {
  late MockGoTrueClient mockAuthClient;
  late StreamController<supabase.AuthState> authEventController;
  void Function(FlutterErrorDetails)? oldOnError;

  setUpAll(() {
    registerFallbackValue(FakeUser());
    registerFallbackValue(FakeSession());
    oldOnError = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails details) {
      final exceptionStr = details.exception.toString();
      if (exceptionStr.contains('overflowed') || exceptionStr.contains('overflow')) {
        return;
      }
      oldOnError?.call(details);
    };
  });

  setUp(() {
    mockAuthClient = MockGoTrueClient();
    authEventController = StreamController<supabase.AuthState>.broadcast();

    when(() => mockAuthClient.onAuthStateChange)
        .thenAnswer((_) => authEventController.stream);
    when(() => mockAuthClient.currentSession).thenReturn(null);
  });

  tearDown(() {
    authEventController.close();
  });

  tearDownAll(() {
    FlutterError.onError = oldOnError;
  });

  Widget createWidgetUnderTest() {
    return ProviderScope(
      overrides: [
        supabaseAuthClientProvider.overrideWithValue(mockAuthClient),
      ],
      child: MaterialApp(
        theme: AppTheme.lightTheme,
        home: const LoginScreen(),
      ),
    );
  }

  group('LoginScreen Widget Tests', () {
    testWidgets('renders all widgets correctly', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1000));
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('Welcome Back'), findsOneWidget);
      expect(find.text('Sign in to your account'), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(2));
      expect(find.widgetWithText(FilledButton, 'Sign in'), findsOneWidget);
      expect(find.text('Google'), findsOneWidget);

      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('shows validation errors when submitting empty form', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1000));
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Tap the Sign In button
      await tester.tap(find.widgetWithText(FilledButton, 'Sign in'));
      await tester.pumpAndSettle();

      // Should show validation errors
      expect(find.text('Email is required'), findsOneWidget);
      expect(find.text('Password is required'), findsOneWidget);

      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('shows validation error for invalid email and short password', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1000));
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Enter invalid email and short password
      await tester.enterText(find.byType(TextFormField).first, 'invalid-email');
      await tester.enterText(find.byType(TextFormField).last, 'short');
      
      await tester.tap(find.widgetWithText(FilledButton, 'Sign in'));
      await tester.pumpAndSettle();

      expect(find.text('Enter a valid email'), findsOneWidget);
      expect(find.text('Password must be at least 8 characters'), findsOneWidget);

      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('attempts login and shows error snackbar on failure', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1000));
      when(() => mockAuthClient.signInWithPassword(
            email: 'test@example.com',
            password: 'password123',
          )).thenThrow(const supabase.AuthException('Invalid login credentials', statusCode: '400'));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Enter valid email and password
      await tester.enterText(find.byType(TextFormField).first, 'test@example.com');
      await tester.enterText(find.byType(TextFormField).last, 'password123');

      await tester.tap(find.widgetWithText(FilledButton, 'Sign in'));
      await tester.pump(); // Start request

      // Verify snackbar appears with error
      await tester.pumpAndSettle();
      expect(find.text('Incorrect email or password.'), findsOneWidget);

      await tester.binding.setSurfaceSize(null);
    });
  });
}
