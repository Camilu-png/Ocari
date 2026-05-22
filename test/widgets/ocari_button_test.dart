import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ocari/core/theme/app_theme.dart';
import 'package:ocari/core/widgets/ocari_button.dart';

void main() {
  Widget createWidgetUnderTest({
    required String label,
    VoidCallback? onPressed,
    bool isLoading = false,
    bool isFullWidth = true,
    bool isDarkTheme = false,
  }) {
    return MaterialApp(
      theme: isDarkTheme ? AppTheme.darkTheme : AppTheme.lightTheme,
      home: Scaffold(
        body: Center(
          child: OcariButton(
            label: label,
            onPressed: onPressed,
            isLoading: isLoading,
            isFullWidth: isFullWidth,
          ),
        ),
      ),
    );
  }

  group('OcariButton', () {
    testWidgets('renders label correctly', (tester) async {
      await tester.pumpWidget(
        createWidgetUnderTest(
          label: 'Test Button',
          onPressed: () {},
        ),
      );

      expect(find.text('Test Button'), findsOneWidget);
    });

    testWidgets('shows CircularProgressIndicator when isLoading is true',
        (tester) async {
      await tester.pumpWidget(
        createWidgetUnderTest(
          label: 'Test Button',
          onPressed: () {},
          isLoading: true,
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Test Button'), findsNothing);
    });

    testWidgets('onPressed is null when isLoading is true', (tester) async {
      await tester.pumpWidget(
        createWidgetUnderTest(
          label: 'Test Button',
          onPressed: () {},
          isLoading: true,
        ),
      );

      final button = tester.widget<FilledButton>(find.byType(FilledButton));
      expect(button.onPressed, isNull);
    });

    testWidgets('renders with full width when isFullWidth is true',
        (tester) async {
      await tester.pumpWidget(
        createWidgetUnderTest(
          label: 'Test Button',
          onPressed: () {},
          isFullWidth: true,
        ),
      );

      final sizedBox = tester.widget<SizedBox>(
        find.byKey(const Key('ocari_button_sized_box')),
      );
      expect(sizedBox.width, equals(double.infinity));
    });

    testWidgets('does not have full width when isFullWidth is false',
        (tester) async {
      await tester.pumpWidget(
        createWidgetUnderTest(
          label: 'Test Button',
          onPressed: () {},
          isFullWidth: false,
        ),
      );

      final sizedBox = tester.widget<SizedBox>(
        find.byKey(const Key('ocari_button_sized_box')),
      );
      expect(sizedBox.width, isNull);
    });

    testWidgets('renders correctly in dark theme', (tester) async {
      await tester.pumpWidget(
        createWidgetUnderTest(
          label: 'Test Button',
          onPressed: () {},
          isDarkTheme: true,
        ),
      );

      expect(find.text('Test Button'), findsOneWidget);
      expect(find.byType(FilledButton), findsOneWidget);
    });
  });
}