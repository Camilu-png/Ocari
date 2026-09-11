import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ocari/core/services/audio_service.dart';
import 'package:ocari/features/auth/presentation/providers/auth_notifier.dart';
import 'package:ocari/features/player/domain/models/player_state.dart';
import 'package:ocari/features/progress/presentation/providers/progress_providers.dart';
import 'package:ocari/features/songs/domain/models/difficulty.dart';
import 'package:ocari/features/songs/domain/models/song.dart';
import 'package:ocari/features/songs/domain/models/song_note.dart';

final audioPositionProvider = StreamProvider<int>((ref) {
  return ref.watch(audioServiceProvider).positionStream.map((d) => d.inMilliseconds);
});

final playerNotifierProvider =
    NotifierProvider<PlayerNotifier, PlayerState>(PlayerNotifier.new);

class PlayerNotifier extends Notifier<PlayerState> {
  StreamSubscription? _playerStateSub;
  StreamSubscription? _positionSub;
  StreamSubscription? _completionSub;
  List<SongNote> _notes = [];
  String? _currentSongId;
  bool _completionHandled = false;

  @override
  PlayerState build() {
    ref.onDispose(() {
      _playerStateSub?.cancel();
      _positionSub?.cancel();
      _completionSub?.cancel();
    });
    return _emptyState();
  }

  PlayerState _emptyState() => const PlayerState(
        song: Song(
          id: '',
          title: '',
          difficulty: Difficulty.easy,
          durationSeconds: 0,
        ),
        notes: [],
        isAudioReady: false,
        currentNoteIndex: 0,
        isPlaying: false,
        speed: 1.0,
        position: Duration.zero,
        showCompletionSheet: false,
        playCount: 0,
      );

  Future<void> initialize(Song song, List<SongNote> notes) async {
    if (_currentSongId == song.id && state.isAudioReady) {
      _completionHandled = false;
      final audioService = ref.read(audioServiceProvider);
      await audioService.seek(Duration.zero);
      await audioService.pause();
      await audioService.setSpeed(1.0);
      state = state.copyWith(
        position: Duration.zero,
        currentNoteIndex: 0,
        isPlaying: false,
        speed: 1.0,
        showCompletionSheet: false,
        playCount: 0,
        isAudioReady: true,
      );
      return;
    }
    _currentSongId = song.id;
    _completionHandled = false;

    _playerStateSub?.cancel();
    _positionSub?.cancel();
    _completionSub?.cancel();

    state = state.copyWith(isAudioReady: false);

    _notes = notes;
    final audioService = ref.read(audioServiceProvider);

    _playerStateSub = audioService.playingStream.listen((playing) {
      if (_currentSongId != song.id) return;
      state = state.copyWith(isPlaying: playing);
    });

    _positionSub = audioService.positionStream.listen((pos) {
      if (_currentSongId != song.id) return;
      onAudioPosition(pos.inMilliseconds);
    });

    _completionSub = audioService.completionStream.listen((_) {
      if (_currentSongId != song.id) return;
      if (state.isAudioReady && !_completionHandled) {
        _completionHandled = true;
        _handleSongCompletion();
      }
    });

    state = PlayerState(
      song: song,
      notes: notes,
      currentNoteIndex: 0,
      isPlaying: false,
      speed: 1.0,
      position: Duration.zero,
      showCompletionSheet: false,
      playCount: 0,
    );

    await audioService.load(song.audioPath ?? '');
    state = state.copyWith(isAudioReady: true);
  }

  bool get canPlay => state.isAudioReady;

  void onAudioPosition(int ms) {
    final pos = Duration(milliseconds: ms);
    final idx = _findCurrentNoteIndex(pos);
    state = state.copyWith(position: pos, currentNoteIndex: idx);
  }

