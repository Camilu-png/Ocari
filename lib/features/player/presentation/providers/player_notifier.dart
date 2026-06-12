import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart' hide PlayerState;

import 'package:ocari/features/player/data/player_cache.dart';
import 'package:ocari/features/player/domain/models/player_state.dart';
import 'package:ocari/features/songs/domain/models/difficulty.dart';
import 'package:ocari/features/songs/domain/models/song.dart';
import 'package:ocari/features/songs/domain/models/song_note.dart';

final playerNotifierProvider =
    NotifierProvider<PlayerNotifier, PlayerState>(PlayerNotifier.new);

class PlayerNotifier extends Notifier<PlayerState> {
  AudioPlayer? _player;
  StreamSubscription? _playerStateSub;
  StreamSubscription? _positionSub;
  List<SongNote> _notes = [];
  String? _currentSongId;
  bool _audioReady = false;

  bool get isAudioReady => _audioReady;

  @override
  PlayerState build() {
    ref.onDispose(() {
      _playerStateSub?.cancel();
      _positionSub?.cancel();
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
      );

  Future<void> initialize(Song song, List<SongNote> notes) async {
    if (_currentSongId == song.id) return;
    _currentSongId = song.id;

    _playerStateSub?.cancel();
    _positionSub?.cancel();
    _player?.stop();
    _audioReady = false;

    _notes = notes;
    _player = ref.read(playerCacheProvider).getOrCreate(song.id);

    _playerStateSub = _player!.playerStateStream.listen((ps) {
      if (_currentSongId != song.id) return;
      state = state.copyWith(isPlaying: ps.playing);
    });

    _positionSub = _player!.positionStream.listen((pos) {
      if (_currentSongId != song.id) return;
      final idx = _findCurrentNoteIndex(pos);
      state = state.copyWith(position: pos, currentNoteIndex: idx);
    });

    state = PlayerState(
      song: song,
      notes: notes,
      currentNoteIndex: 0,
      isPlaying: false,
      speed: 1.0,
      position: Duration.zero,
    );

    await _setupAudioSource(song);
    _audioReady = true;
    state = state.copyWith(isAudioReady: true);
  }

  Future<void> _setupAudioSource(Song song) async {
    final audioPath = song.audioPath;
    if (audioPath == null || audioPath.isEmpty) return;

    try {
      if (_player!.audioSource == null) {
        if (audioPath.startsWith('http://') ||
            audioPath.startsWith('https://')) {
          await _player!.setUrl(audioPath);
        } else {
          await _player!.setAsset(audioPath);
        }
      }
    } catch (e) {
      debugPrint('PlayerNotifier: failed to load audio for ${song.id}: $e');
    }
  }

  bool get canPlay => _audioReady && _player != null;

  Future<void> togglePlay() async {
    if (!canPlay) return;
    if (state.isPlaying) {
      await _player!.pause();
    } else {
      final pos = state.position;
      final duration = _player!.duration ?? Duration.zero;
      if (pos >= duration && duration > Duration.zero) {
        await _player!.seek(Duration.zero);
      }
      await _player!.play();
    }
  }

  Future<void> play() async {
    if (!canPlay) return;
    await _player!.play();
  }

  Future<void> pause() async {
    if (!canPlay) return;
    await _player!.pause();
  }

  Future<void> seekTo(Duration position) async {
    if (_player == null) return;
    await _player!.seek(position);
    state = state.copyWith(position: position);
  }

  Future<void> setSpeed(double speed) async {
    if (!canPlay) return;
    await _player!.setSpeed(speed);
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
    if (_player == null) return;
    await _player!.seek(Duration.zero);
    await _player!.pause();
    state = state.copyWith(
      position: Duration.zero,
      currentNoteIndex: 0,
      isPlaying: false,
    );
  }

  Future<void> skipToEnd() async {
    if (_player == null) return;
    final duration = _player!.duration ?? Duration.zero;
    await _player!.seek(duration);
    await _player!.pause();
    state = state.copyWith(position: duration, isPlaying: false);
    if (_notes.isNotEmpty) {
      state = state.copyWith(currentNoteIndex: _notes.length - 1);
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
