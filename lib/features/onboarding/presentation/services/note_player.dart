import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

class NotePlayer {
  final AudioPlayer _player = AudioPlayer();

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
  };

  Future<void> play(String noteName) async {
    final asset = _noteToAsset[noteName];
    if (asset == null) return;
    try {
      await _player.stop();
      await _player.setAsset(asset);
      await _player.play();
    } catch (e) {
      debugPrint('NotePlayer: failed to play $noteName: $e');
    }
  }

  Future<void> dispose() async {
    await _player.dispose();
  }
}
