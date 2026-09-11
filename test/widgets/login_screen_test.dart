import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ocari/core/theme/app_theme.dart';
import 'package:ocari/features/auth/presentation/providers/auth_notifier.dart';
import 'package:ocari/features/auth/presentation/screens/login_screen.dart';

class MockFirebaseAuth extends Mock implements fb.FirebaseAuth {}

class FakeUser extends Fake implements fb.User {
  @override
  String get uid => 'user-123';

  @override
  String? get email => 'test@example.com';
}

void main() {
  late MockFirebaseAuth mockAuth;
  late StreamController<fb.User?> authStateController;
  void Function(FlutterErrorDetails)? oldOnError;

  setUpAll(() {
    oldOnError = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails details) {
      final exceptionStr = details.exception.toString();
      if (exceptionStr.contains('overflowed') ||
          exceptionStr.contains('overflow')) {
        return;
      }
      oldOnError?.call(details);
    };
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

  tearDownAll(() {
    FlutterError.onError = oldOnError;
  });

  Widget createWidgetUnderTest() {
    return ProviderScope(
      overrides: [
        firebaseAuthProvider.overrideWithValue(mockAuth),
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

    testWidgets('shows validation errors when submitting empty form',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1000));
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(FilledButton, 'Sign in'));
      await tester.pumpAndSettle();

      expect(find.text('Email is required'), findsOneWidget);
      expect(find.text('Password is required'), findsOneWidget);

      await tester.binding.setSurfaceSize(null);
    });

    testWidgets(
        'shows validation error for invalid email and short password',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1000));
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).first, 'invalid-email');
      await tester.enterText(find.byType(TextFormField).last, 'short');

      await tester.tap(find.widgetWithText(FilledButton, 'Sign in'));
      await tester.pumpAndSettle();

      expect(find.text('Enter a valid email'), findsOneWidget);
      expect(find.text('Password must be at least 8 characters'),
          findsOneWidget);

      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('attempts login and shows error snackbar on failure',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1000));
      when(() => mockAuth.signInWithEmailAndPassword(
            email: 'test@example.com',
            password: 'password123',
          )).thenThrow(fb.FirebaseAuthException(
        code: 'invalid-credential',
        message: 'Invalid credentials',
      ));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).first, 'test@example.com');
      await tester.enterText(find.byType(TextFormField).last, 'password123');

      await tester.tap(find.widgetWithText(FilledButton, 'Sign in'));
      await tester.pump();

      await tester.pumpAndSettle();
      expect(find.text('Incorrect email or password.'), findsOneWidget);

      await tester.binding.setSurfaceSize(null);
    });
  });
}
