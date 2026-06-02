import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'package:ocari/core/difficulty.dart';
import 'package:ocari/features/songs/domain/models/song.dart';

void main() {
  group('Song JSON files', () {
    test('fingerings.json se parsea sin errores', () {
      final file = File('assets/data/fingerings.json');
      expect(file.existsSync(), isTrue, reason: 'File must exist');

      final jsonStr = file.readAsStringSync();
      final data = json.decode(jsonStr);

      expect(data['instrument'], '12-hole ocarina');
      expect(data['tuning'], 'Bb');
      expect(data['notes'], isA<Map>());
      expect(data['notes'].length, greaterThan(0));
    });
  });

  group('Song.fromSupabase', () {
    test('parses a song with all fields', () {
      final map = {
        'id': '123e4567-e89b-12d3-a456-426614174000',
        'title': "Zelda's Lullaby",
        'artist': 'The Legend of Zelda: Ocarina of Time',
        'difficulty': 'easy',
        'duration_seconds': 75,
        'is_premium': false,
        'audio_url': 'https://example.com/audio/zeldas_lullaby.mp3',
        'notes_json': {
          'bpm': 120,
          'time_signature': '4/4',
          'notes': [
            {
              'note': 'E5',
              'top': [1, 1, 1, 1],
              'bot': [1, 1, 0, 0],
              'sub': [1, 1],
              'middle': [0, 0],
              'timestamp_ms': 560,
              'duration_ms': 1086,
              'note_value': 'half',
            },
          ],
        },
      };

      final song = Song.fromSupabase(map);
      expect(song.id, map['id']);
      expect(song.title, "Zelda's Lullaby");
      expect(song.artist, 'The Legend of Zelda: Ocarina of Time');
      expect(song.difficulty, Difficulty.easy);
      expect(song.durationSeconds, 75);
      expect(song.isLocked, false);
      expect(song.audioUrl, 'https://example.com/audio/zeldas_lullaby.mp3');
      expect(song.notesJson, isNotNull);
      expect(song.notesJson!['bpm'], 120);
    });

    test('parses a song with minimal fields', () {
      final map = {
        'id': 'abc-123',
        'title': 'Test Song',
        'difficulty': 'hard',
        'duration_seconds': 120,
        'is_premium': true,
      };

      final song = Song.fromSupabase(map);
      expect(song.id, 'abc-123');
      expect(song.title, 'Test Song');
      expect(song.artist, isNull);
      expect(song.difficulty, Difficulty.hard);
      expect(song.durationSeconds, 120);
      expect(song.isLocked, true);
      expect(song.audioUrl, isNull);
      expect(song.notesJson, isNull);
    });

    test('parses is_premium as isLocked', () {
      final map = {
        'id': '1',
        'title': 'Premium Song',
        'difficulty': 'medium',
        'duration_seconds': 60,
        'is_premium': true,
      };

      final song = Song.fromSupabase(map);
      expect(song.isLocked, true);
    });

    test('parses notes_json as string', () {
      final map = {
        'id': '1',
        'title': 'Test',
        'difficulty': 'easy',
        'duration_seconds': 30,
        'notes_json': '{"bpm":100,"time_signature":"4/4","notes":[]}',
      };

      final song = Song.fromSupabase(map);
      expect(song.notesJson, isNotNull);
      expect(song.notesJson!['bpm'], 100);
    });
  });
}
