import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ocari/core/theme/app_theme.dart';
import 'package:ocari/core/widgets/ocari_text_field.dart';

void main() {
  Widget createWidgetUnderTest({
    required String label,
    required TextEditingController controller,
    bool obscureText = false,
    String? errorText,
    TextInputType keyboardType = TextInputType.text,
    ValueChanged<String>? onChanged,
    bool isDarkTheme = false,
  }) {
    return MaterialApp(
      theme: isDarkTheme ? AppTheme.darkTheme : AppTheme.lightTheme,
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: OcariTextField(
            label: label,
            controller: controller,
            obscureText: obscureText,
            errorText: errorText,
            keyboardType: keyboardType,
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }

  group('OcariTextField', () {
    testWidgets('renders label correctly', (tester) async {
      final controller = TextEditingController();
      await tester.pumpWidget(
        createWidgetUnderTest(
          label: 'Email',
          controller: controller,
        ),
      );

      expect(find.text('Email'), findsOneWidget);
    });

    testWidgets('shows errorText when provided', (tester) async {
      final controller = TextEditingController();
      await tester.pumpWidget(
        createWidgetUnderTest(
          label: 'Password',
          controller: controller,
          errorText: 'Password is required',
        ),
      );

      expect(find.text('Password is required'), findsOneWidget);
    });

    testWidgets('toggles password visibility when obscureText is true', (tester) async {
      final controller = TextEditingController();
      await tester.pumpWidget(
        createWidgetUnderTest(
          label: 'Password',
          controller: controller,
          obscureText: true,
        ),
      );

      expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);

      await tester.tap(find.byIcon(Icons.visibility_outlined));
      await tester.pump();

      expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);
    });

    testWidgets('renders correctly in dark theme', (tester) async {
      final controller = TextEditingController();
      await tester.pumpWidget(
        createWidgetUnderTest(
          label: 'Email',
          controller: controller,
          isDarkTheme: true,
        ),
      );

      expect(find.text('Email'), findsOneWidget);
      expect(find.byType(TextFormField), findsOneWidget);
    });

    testWidgets('has no visibility toggle when obscureText is false', (tester) async {
      final controller = TextEditingController();
      await tester.pumpWidget(
        createWidgetUnderTest(
          label: 'Email',
          controller: controller,
          obscureText: false,
        ),
      );

      expect(find.byIcon(Icons.visibility_outlined), findsNothing);
      expect(find.byIcon(Icons.visibility_off_outlined), findsNothing);
    });
  });
}