import 'package:flutter_test/flutter_test.dart';
import 'package:ocari/core/utils/note_parser.dart';

void main() {
  group('normalizeSongData', () {
    test('passes through artist when absent (default handled by Song.fromJson)', () {
      final result = normalizeSongData({
        'id': '1',
        'title': 'Test',
        'difficulty': 'easy',
        'duration_seconds': 30,
        'is_premium': false,
      });
      expect(result.containsKey('artist'), isFalse);
    });

    test('preserves artist when present', () {
      final result = normalizeSongData({
        'id': '1',
        'title': 'Test',
        'artist': 'Existing Artist',
        'difficulty': 'easy',
        'duration_seconds': 30,
        'is_premium': false,
      });
      expect(result['artist'], 'Existing Artist');
    });

    test('parses notes_json when it is a string', () {
      final result = normalizeSongData({
        'id': '1',
        'title': 'Test',
        'difficulty': 'easy',
        'duration_seconds': 30,
        'is_premium': false,
        'notes_json': '{"bpm":120,"notes":[]}',
      });
      expect(result['notes_json'], isA<Map<String, dynamic>>());
      expect((result['notes_json'] as Map<String, dynamic>)['bpm'], 120);
    });

    test('sets notes_json to null when it is an invalid string', () {
      final result = normalizeSongData({
        'id': '1',
        'title': 'Test',
        'difficulty': 'easy',
        'duration_seconds': 30,
        'is_premium': false,
        'notes_json': 'not-valid-json',
      });
      expect(result['notes_json'], isNull);
    });

    test('preserves notes_json when it is already a map', () {
      final result = normalizeSongData({
        'id': '1',
        'title': 'Test',
        'difficulty': 'easy',
        'duration_seconds': 30,
        'is_premium': false,
        'notes_json': {'bpm': 120, 'notes': []},
      });
      expect(result['notes_json'], isA<Map<String, dynamic>>());
      expect((result['notes_json'] as Map<String, dynamic>)['bpm'], 120);
    });
  });

  group('parseNotes', () {
    test('parses notes from a map with a notes list', () {
      final result = parseNotes({
        'bpm': 120,
        'notes': [
          {'note': 'A4', 'top': [], 'bot': [], 'sub': [], 'middle': [], 'timestamp_ms': 0, 'duration_ms': 1000, 'note_value': '1'},
          {'note': 'B4', 'top': [], 'bot': [], 'sub': [], 'middle': [], 'timestamp_ms': 1000, 'duration_ms': 1000, 'note_value': '1'},
        ],
      });
      expect(result.length, 2);
      expect(result[0].note, 'A4');
      expect(result[1].note, 'B4');
    });

    test('throws FormatException when no notes array exists', () {
      expect(
        () => parseNotes({'bpm': 120}),
        throwsA(isA<FormatException>()),
      );
    });
  });
}