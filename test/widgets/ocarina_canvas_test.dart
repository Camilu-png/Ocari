import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ocari/core/theme/app_theme.dart';
import 'package:ocari/core/theme/note_colors.dart';
import 'package:ocari/core/widgets/ocarina_canvas.dart';
import 'package:ocari/features/songs/domain/models/song_note.dart';

Widget createLightWidget({SongNote? note}) {
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

Widget createDarkWidget({SongNote? note}) {
  return ProviderScope(
    child: MaterialApp(
      theme: AppTheme.darkTheme,
      home: Scaffold(
        body: Center(
          child: OcarinaCanvas(note: note),
        ),
      ),
    ),
  );
}

void main() {
  group('OcarinaCanvas', () {
    testWidgets('renders "--" when note is null', (tester) async {
      await tester.pumpWidget(createLightWidget());

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

      await tester.pumpWidget(createLightWidget(note: note));

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

      await tester.pumpWidget(createLightWidget(note: note));

      expect(find.text('F#5'), findsOneWidget);
    });

    testWidgets('contains CustomPaint inside OcarinaCanvas', (tester) async {
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

      await tester.pumpWidget(createLightWidget(note: note));

      final ocarina = find.byType(OcarinaCanvas);
      final customPaint = find.descendant(
        of: ocarina,
        matching: find.byType(CustomPaint),
      );
      expect(customPaint, findsOneWidget);
    });

    testWidgets('renders without error in dark theme', (tester) async {
      await tester.pumpWidget(createDarkWidget());

      expect(find.text('--'), findsOneWidget);
      final ocarina = find.byType(OcarinaCanvas);
      final customPaint = find.descendant(
        of: ocarina,
        matching: find.byType(CustomPaint),
      );
      expect(customPaint, findsOneWidget);
    });

    testWidgets('renders all holes pressed without error', (tester) async {
      const note = SongNote(
        note: 'C6',
        top: [1, 1, 1, 1],
        bot: [1, 1, 1, 1],
        sub: [1, 1],
        middle: [1, 1],
        timestampMs: 0,
        durationMs: 500,
        noteValue: 'quarter',
      );

      await tester.pumpWidget(createLightWidget(note: note));

      expect(find.text('C6'), findsOneWidget);
      final ocarina = find.byType(OcarinaCanvas);
      final customPaint = find.descendant(
        of: ocarina,
        matching: find.byType(CustomPaint),
      );
      expect(customPaint, findsOneWidget);
    });

    testWidgets('renders note label below the canvas area', (tester) async {
      const note = SongNote(
        note: 'A5',
        top: [0, 0, 0, 0],
        bot: [0, 0, 0, 0],
        sub: [0, 0],
        middle: [0, 0],
        timestampMs: 0,
        durationMs: 500,
        noteValue: 'quarter',
      );

      await tester.pumpWidget(createLightWidget(note: note));

      final ocarina = find.byType(OcarinaCanvas);
      final customPaint = find.descendant(
        of: ocarina,
        matching: find.byType(CustomPaint),
      );
      final label = find.text('A5');

      expect(customPaint, findsOneWidget);
      expect(label, findsOneWidget);
    });

    testWidgets('label color matches note color when note is provided',
        (tester) async {
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

      await tester.pumpWidget(createLightWidget(note: note));

      final textWidget = tester.widget<Text>(find.text('D5'));
      final textStyle = textWidget.style;
      expect(textStyle?.color, equals(NoteColors.forNote('D5')));
    });

    testWidgets('label uses neutral color when note is null',
        (tester) async {
      await tester.pumpWidget(createLightWidget());

      final textWidget = tester.widget<Text>(find.text('--'));
      final textStyle = textWidget.style;
      expect(textStyle?.color, isNot(equals(NoteColors.forNote('D5'))));
    });

    testWidgets('displays updated note name when note changes', (tester) async {
      const noteA5 = SongNote(
        note: 'A5',
        top: [0, 0, 0, 0],
        bot: [0, 0, 0, 0],
        sub: [0, 0],
        middle: [0, 0],
        timestampMs: 0,
        durationMs: 500,
        noteValue: 'quarter',
      );
      const noteD5 = SongNote(
        note: 'D5',
        top: [1, 1, 1, 0],
        bot: [0, 0, 0, 0],
        sub: [1, 1],
        middle: [0, 0],
        timestampMs: 1000,
        durationMs: 500,
        noteValue: 'quarter',
      );

      await tester.pumpWidget(createLightWidget(note: noteA5));
      expect(find.text('A5'), findsOneWidget);
      expect(find.text('D5'), findsNothing);

      await tester.pumpWidget(createLightWidget(note: noteD5));
      await tester.pumpAndSettle();

      expect(find.text('D5'), findsOneWidget);
      expect(find.text('A5'), findsNothing);
    });
  });
}