  Future<void> togglePlay() async {
    if (!canPlay) return;
    final audioService = ref.read(audioServiceProvider);
    if (state.isPlaying) {
      await audioService.pause();
    } else {
      final pos = state.position;
      final duration = audioService.duration ?? Duration.zero;
      if (pos >= duration && duration > Duration.zero) {
        await audioService.seek(Duration.zero);
      }
      await audioService.play();
    }
  }

  Future<void> play() async {
    if (!canPlay) return;
    await ref.read(audioServiceProvider).play();
  }

  Future<void> pause() async {
    if (!canPlay) return;
    await ref.read(audioServiceProvider).pause();
  }

  Future<void> pausePlayback() async {
    if (!canPlay) return;
    await ref.read(audioServiceProvider).pause();
  }

  Future<void> seekTo(Duration position) async {
    await ref.read(audioServiceProvider).seek(position);
    state = state.copyWith(position: position);
  }

  Future<void> setSpeed(double speed) async {
    if (!canPlay) return;
    await ref.read(audioServiceProvider).setSpeed(speed);
    state = state.copyWith(speed: speed);
  }

  Future<void> stepForward() async {
    if (_notes.isEmpty) return;
    final nextIdx = (state.currentNoteIndex + 1).clamp(0, _notes.length - 1);
    final nextNote = _notes[nextIdx];
    await seekTo(Duration(milliseconds: nextNote.timestampMs));
    state = state.copyWith(currentNoteIndex: nextIdx);
  }

  Future<void> stepBackward() async {
    if (_notes.isEmpty) return;
    final prevIdx = (state.currentNoteIndex - 1).clamp(0, _notes.length - 1);
    final prevNote = _notes[prevIdx];
    await seekTo(Duration(milliseconds: prevNote.timestampMs));
    state = state.copyWith(currentNoteIndex: prevIdx);
  }

  Future<void> skipToStart() async {
    final audioService = ref.read(audioServiceProvider);
    await audioService.seek(Duration.zero);
    await audioService.pause();
    state = state.copyWith(
      position: Duration.zero,
      currentNoteIndex: 0,
      isPlaying: false,
    );
  }

  Future<void> skipToEnd() async {
    final audioService = ref.read(audioServiceProvider);
    final duration = audioService.duration ?? Duration.zero;
    await audioService.seek(duration);
    await audioService.pause();
    state = state.copyWith(position: duration, isPlaying: false);
    if (_notes.isNotEmpty) {
      state = state.copyWith(currentNoteIndex: _notes.length - 1);
    }
  }

  Future<void> restart() async {
    if (!canPlay) return;
    _completionHandled = false;
    final audioService = ref.read(audioServiceProvider);
    await audioService.seek(Duration.zero);
    await audioService.play();
    state = state.copyWith(
      position: Duration.zero,
      currentNoteIndex: 0,
      isPlaying: true,
      showCompletionSheet: false,
    );
  }

  void dismissCompletionSheet() {
    state = state.copyWith(showCompletionSheet: false);
  }

  Future<void> _handleSongCompletion() async {
    try {
      final authState = ref.read(authProvider);
      final userId = authState.user?.uid;
      if (userId == null) return;

      final repo = ref.read(userSongProgressRepositoryProvider);
      final progress = await repo.recordCompletion(
        userId: userId,
        songId: state.song.id,
      );
      state = state.copyWith(
        playCount: progress.playCount,
        showCompletionSheet: true,
      );
    } catch (e) {
      debugPrint('PlayerNotifier: failed to record song completion: $e');
      state = state.copyWith(
        playCount: state.playCount + 1,
        showCompletionSheet: true,
      );
    }
  }

  int _findCurrentNoteIndex(Duration position) {
    if (_notes.isEmpty) return 0;
    final posMs = position.inMilliseconds;
    int lo = 0;
    int hi = _notes.length - 1;
    int result = 0;
    while (lo <= hi) {
      final mid = (lo + hi) ~/ 2;
      if (_notes[mid].timestampMs <= posMs) {
        result = mid;
        lo = mid + 1;
      } else {
        hi = mid - 1;
      }
    }
    return result;
  }
}
