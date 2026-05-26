import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ocari/core/difficulty.dart';
import 'package:ocari/core/theme/app_theme.dart';
import 'package:ocari/core/widgets/difficulty_badge.dart';

void main() {
  group('DifficultyBadge', () {
    Widget createWidgetUnderTest(Difficulty difficulty) {
      return MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(
          body: Center(
            child: DifficultyBadge(difficulty: difficulty),
          ),
        ),
      );
    }

    testWidgets('renders Easy for easy', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(Difficulty.easy));
      expect(find.text('Easy'), findsOneWidget);
    });

    testWidgets('renders Medium for medium', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(Difficulty.medium));
      expect(find.text('Medium'), findsOneWidget);
    });

    testWidgets('renders Hard for hard', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(Difficulty.hard));
      expect(find.text('Hard'), findsOneWidget);
    });

    testWidgets('applies easy background color', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(Difficulty.easy));
      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, AppColors.light.diffEasyBg);
    });

    testWidgets('applies medium background color', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(Difficulty.medium));
      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, AppColors.light.diffMediumBg);
    });

    testWidgets('applies hard background color', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(Difficulty.hard));
      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, AppColors.light.diffHardBg);
    });
  });
}
