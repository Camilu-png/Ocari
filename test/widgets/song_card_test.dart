import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ocari/core/theme/app_theme.dart';
import 'package:ocari/core/widgets/song_card.dart';
import 'package:ocari/features/songs/domain/models/difficulty.dart';

void main() {
  group('SongCard', () {
    Widget createWidgetUnderTest({
      required String title,
      required Difficulty difficulty,
      required int durationSeconds,
      required VoidCallback onTap,
      String? artist,
      bool isLocked = false,
    }) {
      return MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(
          body: Center(
            child: SongCard(
              title: title,
              difficulty: difficulty,
              durationSeconds: durationSeconds,
              onTap: onTap,
              artist: artist,
              isLocked: isLocked,
            ),
          ),
        ),
      );
    }

    testWidgets('renders title correctly', (tester) async {
      await tester.pumpWidget(
        createWidgetUnderTest(
          title: 'Twinkle Twinkle',
          difficulty: Difficulty.easy,
          durationSeconds: 120,
          onTap: () {},
        ),
      );

      expect(find.text('Twinkle Twinkle'), findsOneWidget);
    });

    testWidgets('renders artist when provided', (tester) async {
      await tester.pumpWidget(
        createWidgetUnderTest(
          title: 'Twinkle Twinkle',
          difficulty: Difficulty.easy,
          durationSeconds: 120,
          onTap: () {},
          artist: 'Mozart',
        ),
      );

      expect(find.text('Mozart'), findsOneWidget);
    });

    testWidgets('shows lock icon when isLocked is true', (tester) async {
      await tester.pumpWidget(
        createWidgetUnderTest(
          title: 'Twinkle Twinkle',
          difficulty: Difficulty.easy,
          durationSeconds: 120,
          onTap: () {},
          isLocked: true,
        ),
      );

      expect(find.byIcon(Icons.lock_rounded), findsOneWidget);
    });

    testWidgets('hides DifficultyBadge when isLocked is true', (tester) async {
      await tester.pumpWidget(
        createWidgetUnderTest(
          title: 'Twinkle Twinkle',
          difficulty: Difficulty.easy,
          durationSeconds: 120,
          onTap: () {},
          isLocked: true,
        ),
      );

      expect(find.text('Easy'), findsNothing);
    });

    testWidgets('formats 90 seconds as 1:30', (tester) async {
      await tester.pumpWidget(
        createWidgetUnderTest(
          title: 'Twinkle Twinkle',
          difficulty: Difficulty.easy,
          durationSeconds: 90,
          onTap: () {},
        ),
      );

      expect(find.text('1:30'), findsOneWidget);
    });

    testWidgets('formats 0 seconds as 0:00', (tester) async {
      await tester.pumpWidget(
        createWidgetUnderTest(
          title: 'Twinkle Twinkle',
          difficulty: Difficulty.easy,
          durationSeconds: 0,
          onTap: () {},
        ),
      );

      expect(find.text('0:00'), findsOneWidget);
    });

    testWidgets('formats 3661 seconds as 61:01', (tester) async {
      await tester.pumpWidget(
        createWidgetUnderTest(
          title: 'Twinkle Twinkle',
          difficulty: Difficulty.easy,
          durationSeconds: 3661,
          onTap: () {},
        ),
      );

      expect(find.text('61:01'), findsOneWidget);
    });

    testWidgets('calls onTap when tapped', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(
        createWidgetUnderTest(
          title: 'Twinkle Twinkle',
          difficulty: Difficulty.easy,
          durationSeconds: 120,
          onTap: () {
            tapped = true;
          },
        ),
      );

      await tester.tap(find.text('Twinkle Twinkle'));
      expect(tapped, isTrue);
    });

    testWidgets('calls onTap even when isLocked is true', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(
        createWidgetUnderTest(
          title: 'Twinkle Twinkle',
          difficulty: Difficulty.easy,
          durationSeconds: 120,
          onTap: () {
            tapped = true;
          },
          isLocked: true,
        ),
      );

      await tester.tap(find.byType(SongCard));
      expect(tapped, isTrue);
    });

    testWidgets('shows difficulty badge for unlocked songs', (tester) async {
      await tester.pumpWidget(
        createWidgetUnderTest(
          title: 'Twinkle Twinkle',
          difficulty: Difficulty.medium,
          durationSeconds: 120,
          onTap: () {},
        ),
      );

      expect(find.text('Medium'), findsOneWidget);
    });
  });
}
