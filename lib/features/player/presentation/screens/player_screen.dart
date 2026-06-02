import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

import 'package:ocari/core/widgets/ocari_scaffold.dart';
import 'package:ocari/core/theme/app_theme.dart';
import 'package:ocari/features/songs/domain/models/song.dart';
import 'package:ocari/features/songs/presentation/providers/songs_provider.dart';

class PlayerScreen extends ConsumerStatefulWidget {
  final String songId;

  const PlayerScreen({super.key, required this.songId});

  @override
  ConsumerState<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends ConsumerState<PlayerScreen> {
  final _player = AudioPlayer();
  PlayerState? _playerState;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  bool _audioReady = false;

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _initPlayer(String audioUrl) async {
    if (_audioReady) return;
    try {
      if (audioUrl.startsWith('http://') || audioUrl.startsWith('https://')) {
        await _player.setUrl(audioUrl);
      } else {
        await _player.setAsset(audioUrl);
      }
      _player.playerStateStream.listen((state) {
        if (mounted) setState(() => _playerState = state);
      });
      _player.positionStream.listen((p) {
        if (mounted) setState(() => _position = p);
      });
      _player.durationStream.listen((d) {
        if (mounted) setState(() => _duration = d ?? Duration.zero);
      });
      if (mounted) setState(() => _audioReady = true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load audio: $e')),
        );
      }
    }
  }

  String _fmt(Duration d) {
    final m = d.inMinutes;
    final s = d.inSeconds % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final songAsync = ref.watch(songByIdProvider(widget.songId));
    final isPlaying = _playerState?.playing ?? false;

    ref.listen(songByIdProvider(widget.songId), (_, next) {
      final song = next.valueOrNull;
      if (song != null && song.audioUrl != null) {
        _initPlayer(song.audioUrl!);
      }
    });

    return songAsync.when(
      loading: () => const OcariScaffold(
        title: 'Player',
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (err, _) => OcariScaffold(
        title: 'Player',
        body: Center(child: Text('Failed to load song: $err')),
      ),
      data: (song) {
        if (song == null) {
          return const OcariScaffold(
            title: 'Player',
            body: Center(child: Text('Song not found')),
          );
        }

        return _buildPlayer(colors, song, isPlaying);
      },
    );
  }

  Widget _buildPlayer(AppColors colors, Song song, bool isPlaying) {
    return OcariScaffold(
      title: song.title,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.music_note_rounded, size: 80, color: colors.accent),
            const SizedBox(height: 24),
            Text(song.title, style: AppTextStyles.heading(colors.onBgLight)),
            if (song.artist != null) ...[
              const SizedBox(height: 8),
              Text(song.artist!,
                  style: AppTextStyles.body(colors.textSecondary)),
            ],
            const SizedBox(height: 32),
            if (_duration > Duration.zero)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 48),
                child: Row(
                  children: [
                    Text(_fmt(_position),
                        style: TextStyle(color: colors.textSecondary)),
                    Expanded(
                      child: SliderTheme(
                        data: SliderThemeData(
                          trackHeight: 4,
                          thumbShape: const RoundSliderThumbShape(
                              enabledThumbRadius: 8),
                          overlayShape:
                              const RoundSliderOverlayShape(overlayRadius: 16),
                          activeTrackColor: colors.accent,
                          inactiveTrackColor: colors.accent.withAlpha(64),
                          thumbColor: colors.accent,
                        ),
                        child: Slider(
                          value: _position.inMilliseconds
                              .toDouble()
                              .clamp(0, _duration.inMilliseconds.toDouble()),
                          max: _duration.inMilliseconds.toDouble(),
                          onChanged: (v) =>
                              _player.seek(Duration(milliseconds: v.round())),
                        ),
                      ),
                    ),
                    Text(_fmt(_duration),
                        style: TextStyle(color: colors.textSecondary)),
                  ],
                ),
              ),
            const SizedBox(height: 24),
            if (!_audioReady && song.audioUrl != null)
              const CircularProgressIndicator()
            else
              IconButton(
                iconSize: 64,
                icon: Icon(isPlaying
                    ? Icons.pause_circle_filled
                    : Icons.play_circle_filled),
                color: colors.accent,
                onPressed: () {
                  if (isPlaying) {
                    _player.pause();
                  } else {
                    _player.play();
                  }
                },
              ),
          ],
        ),
      ),
    );
  }
}
