import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:ocari/core/services/preferences_service.dart';
import 'package:ocari/core/theme/app_theme.dart';
import 'package:ocari/core/theme/note_colors.dart';
import 'package:ocari/core/widgets/notes_legend.dart';
import 'package:ocari/core/widgets/notes_track.dart';
import 'package:ocari/core/widgets/ocarina_canvas.dart';
import 'package:ocari/core/widgets/ocari_scaffold.dart';
import 'package:ocari/features/player/domain/models/player_state.dart';
import 'package:ocari/features/player/presentation/providers/player_notifier.dart';
import 'package:ocari/features/player/presentation/widgets/song_completed_sheet.dart';
import 'package:ocari/features/player/presentation/widgets/tutorial_overlay.dart';
import 'package:ocari/features/songs/data/repositories/supabase_song_repository.dart';
import 'package:ocari/features/songs/domain/models/song.dart';
import 'package:ocari/features/songs/domain/models/song_note.dart';
import 'package:ocari/features/songs/presentation/providers/songs_provider.dart';

enum _LoadStage { loading, ready, error }

class PlayerScreen extends ConsumerStatefulWidget {
  final String songId;

  const PlayerScreen({super.key, required this.songId});

  @override
  ConsumerState<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends ConsumerState<PlayerScreen> {
  bool _initialized = false;
  bool _tutorialShown = false;
  _LoadStage _loadStage = _LoadStage.loading;
  String? _errorMessage;
  List<SongNote> _parsedNotes = [];
  PlayerNotifier? _notifier;

  final _trackKey = GlobalKey();
  final _ocarinaKey = GlobalKey();
  final _legendKey = GlobalKey();
  final _speedChipKey = GlobalKey();
  Song? _currentSong;

  @override
  void dispose() {
    _notifier?.pausePlayback();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final songAsync = ref.watch(songByIdProvider(widget.songId));
    final playerState = ref.watch(playerNotifierProvider);
    _notifier ??= ref.read(playerNotifierProvider.notifier);
    final notifier = _notifier!;

    ref.listen(songByIdProvider(widget.songId), (_, next) {
      final song = next.valueOrNull;
      if (song != null) _initIfReady(song, notifier);
    });

    ref.listen(playerNotifierProvider, (prev, next) {
      if (next.showCompletionSheet && !(prev?.showCompletionSheet ?? false)) {
        final notifier = ref.read(playerNotifierProvider.notifier);
        showSongCompletedSheet(
          context,
          songTitle: next.song.title,
          playCount: next.playCount,
          onPlayAgain: () {
            notifier.dismissCompletionSheet();
            notifier.restart();
          },
          onGoToCatalog: () {
            notifier.dismissCompletionSheet();
            context.pop();
          },
        );
      }
    });

    return songAsync.when(
      loading: () => _buildLoading(colors, null),
      error: (err, _) =>
          _buildError(colors, null, 'Error loading song: $err'),
      data: (song) {
        if (song == null) {
          return _buildError(colors, null, 'Song not found');
        }

        _initIfReady(song, notifier);

        if (_loadStage == _LoadStage.error) {
          return _buildError(colors, song.title, _errorMessage);
        }

        return _buildPlayer(colors, playerState);
      },
    );
  }

  Future<void> _showSongTutorialIfNeeded(Song song) async {
    if (_tutorialShown) return;

    try {
      final service = await ref.read(preferencesServiceProvider.future);
      final seen = await service.hasSeenTutorial(song.id);
      if (!seen && mounted) {
        _tutorialShown = true;
        _showTutorial(song, markSeen: true);
      }
    } catch (_) {}
  }

  void _showTutorial(Song song, {bool markSeen = false}) async {
    PreferencesService? service;
    if (markSeen) {
      try {
        service = await ref.read(preferencesServiceProvider.future);
      } catch (_) {}
    }
    if (!mounted) return;
    TutorialOverlay.show(
      context,
      steps: [
        TutorialStep(
          targetKey: _trackKey,
          text:
              'Aquí verás las notas bajar. Cada color es una nota distinta.',
        ),
        TutorialStep(
          targetKey: _trackKey,
          text:
              'Cuando un bloque llegue aquí, presiona ese hoyo.',
          spotlightHeightFraction: 0.15,
        ),
        TutorialStep(
          targetKey: _ocarinaKey,
          text:
              'Los hoyos se pintan del color de la nota. ¡Presiona los coloreados!',
        ),
        TutorialStep(
          targetKey: _legendKey,
          text: 'Consulta aquí qué nota es cada color.',
        ),
        TutorialStep(
          targetKey: _speedChipKey,
          text:
              'Si va muy rápida, baja la velocidad con este botón.',
        ),
        const TutorialStep(
          text:
              '¡Empecemos despacio! La canción arrancará en ×0.5',
        ),
      ],
      onCompleted: () async {
        if (markSeen) await service?.setTutorialSeen(song.id);
        _notifier?.setSpeed(0.5);
        _notifier?.pause();
      },
      onSkipped: () async {
        if (markSeen) await service?.setTutorialSeen(song.id);
        _notifier?.setSpeed(0.5);
        _notifier?.pause();
      },
    );
  }

  void _initIfReady(Song song, PlayerNotifier notifier) {
    if (_initialized) return;

    if (song.id.isEmpty) {
      _errorMessage = 'Invalid song ID.';
      _loadStage = _LoadStage.error;
      return;
    }

    if (song.notesJson == null) {
      debugPrint(
        'PlayerScreen: notesJson is null for "${song.title}" (id=${song.id}). '
        'Verify the Supabase "notes_json" column is populated.',
      );
      _errorMessage = 'This song has no note data.';
      _loadStage = _LoadStage.error;
      return;
    }

    try {
      _parsedNotes = SupabaseSongRepository.parseNotes(song.notesJson!);
    } catch (e) {
      debugPrint(
        'PlayerScreen: failed to parse notes for "${song.title}": $e. '
        'notesJson type=${song.notesJson.runtimeType}',
      );
      _errorMessage = 'Error processing notes: $e';
      _loadStage = _LoadStage.error;
      return;
    }

    if (_parsedNotes.isEmpty) {
      _errorMessage = 'This song contains no notes.';
      _loadStage = _LoadStage.error;
      return;
    }

    _initialized = true;
    _loadStage = _LoadStage.ready;
    _currentSong = song;
    notifier.initialize(song, _parsedNotes);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showSongTutorialIfNeeded(song);
    });
  }

  Widget _buildLoading(AppColors colors, String? songTitle) {
    return OcariScaffold(
      title: songTitle ?? 'Player',
      body: const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildError(AppColors colors, String? songTitle, String? message) {
    return OcariScaffold(
      title: songTitle ?? 'Player',
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline_rounded, size: 48, color: colors.error),
              const SizedBox(height: 16),
              Text(
                message ?? 'Unknown error',
                style: TextStyle(
                  fontSize: 16,
                  color: colors.onBgLight,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlayer(AppColors colors, PlayerState state) {
    final currentNote =
        state.notes.isNotEmpty && state.currentNoteIndex < state.notes.length
            ? state.notes[state.currentNoteIndex]
            : null;

    return OrientationBuilder(
      builder: (context, orientation) {
        if (orientation == Orientation.landscape) {
          return _buildLandscapeLayout(colors, state, currentNote);
        }
        return _buildPortraitLayout(colors, state, currentNote);
      },
    );
  }

  Widget _buildPortraitLayout(
      AppColors colors, PlayerState state, SongNote? currentNote) {
    return OcariScaffold(
      title: state.song.title,
      actions: [
        IconButton(
          icon: const Icon(Icons.help_outline_rounded, size: 22),
          color: colors.onBgLight,
          tooltip: 'Ver tutorial',
          onPressed: _currentSong != null
              ? () => _showTutorial(_currentSong!)
              : null,
        ),
        KeyedSubtree(
          key: _speedChipKey,
          child: _SpeedChip(
            speed: state.speed,
            onSpeedChanged: (speed) {
              _notifier?.setSpeed(speed);
            },
          ),
        ),
      ],
      body: Column(
        children: [
          KeyedSubtree(
            key: _legendKey,
            child: NotesLegend(notes: state.notes),
          ),
          const SizedBox(height: 4),
          Expanded(
            flex: 3,
            child: ClipRect(
              child: RepaintBoundary(
                child: KeyedSubtree(
                  key: _trackKey,
                  child: NotesTrack(
                    notes: state.notes,
                    position: state.position,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            currentNote?.note ?? '--',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: currentNote != null
                  ? NoteColors.forNote(currentNote.note)
                  : colors.textSecondary,
              fontFamily: '.SF Pro Display',
            ),
          ),
          const SizedBox(height: 4),
          Expanded(
            flex: 2,
            child: Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: KeyedSubtree(
                  key: _ocarinaKey,
                  child: OcarinaCanvas(
                    note: currentNote,
                    showNoteLabel: false,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          _buildProgressBar(colors, state),
          const SizedBox(height: 8),
          _buildTransportControls(colors, state),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildLandscapeLayout(
      AppColors colors, PlayerState state, SongNote? currentNote) {
    return OcariScaffold(
      title: state.song.title,
      actions: [
        IconButton(
          icon: const Icon(Icons.help_outline_rounded, size: 22),
          color: colors.onBgLight,
          tooltip: 'Ver tutorial',
          onPressed: _currentSong != null
              ? () => _showTutorial(_currentSong!)
              : null,
        ),
        KeyedSubtree(
          key: _speedChipKey,
          child: _SpeedChip(
            speed: state.speed,
            onSpeedChanged: (speed) {
              _notifier?.setSpeed(speed);
            },
          ),
        ),
      ],
      body: LayoutBuilder(
        builder: (context, constraints) {
          const overheadHeight = 116.0;
          final availableHeight = constraints.maxHeight;
          final trackAreaHeight =
              (availableHeight - overheadHeight).clamp(150.0, availableHeight);

          return SingleChildScrollView(
            child: Column(
              children: [
                KeyedSubtree(
                  key: _legendKey,
                  child: NotesLegend(notes: state.notes),
                ),
                SizedBox(
                  height: trackAreaHeight,
                  child: Row(
                    children: [
                      Expanded(
                        child: ClipRect(
                          child: RepaintBoundary(
                            child: KeyedSubtree(
                              key: _trackKey,
                              child: NotesTrack(
                                notes: state.notes,
                                position: state.position,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final canvasHeight =
                              (constraints.maxHeight - 30).clamp(60.0, constraints.maxHeight);
                          const aspectRatio = ocarinaSvgW / ocarinaSvgH;
                          return SizedBox(
                            width: canvasHeight * aspectRatio,
                            child: KeyedSubtree(
                              key: _ocarinaKey,
                              child: OcarinaCanvas(
                                note: currentNote,
                                showNoteLabel: false,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  currentNote?.note ?? '--',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: currentNote != null
                        ? NoteColors.forNote(currentNote.note)
                        : colors.textSecondary,
                    fontFamily: '.SF Pro Display',
                  ),
                ),
                const SizedBox(height: 4),
                _buildCompactControls(colors, state),
                const SizedBox(height: 8),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCompactControls(AppColors colors, PlayerState state) {
    final notifier = _notifier!;
    final isAudioReady = state.isAudioReady;
    final duration = state.song.durationSeconds * 1000;
    final maxMs = duration > 0 ? duration.toDouble() : 1.0;
    final posMs = state.position.inMilliseconds.toDouble();

    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 4),
      child: Row(
        children: [
          Text(
            _fmt(state.position),
            style: TextStyle(color: colors.textSecondary, fontSize: 11),
          ),
          Expanded(
            child: SliderTheme(
              data: SliderThemeData(
                trackHeight: 3,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 4),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 8),
                activeTrackColor: colors.accent,
                inactiveTrackColor: colors.accent.withAlpha(64),
                thumbColor: colors.accent,
              ),
              child: Slider(
                value: posMs.clamp(0, maxMs),
                max: maxMs,
                onChanged: (v) {
                  ref
                      .read(playerNotifierProvider.notifier)
                      .seekTo(Duration(milliseconds: v.round()));
                },
              ),
            ),
          ),
          Text(
            _fmt(Duration(milliseconds: duration)),
            style: TextStyle(color: colors.textSecondary, fontSize: 11),
          ),
          const SizedBox(width: 4),
          _transportButton(
            Icons.skip_previous_rounded,
            notifier.canPlay ? () => notifier.skipToStart() : null,
            colors,
            size: 28,
          ),
          _transportButton(
            Icons.fast_rewind_rounded,
            notifier.canPlay ? () => notifier.stepBackward() : null,
            colors,
            size: 28,
          ),
          _transportButton(
            state.isPlaying
                ? Icons.pause_circle_filled_rounded
                : Icons.play_circle_filled_rounded,
            isAudioReady ? () => notifier.togglePlay() : null,
            colors,
            size: 36,
          ),
          _transportButton(
            Icons.fast_forward_rounded,
            notifier.canPlay ? () => notifier.stepForward() : null,
            colors,
            size: 28,
          ),
          _transportButton(
            Icons.skip_next_rounded,
            notifier.canPlay ? () => notifier.skipToEnd() : null,
            colors,
            size: 28,
          ),
          if (!isAudioReady)
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: SizedBox(
                width: 12,
                height: 12,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: colors.textSecondary,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(AppColors colors, PlayerState state) {
    final duration = state.song.durationSeconds * 1000;
    final maxMs = duration > 0 ? duration.toDouble() : 1.0;
    final posMs = state.position.inMilliseconds.toDouble();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Text(
            _fmt(state.position),
            style: TextStyle(color: colors.textSecondary, fontSize: 12),
          ),
          Expanded(
            child: SliderTheme(
              data: SliderThemeData(
                trackHeight: 4,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
                activeTrackColor: colors.accent,
                inactiveTrackColor: colors.accent.withAlpha(64),
                thumbColor: colors.accent,
              ),
              child: Slider(
                value: posMs.clamp(0, maxMs),
                max: maxMs,
                onChanged: (v) {
                  ref
                      .read(playerNotifierProvider.notifier)
                      .seekTo(Duration(milliseconds: v.round()));
                },
              ),
            ),
          ),
          Text(
            _fmt(Duration(milliseconds: duration)),
            style: TextStyle(color: colors.textSecondary, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildTransportControls(AppColors colors, PlayerState state) {
    final notifier = _notifier!;
    final isAudioReady = state.isAudioReady;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _transportButton(
                Icons.skip_previous_rounded,
                notifier.canPlay ? () => notifier.skipToStart() : null,
                colors,
              ),
              const SizedBox(width: 8),
              _transportButton(
                Icons.fast_rewind_rounded,
                notifier.canPlay ? () => notifier.stepBackward() : null,
                colors,
              ),
              const SizedBox(width: 16),
              _transportButton(
                state.isPlaying
                    ? Icons.pause_circle_filled_rounded
                    : Icons.play_circle_filled_rounded,
                isAudioReady ? () => notifier.togglePlay() : null,
                colors,
                size: 56,
              ),
              const SizedBox(width: 16),
              _transportButton(
                Icons.fast_forward_rounded,
                notifier.canPlay ? () => notifier.stepForward() : null,
                colors,
              ),
              const SizedBox(width: 8),
              _transportButton(
                Icons.skip_next_rounded,
                notifier.canPlay ? () => notifier.skipToEnd() : null,
                colors,
              ),
            ],
          ),
          if (!isAudioReady) ...[
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 12,
                  height: 12,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: colors.textSecondary,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Loading audio…',
                  style: TextStyle(
                    fontSize: 12,
                    color: colors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _transportButton(
    IconData icon,
    VoidCallback? onPressed,
    AppColors colors, {
    double size = 40,
  }) {
    final enabled = onPressed != null;
    return IconButton(
      icon: Icon(icon),
      iconSize: size,
      color: enabled ? colors.accent : colors.accent.withAlpha(80),
      onPressed: onPressed,
    );
  }

  String _fmt(Duration d) {
    final m = d.inMinutes;
    final s = d.inSeconds % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }
}

class _SpeedChip extends StatelessWidget {
  final double speed;
  final ValueChanged<double> onSpeedChanged;

  const _SpeedChip({
    required this.speed,
    required this.onSpeedChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return GestureDetector(
      onTap: () => _showSpeedSheet(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: colors.onAccent.withAlpha(30),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          '×${speed.toStringAsFixed(speed == speed.roundToDouble() ? 0 : 2)}',
          style: TextStyle(
            color: colors.onAccent,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  void _showSpeedSheet(BuildContext context) {
    final colors = context.colors;
    const speeds = [0.5, 0.75, 1.0];

    showModalBottomSheet(
      context: context,
      backgroundColor: colors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Speed',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: colors.onBgLight,
                  ),
                ),
                const SizedBox(height: 16),
                for (final s in speeds)
                  ListTile(
                    leading: Icon(
                      s == speed
                          ? Icons.radio_button_checked
                          : Icons.radio_button_off,
                      color: colors.accent,
                    ),
                    title: Text(
                      '×${s.toStringAsFixed(s == s.roundToDouble() ? 0 : 2)}',
                      style: TextStyle(color: colors.onBgLight),
                    ),
                    onTap: () {
                      onSpeedChanged(s);
                      Navigator.of(ctx).pop();
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
