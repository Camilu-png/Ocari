import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

class NotePlayer {
  static const Map<String, String> _noteToAsset = {
    'A4': 'assets/audio/notes/A4.wav',
    'As4': 'assets/audio/notes/As4.wav',
    'Bf4': 'assets/audio/notes/As4.wav',
    'B4': 'assets/audio/notes/B4.wav',
    'C5': 'assets/audio/notes/C5.wav',
    'Cs5': 'assets/audio/notes/Cs5.wav',
    'Df5': 'assets/audio/notes/Cs5.wav',
    'D5': 'assets/audio/notes/D5.wav',
    'Ds5': 'assets/audio/notes/Ds5.wav',
    'Ef5': 'assets/audio/notes/Ds5.wav',
    'E5': 'assets/audio/notes/E5.wav',
    'F5': 'assets/audio/notes/F5.wav',
    'Fs5': 'assets/audio/notes/Fs5.wav',
    'Gf5': 'assets/audio/notes/Fs5.wav',
    'G5': 'assets/audio/notes/G5.wav',
    'Gs5': 'assets/audio/notes/Gs5.wav',
    'Af5': 'assets/audio/notes/Gs5.wav',
    'A5': 'assets/audio/notes/A5.wav',
    'As5': 'assets/audio/notes/As5.wav',
    'Bf5': 'assets/audio/notes/As5.wav',
    'B5': 'assets/audio/notes/B5.wav',
    'C6': 'assets/audio/notes/C6.wav',
    'Cs6': 'assets/audio/notes/Cs6.wav',
    'Df6': 'assets/audio/notes/Cs6.wav',
    'D6': 'assets/audio/notes/D6.wav',
    'Ds6': 'assets/audio/notes/Ds6.wav',
    'Ef6': 'assets/audio/notes/Ds6.wav',
    'E6': 'assets/audio/notes/E6.wav',
    'F6': 'assets/audio/notes/F6.wav',
  };

  static const List<String> _preloadNotes = [
    'C5', 'D5', 'E5', 'F5', 'G5', 'A5', 'F6',
  ];

  final Map<String, AudioPlayer> _preloaded = {};
  final AudioPlayer _fallbackPlayer = AudioPlayer();
  AudioPlayer? _activePlayer;
  Timer? _stopTimer;
  int _generation = 0;

  NotePlayer() {
    for (final note in _preloadNotes) {
      final asset = _noteToAsset[note];
      if (asset == null) continue;
      final player = AudioPlayer();
      player.setAsset(asset);
      _preloaded[note] = player;
    }
  }

  Future<void> play(String noteName, {Duration? duration}) async {
    final generation = ++_generation;
    _stopTimer?.cancel();

    final asset = _noteToAsset[noteName];
    if (asset == null) return;

    final player = _preloaded[noteName] ?? _fallbackPlayer;
    final previous = _activePlayer;
    _activePlayer = player;
    if (previous != null && previous != player) {
      unawaited(previous.stop().catchError((Object e) {
        debugPrint('NotePlayer: failed to stop previous note: $e');
      }));
    }

    try {
      if (player == _fallbackPlayer) {
        await player.setAsset(asset);
      }
      await player.seek(Duration.zero);
      if (generation != _generation) return;
      unawaited(player.play().catchError((Object e) {
        debugPrint('NotePlayer: failed to start $noteName: $e');
      }));
      if (duration != null) {
        _stopTimer = Timer(duration, () {
          if (generation == _generation && _activePlayer == player) {
            _activePlayer = null;
            unawaited(player.stop().catchError((Object e) {
              debugPrint('NotePlayer: failed to stop $noteName: $e');
            }));
          }
        });
      }
    } catch (e) {
      debugPrint('NotePlayer: failed to play $noteName: $e');
    }
  }

  Future<void> stop() async {
    _generation++;
    _stopTimer?.cancel();
    final active = _activePlayer;
    _activePlayer = null;
    if (active != null) {
      await active.stop();
    } else {
      await _fallbackPlayer.stop();
    }
  }

  Future<void> stopNote(String noteName) async {
    _generation++;
    _stopTimer?.cancel();
    final player = _preloaded[noteName] ?? _fallbackPlayer;
    if (_activePlayer == player) {
      _activePlayer = null;
    }
    await player.stop();
  }

  Future<void> dispose() async {
    _stopTimer?.cancel();
    _generation++;
    for (final player in _preloaded.values) {
      await player.dispose();
    }
    await _fallbackPlayer.dispose();
  }
}
