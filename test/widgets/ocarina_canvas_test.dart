import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ocari/core/theme/app_theme.dart';
import 'package:ocari/features/player/presentation/widgets/ocarina_canvas.dart';
import 'package:ocari/features/songs/domain/models/song_note.dart';

void main() {
  group('OcarinaCanvas', () {
    Widget createWidgetUnderTest({SongNote? note}) {
      return ProviderScope(
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: Center(
              child: OcarinaCanvas(note: note),
            ),
          ),
        ),
      );
    }

    testWidgets('renders "--" when note is null', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('--'), findsOneWidget);
    });

    testWidgets('renders note name when note is provided', (tester) async {
      const note = SongNote(
        note: 'D5',
        top: [1, 1, 1, 0],
        bot: [0, 0, 0, 0],
        sub: [1, 1],
        middle: [0, 0],
        timestampMs: 0,
        durationMs: 500,
        noteValue: 'quarter',
      );

      await tester.pumpWidget(createWidgetUnderTest(note: note));

      expect(find.text('D5'), findsOneWidget);
    });

    testWidgets('renders label for complex note', (tester) async {
      const note = SongNote(
        note: 'F#5',
        top: [1, 1, 1, 1],
        bot: [0, 0, 1, 0],
        sub: [1, 1],
        middle: [0, 0],
        timestampMs: 1000,
        durationMs: 750,
        noteValue: 'eighth',
      );

      await tester.pumpWidget(createWidgetUnderTest(note: note));

      expect(find.text('F#5'), findsOneWidget);
    });
  });
}
