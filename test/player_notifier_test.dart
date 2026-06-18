import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ocari/core/services/audio_service.dart';
import 'package:ocari/features/player/presentation/providers/player_notifier.dart';
import 'package:ocari/features/songs/domain/models/difficulty.dart';
import 'package:ocari/features/songs/domain/models/song.dart';
import 'package:ocari/features/songs/domain/models/song_note.dart';

class MockAudioService extends Mock implements AudioService {}

class _Fixtures {
  static const noteC4 = SongNote(
    note: 'C4',
    top: [1, 0, 0, 0],
    bot: [0, 0, 0, 0],
    sub: [0, 0],
    middle: [0, 0],
    timestampMs: 0,
    durationMs: 1000,
    noteValue: 'quarter',
  );
  static const noteD4 = SongNote(
    note: 'D4',
    top: [1, 1, 0, 0],
    bot: [0, 0, 0, 0],
    sub: [0, 0],
    middle: [0, 0],
    timestampMs: 1000,
    durationMs: 1000,
    noteValue: 'quarter',
  );
  static const noteE4 = SongNote(
    note: 'E4',
    top: [1, 1, 1, 0],
    bot: [0, 0, 0, 0],
    sub: [0, 0],
    middle: [0, 0],
    timestampMs: 2000,
    durationMs: 1000,
    noteValue: 'quarter',
  );
  static const song = Song(
    id: 'test-song',
    title: 'Test',
    difficulty: Difficulty.easy,
    durationSeconds: 30,
    audioPath: 'assets/audio/test.mp3',
  );
  static const notes = [noteC4, noteD4, noteE4];
}

void main() {
  late MockAudioService mockAudioService;

  setUpAll(() {
    registerFallbackValue(Duration.zero);
  });

  setUp(() {
    mockAudioService = MockAudioService();
    when(() => mockAudioService.positionStream)
        .thenAnswer((_) => const Stream.empty());
    when(() => mockAudioService.playingStream)
        .thenAnswer((_) => const Stream.empty());
    when(() => mockAudioService.completionStream)
        .thenAnswer((_) => const Stream.empty());
    when(() => mockAudioService.load(any())).thenAnswer((_) async {});
    when(() => mockAudioService.play()).thenAnswer((_) async {});
    when(() => mockAudioService.pause()).thenAnswer((_) async {});
    when(() => mockAudioService.seek(any())).thenAnswer((_) async {});
    when(() => mockAudioService.setSpeed(any())).thenAnswer((_) async {});
    when(() => mockAudioService.duration).thenReturn(Duration.zero);
    when(() => mockAudioService.isPlaying).thenReturn(false);
  });

  group('PlayerNotifier initial state', () {
    test('has empty song and default values', () {
      final container = ProviderContainer(
        overrides: [
          audioServiceProvider.overrideWithValue(mockAudioService),
        ],
      );
      addTearDown(() => container.dispose());

      final state = container.read(playerNotifierProvider);
      expect(state.song.id, '');
      expect(state.notes, isEmpty);
      expect(state.currentNoteIndex, 0);
      expect(state.isPlaying, false);
      expect(state.speed, 1.0);
      expect(state.position, Duration.zero);
      expect(state.isAudioReady, false);
      expect(state.showCompletionSheet, false);
      expect(state.playCount, 0);
    });
  });

  group('PlayerNotifier onAudioPosition', () {
    test('updates currentNoteIndex when position advances', () async {
      final container = ProviderContainer(
        overrides: [
          audioServiceProvider.overrideWithValue(mockAudioService),
        ],
      );
      addTearDown(() => container.dispose());

      final notifier = container.read(playerNotifierProvider.notifier);
      await notifier.initialize(_Fixtures.song, _Fixtures.notes);

      notifier.onAudioPosition(0);
      expect(
        container.read(playerNotifierProvider).currentNoteIndex,
        0,
        reason: 'at 0ms should be on first note',
      );

      notifier.onAudioPosition(500);
      expect(
        container.read(playerNotifierProvider).currentNoteIndex,
        0,
        reason: 'at 500ms should still be on first note',
      );

      notifier.onAudioPosition(1500);
      expect(
        container.read(playerNotifierProvider).currentNoteIndex,
        1,
        reason: 'at 1500ms should be on second note',
      );

      notifier.onAudioPosition(2500);
      expect(
        container.read(playerNotifierProvider).currentNoteIndex,
        2,
        reason: 'at 2500ms should be on third note',
      );
    });

    test('stays at last note when position exceeds all timestamps', () async {
      final container = ProviderContainer(
        overrides: [
          audioServiceProvider.overrideWithValue(mockAudioService),
        ],
      );
      addTearDown(() => container.dispose());

      final notifier = container.read(playerNotifierProvider.notifier);
      await notifier.initialize(_Fixtures.song, _Fixtures.notes);

      notifier.onAudioPosition(10000);
      expect(
        container.read(playerNotifierProvider).currentNoteIndex,
        2,
        reason: 'beyond last note should clamp to last index',
      );
    });

    test('updates position in state', () async {
      final container = ProviderContainer(
        overrides: [
          audioServiceProvider.overrideWithValue(mockAudioService),
        ],
      );
      addTearDown(() => container.dispose());

      final notifier = container.read(playerNotifierProvider.notifier);
      await notifier.initialize(_Fixtures.song, _Fixtures.notes);

      notifier.onAudioPosition(1500);
      expect(
        container.read(playerNotifierProvider).position,
        const Duration(milliseconds: 1500),
      );
    });
  });

  group('PlayerNotifier setSpeed', () {
    test('updates PlayerState.speed and delegates to AudioService', () async {
      final container = ProviderContainer(
        overrides: [
          audioServiceProvider.overrideWithValue(mockAudioService),
        ],
      );
      addTearDown(() => container.dispose());

      final notifier = container.read(playerNotifierProvider.notifier);
      await notifier.initialize(_Fixtures.song, _Fixtures.notes);

      await notifier.setSpeed(0.5);
      expect(container.read(playerNotifierProvider).speed, 0.5);
      verify(() => mockAudioService.setSpeed(0.5)).called(1);

      await notifier.setSpeed(1.0);
      expect(container.read(playerNotifierProvider).speed, 1.0);
      verify(() => mockAudioService.setSpeed(1.0)).called(1);
    });
  });
}
