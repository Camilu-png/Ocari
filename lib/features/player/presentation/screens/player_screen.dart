import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ocari/core/theme/app_theme.dart';
import 'package:ocari/core/theme/note_colors.dart';
import 'package:ocari/core/widgets/notes_legend.dart';
import 'package:ocari/core/widgets/notes_track.dart';
import 'package:ocari/core/widgets/ocarina_canvas.dart';
import 'package:ocari/core/widgets/ocari_scaffold.dart';
import 'package:ocari/features/player/domain/models/player_state.dart';
import 'package:ocari/features/player/presentation/providers/player_notifier.dart';
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
  _LoadStage _loadStage = _LoadStage.loading;
  String? _errorMessage;
  List<SongNote> _parsedNotes = [];

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final songAsync = ref.watch(songByIdProvider(widget.songId));
    final playerState = ref.watch(playerNotifierProvider);
    final notifier = ref.read(playerNotifierProvider.notifier);

    ref.listen(songByIdProvider(widget.songId), (_, next) {
      final song = next.valueOrNull;
      if (song != null) _initIfReady(song, notifier);
    });

    return songAsync.when(
      loading: () => _buildLoading(colors, null),
      error: (err, _) => _buildError(colors, null, 'Error al cargar la canción: $err'),
      data: (song) {
        if (song == null) {
          return _buildError(colors, null, 'Canción no encontrada');
        }

        _initIfReady(song, notifier);

        if (_loadStage == _LoadStage.error) {
          return _buildError(colors, song.title, _errorMessage);
        }

        return _buildPlayer(colors, playerState);
      },
    );
  }

  void _initIfReady(Song song, PlayerNotifier notifier) {
    if (_initialized) return;

    if (song.id.isEmpty) {
      _errorMessage = 'ID de canción inválido.';
      _loadStage = _LoadStage.error;
      return;
    }

    if (song.notesJson == null) {
      debugPrint(
        'PlayerScreen: notesJson is null for "${song.title}" (id=${song.id}). '
        'Verify the Supabase "notes_json" column is populated.',
      );
      _errorMessage = 'Esta canción no tiene datos de notas.';
      _loadStage = _LoadStage.error;
      return;
    }

    try {
      _parsedNotes = _parseNotes(song.notesJson!);
    } catch (e) {
      debugPrint(
        'PlayerScreen: failed to parse notes for "${song.title}": $e. '
        'notesJson type=${song.notesJson.runtimeType}',
      );
      _errorMessage = 'Error al procesar las notas: $e';
      _loadStage = _LoadStage.error;
      return;
    }

    if (_parsedNotes.isEmpty) {
      _errorMessage = 'Esta canción no contiene notas.';
      _loadStage = _LoadStage.error;
      return;
    }

    _initialized = true;
    _loadStage = _LoadStage.ready;
    notifier.initialize(song, _parsedNotes);
  }

  List<SongNote> _parseNotes(Map<String, dynamic> notesJson) {
    final notesValue = notesJson['notes'];
    if (notesValue is List) {
      return notesValue
          .map((n) => SongNote.fromJson(n as Map<String, dynamic>))
          .toList();
    }

    final firstValue = notesJson.values.firstOrNull;
    if (firstValue is List) {
      return firstValue
          .map((n) => SongNote.fromJson(n as Map<String, dynamic>))
          .toList();
    }

    final noteList = notesJson.entries
        .where((e) => e.value is List)
        .map((e) => e.value as List)
        .expand((l) => l)
        .map((n) => SongNote.fromJson(n as Map<String, dynamic>))
        .toList();
    if (noteList.isNotEmpty) return noteList;

    throw FormatException(
      'No se encontró un array de notas en notesJson. '
      'Claves disponibles: ${notesJson.keys.join(", ")}',
    );
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
              Icon(Icons.error_outline_rounded,
                  size: 48, color: colors.error),
              const SizedBox(height: 16),
              Text(
                message ?? 'Error desconocido',
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
    final currentNote = state.notes.isNotEmpty &&
            state.currentNoteIndex < state.notes.length
        ? state.notes[state.currentNoteIndex]
        : null;

    return OcariScaffold(
      title: state.song.title,
      actions: [
        _SpeedChip(
          speed: state.speed,
          onSpeedChanged: (speed) {
            ref.read(playerNotifierProvider.notifier).setSpeed(speed);
          },
        ),
      ],
      body: Column(
        children: [
          NotesLegend(notes: state.notes),
          const SizedBox(height: 4),
          Expanded(
            flex: 3,
            child: ClipRect(
              child: NotesTrack(
                notes: state.notes,
                position: state.position,
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
                child: OcarinaCanvas(note: currentNote),
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
                thumbShape:
                    const RoundSliderThumbShape(enabledThumbRadius: 6),
                overlayShape:
                    const RoundSliderOverlayShape(overlayRadius: 12),
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
    final notifier = ref.read(playerNotifierProvider.notifier);
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
                  'Cargando audio…',
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

class _SpeedChip extends ConsumerWidget {
  final double speed;
  final ValueChanged<double> onSpeedChanged;

  const _SpeedChip({
    required this.speed,
    required this.onSpeedChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                  'Velocidad',
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
