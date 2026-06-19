import 'dart:async';

import 'package:audio_session/audio_session.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

class AudioService {
  final AudioPlayer _player = AudioPlayer();
  final StreamController<void> _completionController =
      StreamController<void>.broadcast();
  StreamSubscription? _completionSub;
  bool _disposed = false;

  AudioService() {
    _configureAudioSession();
    _listenForCompletions();
  }

  Future<void> _configureAudioSession() async {
    try {
      final session = await AudioSession.instance;
      await session.configure(const AudioSessionConfiguration(
        avAudioSessionCategory: AVAudioSessionCategory.playback,
        avAudioSessionCategoryOptions:
            AVAudioSessionCategoryOptions.defaultToSpeaker,
        avAudioSessionMode: AVAudioSessionMode.defaultMode,
        avAudioSessionRouteSharingPolicy:
            AVAudioSessionRouteSharingPolicy.defaultPolicy,
        avAudioSessionSetActiveOptions:
            AVAudioSessionSetActiveOptions.notifyOthersOnDeactivation,
        androidAudioAttributes: AndroidAudioAttributes(
          contentType: AndroidAudioContentType.music,
          usage: AndroidAudioUsage.media,
        ),
        androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
        androidWillPauseWhenDucked: true,
      ));
    } catch (e) {
      debugPrint('AudioService: failed to configure audio session: $e');
    }
  }

  void _listenForCompletions() {
    _completionSub?.cancel();
    _completionSub = _player.playerStateStream.listen((state) {
      if (_disposed) return;
      if (state.processingState == ProcessingState.completed) {
        _completionController.add(null);
      }
    });
  }

  Stream<Duration> get positionStream => _player.positionStream;

  Stream<bool> get playingStream =>
      _player.playerStateStream.map((s) => s.playing).distinct();

  Stream<void> get completionStream => _completionController.stream;

  Duration? get duration => _player.duration;
  bool get isPlaying => _player.playing;

  Future<void> load(String path) async {
    try {
      if (path.isEmpty) return;

      await _player.stop();

      if (path.startsWith('http://') || path.startsWith('https://')) {
        await _player.setUrl(path).timeout(
              const Duration(seconds: 10),
              onTimeout: () =>
                  throw TimeoutException('Audio URL load timed out: $path'),
            );
      } else {
        await _player.setAsset(path).timeout(
              const Duration(seconds: 10),
              onTimeout: () =>
                  throw TimeoutException('Audio asset load timed out: $path'),
            );
      }
    } on TimeoutException {
      debugPrint('AudioService: timeout loading $path');
      rethrow;
    } catch (e) {
      debugPrint('AudioService: failed to load $path: $e');
      rethrow;
    }
  }

  Future<void> play() async {
    try {
      await _player.play();
    } catch (e) {
      debugPrint('AudioService: play failed: $e');
    }
  }

  Future<void> pause() async {
    try {
      await _player.pause();
    } catch (e) {
      debugPrint('AudioService: pause failed: $e');
    }
  }

  Future<void> seek(Duration position) async {
    try {
      await _player.seek(position);
    } catch (e) {
      debugPrint('AudioService: seek to $position failed: $e');
    }
  }

  Future<void> setSpeed(double speed) async {
    try {
      await _player.setSpeed(speed);
    } catch (e) {
      debugPrint('AudioService: setSpeed($speed) failed: $e');
    }
  }

  Future<void> dispose() async {
    if (_disposed) return;
    _disposed = true;
    _completionSub?.cancel();
    await _completionController.close();
    _player.dispose();
  }
}

final audioServiceProvider = Provider<AudioService>((ref) {
  final service = AudioService();
  ref.onDispose(() => service.dispose());
  return service;
});
