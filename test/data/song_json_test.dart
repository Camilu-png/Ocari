import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'package:ocari/features/songs/domain/models/song.dart';
import 'package:ocari/features/songs/domain/models/song_note.dart';

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

  group('Song.fromJson', () {
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

      final song = Song.fromJson(map);
      expect(song.id, map['id']);
      expect(song.title, "Zelda's Lullaby");
      expect(song.artist, 'The Legend of Zelda: Ocarina of Time');
      expect(song.difficulty, 'easy');
      expect(song.durationSeconds, 75);
      expect(song.isPremium, false);
      expect(song.audioPath, 'https://example.com/audio/zeldas_lullaby.mp3');
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

      final song = Song.fromJson(map);
      expect(song.id, 'abc-123');
      expect(song.title, 'Test Song');
      expect(song.artist, 'Desconocido');
      expect(song.difficulty, 'hard');
      expect(song.durationSeconds, 120);
      expect(song.isPremium, true);
      expect(song.audioPath, isNull);
      expect(song.notesJson, isNull);
    });

    test('parses is_premium correctly', () {
      final map = {
        'id': '1',
        'title': 'Premium Song',
        'difficulty': 'medium',
        'duration_seconds': 60,
        'is_premium': true,
      };

      final song = Song.fromJson(map);
      expect(song.isPremium, true);
    });

    test('defaults artist to Desconocido when missing', () {
      final map = {
        'id': '1',
        'title': 'Test',
        'difficulty': 'easy',
        'duration_seconds': 30,
      };

      final song = Song.fromJson(map);
      expect(song.artist, 'Desconocido');
    });

    test('defaults artist to Desconocido when artist is null', () {
      final map = {
        'id': '1',
        'title': 'Test',
        'difficulty': 'easy',
        'duration_seconds': 30,
        'artist': null,
      };

      final song = Song.fromJson(map);
      expect(song.artist, 'Desconocido');
    });

    test('stores null when notes_json is null', () {
      final map = {
        'id': '1',
        'title': 'Test',
        'difficulty': 'easy',
        'duration_seconds': 30,
      };

      final song = Song.fromJson(map);
      expect(song.notesJson, isNull);
    });
  });

  group('SongNote.fromJson', () {
    test('parses a song note correctly', () {
      final map = {
        'note': 'E5',
        'top': [1, 1, 1, 1],
        'bot': [1, 1, 0, 0],
        'sub': [1, 1],
        'middle': [0, 0],
        'timestamp_ms': 560,
        'duration_ms': 1086,
        'note_value': 'half',
      };

      final note = SongNote.fromJson(map);
      expect(note.note, 'E5');
      expect(note.top, [1, 1, 1, 1]);
      expect(note.bot, [1, 1, 0, 0]);
      expect(note.sub, [1, 1]);
      expect(note.middle, [0, 0]);
      expect(note.timestampMs, 560);
      expect(note.durationMs, 1086);
      expect(note.noteValue, 'half');
    });
  });
}
