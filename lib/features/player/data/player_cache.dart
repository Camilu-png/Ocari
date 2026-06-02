import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

class PlayerCache {
  final Map<String, AudioPlayer> _players = {};
  final _accessOrder = <String>[];
  static const _maxSize = 5;

  AudioPlayer getOrCreate(String songId) {
    final existing = _players[songId];
    if (existing != null) {
      _accessOrder.remove(songId);
      _accessOrder.add(songId);
      return existing;
    }

    if (_players.length >= _maxSize) {
      final oldest = _accessOrder.removeAt(0);
      _players.remove(oldest)?.dispose();
    }

    final player = AudioPlayer();
    _players[songId] = player;
    _accessOrder.add(songId);
    return player;
  }

  void remove(String songId) {
    _players.remove(songId)?.dispose();
    _accessOrder.remove(songId);
  }

  void disposeAll() {
    for (final player in _players.values) {
      player.dispose();
    }
    _players.clear();
    _accessOrder.clear();
  }
}

final playerCacheProvider = NotifierProvider<PlayerCacheNotifier, PlayerCache>(
  PlayerCacheNotifier.new,
);

class PlayerCacheNotifier extends Notifier<PlayerCache> {
  @override
  PlayerCache build() {
    ref.onDispose(() => state.disposeAll());
    return PlayerCache();
  }
}
