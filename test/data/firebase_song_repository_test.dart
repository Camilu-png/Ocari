import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:ocari/features/songs/data/repositories/firebase_song_repository.dart';
import 'package:ocari/features/songs/domain/models/song.dart';
import 'package:ocari/features/songs/domain/models/difficulty.dart';

class MockAssetBundle extends Mock implements AssetBundle {}

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

class TestRepo extends FirebaseSongRepository {
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
        super(MockFirebaseFirestore(), bundle);

  @override
  Future<List<Song>> fetchAllFromFirestore() async {
    if (_throwOnFetchAll) throw Exception('Firestore error');
    return _fetchAllResult ?? [];
  }

  @override
  Future<Song?> fetchByIdFromFirestore(String id) async {
    if (_throwOnFetchById) throw Exception('Firestore error');
    return _fetchByIdResult;
  }
}

void main() {
  late MockAssetBundle mockBundle;

  setUp(() {
    mockBundle = MockAssetBundle();
  });

  group('fetchAll', () {
    test('returns songs from Firestore on success', () async {
      final songs = [
        const Song(
          id: '1',
          title: 'Song One',
          artist: 'Unknown',
          difficulty: Difficulty.easy,
          durationSeconds: 30,
          isPremium: false,
        ),
        const Song(
          id: '2',
          title: 'Song Two',
          artist: 'Artist',
          difficulty: Difficulty.hard,
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

    test('falls back to local assets when Firestore fails', () async {
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
      when(() => mockBundle.loadString(any()))
          .thenThrow(Exception('Asset not found'));

      final repo = TestRepo(bundle: mockBundle, throwOnFetchAll: true);
      final songs = await repo.fetchAll();

      expect(songs, isEmpty);
    });
  });

  group('fetchById', () {
    test('returns song from Firestore on success', () async {
      const song = Song(
        id: '1',
        title: 'Found Song',
        artist: 'Test Artist',
        difficulty: Difficulty.medium,
        durationSeconds: 90,
        isPremium: true,
      );

      final repo = TestRepo(bundle: mockBundle, fetchByIdResult: song);
      final result = await repo.fetchById('1');

      expect(result, isNotNull);
      expect(result!.id, '1');
      expect(result.artist, 'Test Artist');
    });

    test('returns null when Firestore returns null', () async {
      final repo = TestRepo(bundle: mockBundle);
      final result = await repo.fetchById('999');

      expect(result, isNull);
    });

    test('falls back to local assets when Firestore throws', () async {
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
      when(() => mockBundle.loadString(any()))
          .thenThrow(Exception('Asset not found'));

      final repo = TestRepo(bundle: mockBundle, throwOnFetchById: true);
      final song = await repo.fetchById('missing');

      expect(song, isNull);
    });
  });
}