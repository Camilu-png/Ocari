import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

import 'package:ocari/features/songs/data/repositories/supabase_song_repository.dart';
import 'package:ocari/features/songs/domain/models/song.dart';

class MockAssetBundle extends Mock implements AssetBundle {}

class MockSupabaseClient extends Mock implements supabase.SupabaseClient {}

class TestRepo extends SupabaseSongRepository {
  final List<Song>? _fetchAllResult;
  final Song? _fetchByIdResult;
  final bool _throwOnFetchAll;
  final bool _throwOnFetchById;

  TestRepo({
    required AssetBundle bundle,
    List<Song>? fetchAllResult,
    Song? fetchByIdResult,
    bool throwOnFetchAll = false,
    bool throwOnFetchById = false,
  })  : _fetchAllResult = fetchAllResult,
        _fetchByIdResult = fetchByIdResult,
        _throwOnFetchAll = throwOnFetchAll,
        _throwOnFetchById = throwOnFetchById,
        super(MockSupabaseClient(), bundle);

  @override
  Future<List<Song>> fetchAllFromSupabase() async {
    if (_throwOnFetchAll) throw Exception('Supabase error');
    return _fetchAllResult ?? [];
  }

  @override
  Future<Song?> fetchByIdFromSupabase(String id) async {
    if (_throwOnFetchById) throw Exception('Supabase error');
    return _fetchByIdResult;
  }
}

void main() {
  late MockAssetBundle mockBundle;

  setUp(() {
    mockBundle = MockAssetBundle();
  });

  group('normalize', () {
    test('defaults artist to Desconocido when missing', () {
      final result = SupabaseSongRepository.normalize({
        'id': '1',
        'title': 'Test',
        'difficulty': 'easy',
        'duration_seconds': 30,
        'is_premium': false,
      });
      expect(result['artist'], 'Desconocido');
    });

    test('preserves artist when present', () {
      final result = SupabaseSongRepository.normalize({
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
      final result = SupabaseSongRepository.normalize({
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
      final result = SupabaseSongRepository.normalize({
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
      final result = SupabaseSongRepository.normalize({
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

  group('fetchAll', () {
    test('returns songs from Supabase on success', () async {
      final songs = [
        const Song(
          id: '1',
          title: 'Song One',
          artist: 'Desconocido',
          difficulty: 'easy',
          durationSeconds: 30,
          isPremium: false,
        ),
        const Song(
          id: '2',
          title: 'Song Two',
          artist: 'Artist',
          difficulty: 'hard',
          durationSeconds: 60,
          isPremium: true,
          audioPath: 'https://example.com/audio.mp3',
        ),
      ];

      final repo = TestRepo(bundle: mockBundle, fetchAllResult: songs);
      final result = await repo.fetchAll();

      expect(result.length, 2);
      expect(result[0].id, '1');
      expect(result[1].artist, 'Artist');
    });

    test('falls back to local assets when Supabase fails', () async {
      when(() => mockBundle.loadString('assets/data/songs_index.json'))
          .thenAnswer((_) async => '["song_a"]');
      when(() => mockBundle.loadString('assets/data/songs/song_a.json'))
          .thenAnswer((_) async => jsonEncode({
                'title': 'Local Song',
                'difficulty': 'medium',
                'duration_seconds': 45,
                'is_premium': false,
              }));

      final repo = TestRepo(bundle: mockBundle, throwOnFetchAll: true);
      final songs = await repo.fetchAll();

      expect(songs.length, 1);
      expect(songs[0].id, 'song_a');
      expect(songs[0].title, 'Local Song');
    });

    test('returns empty list when both sources fail', () async {
      when(() => mockBundle.loadString(any())).thenThrow(Exception('Asset not found'));

      final repo = TestRepo(bundle: mockBundle, throwOnFetchAll: true);
      final songs = await repo.fetchAll();

      expect(songs, isEmpty);
    });
  });

  group('fetchById', () {
    test('returns song from Supabase on success', () async {
      const song = Song(
        id: '1',
        title: 'Found Song',
        artist: 'Test Artist',
        difficulty: 'medium',
        durationSeconds: 90,
        isPremium: true,
      );

      final repo = TestRepo(bundle: mockBundle, fetchByIdResult: song);
      final result = await repo.fetchById('1');

      expect(result, isNotNull);
      expect(result!.id, '1');
      expect(result.artist, 'Test Artist');
    });

    test('returns null when Supabase returns null', () async {
      final repo = TestRepo(bundle: mockBundle);
      final result = await repo.fetchById('999');

      expect(result, isNull);
    });

    test('falls back to local assets when Supabase throws', () async {
      when(() => mockBundle.loadString('assets/data/songs/local_id.json'))
          .thenAnswer((_) async => jsonEncode({
                'title': 'Local Fallback',
                'difficulty': 'easy',
                'duration_seconds': 30,
                'is_premium': false,
              }));

      final repo = TestRepo(bundle: mockBundle, throwOnFetchById: true);
      final song = await repo.fetchById('local_id');

      expect(song, isNotNull);
      expect(song!.id, 'local_id');
      expect(song.title, 'Local Fallback');
    });

    test('returns null when both sources fail', () async {
      when(() => mockBundle.loadString(any())).thenThrow(Exception('Asset not found'));

      final repo = TestRepo(bundle: mockBundle, throwOnFetchById: true);
      final song = await repo.fetchById('missing');

      expect(song, isNull);
    });
  });
}
