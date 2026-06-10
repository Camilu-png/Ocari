import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import 'app_theme.dart';
import 'package:ocari/core/widgets/difficulty_badge.dart';
import 'package:ocari/core/widgets/ocari_button.dart';
import 'package:ocari/core/widgets/ocari_scaffold.dart';
import 'package:ocari/core/widgets/ocari_text_field.dart';
import 'package:ocari/core/widgets/song_card.dart';
import 'package:ocari/features/player/presentation/widgets/notes_track.dart';
import 'package:ocari/features/player/presentation/widgets/ocarina_canvas.dart';
import 'package:ocari/features/songs/domain/models/difficulty.dart';
import 'package:ocari/features/songs/domain/models/song_note.dart';

class DebugScreen extends StatelessWidget {
  const DebugScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Debug'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.go('/login'),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Theme Tokens',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            _buildColorSection(context, 'Current Theme', colors),
            const SizedBox(height: 24),
            _buildColorSection(context, 'Light Theme', AppColors.light),
            const SizedBox(height: 24),
            _buildColorSection(context, 'Dark Theme', AppColors.dark),
            const SizedBox(height: 24),
            _buildSpacingSection(context),
            const SizedBox(height: 24),
            _buildButtonsSection(context),
            const SizedBox(height: 24),
            _buildDifficultySection(context, colors),
            const SizedBox(height: 24),
            const _TextFieldsPreview(),
            const SizedBox(height: 24),
            _buildScaffoldSection(context),
            const SizedBox(height: 24),
            _buildSongCardsSection(),
            const SizedBox(height: 24),
            const _OcarinaPreviewSection(),
            const SizedBox(height: 24),
            const _NotesTrackPreviewSection(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildColorSection(
    BuildContext context,
    String title,
    AppColors colors,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _ColorChip('primary', colors.primary),
            _ColorChip('onPrimary', colors.onPrimary),
            _ColorChip('accent', colors.accent),
            _ColorChip('onAccent', colors.onAccent),
            _ColorChip('bgDark', colors.bgDark),
            _ColorChip('onBgDark', colors.onBgDark),
            _ColorChip('bgLight', colors.bgLight),
            _ColorChip('onBgLight', colors.onBgLight),
            _ColorChip('surface', colors.surface),
            _ColorChip('textSecondary', colors.textSecondary),
            _ColorChip('error', colors.error),
          ],
        ),
      ],
    );
  }

  Widget _buildSpacingSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Spacing', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        ...[
          ('xs', AppSpacing.xs),
          ('sm', AppSpacing.sm),
          ('md', AppSpacing.md),
          ('lg', AppSpacing.lg),
          ('xl', AppSpacing.xl),
        ].map(
          (e) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Container(
                  width: e.$2,
                  height: 20,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  '${e.$1} = ${e.$2}px',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildButtonsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Buttons', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 16),
        OcariButton(
          label: 'Default Button',
          onPressed: () {},
        ),
        const SizedBox(height: 12),
        const OcariButton(
          label: 'Loading Button',
          isLoading: true,
        ),
        const SizedBox(height: 12),
        const OcariButton(
          label: 'Disabled Button',
          onPressed: null,
        ),
        const SizedBox(height: 12),
        OcariButton(
          label: 'Not Full Width',
          isFullWidth: false,
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildDifficultySection(BuildContext context, AppColors colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Difficulty Colors',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _ColorChip('easyBg', colors.diffEasyBg),
            _ColorChip('easyText', colors.diffEasyText),
            _ColorChip('mediumBg', colors.diffMediumBg),
            _ColorChip('mediumText', colors.diffMediumText),
            _ColorChip('hardBg', colors.diffHardBg),
            _ColorChip('hardText', colors.diffHardText),
          ],
        ),
        const SizedBox(height: 16),
        const Wrap(
          spacing: 12,
          runSpacing: 8,
          children: [
            DifficultyBadge(difficulty: Difficulty.easy),
            DifficultyBadge(difficulty: Difficulty.medium),
            DifficultyBadge(difficulty: Difficulty.hard),
          ],
        ),
      ],
    );
  }

  Widget _buildScaffoldSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Scaffold', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 16),
        OcariButton(
          label: 'Open Scaffold Preview',
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const _ScaffoldPreviewRoute(),
              ),
            );
          },
          isFullWidth: false,
        ),
      ],
    );
  }

  Widget _buildSongCardsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Song Cards'),
        const SizedBox(height: 16),
        SongCard(
          title: 'Twinkle Twinkle',
          artist: 'Mozart',
          difficulty: Difficulty.easy,
          durationSeconds: 120,
          onTap: () {},
        ),
        const SizedBox(height: 8),
        SongCard(
          title: 'Moonlight Sonata',
          artist: 'Beethoven',
          difficulty: Difficulty.medium,
          durationSeconds: 420,
          onTap: () {},
        ),
        const SizedBox(height: 8),
        SongCard(
          title: 'Flight of the Bumblebee',
          artist: 'Rimsky-Korsakov',
          difficulty: Difficulty.hard,
          durationSeconds: 90,
          onTap: () {},
        ),
        const SizedBox(height: 8),
        SongCard(
          title: 'Locked Song',
          artist: 'Unknown',
          difficulty: Difficulty.hard,
          durationSeconds: 180,
          isLocked: true,
          onTap: () {},
        ),
      ],
    );
  }
}

class _ScaffoldPreviewRoute extends StatelessWidget {
  const _ScaffoldPreviewRoute();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return OcariScaffold(
      title: 'Scaffold Preview',
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'OcariScaffold in action',
              style: context.textTheme.headlineSmall,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'The AppBar uses AppColors.primary as background '
              'with AppTextStyles.heading for the title.',
              style: context.textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Tap back to return to debug screen.',
              style: context.textTheme.bodyMedium?.copyWith(
                color: colors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TextFieldsPreview extends StatefulWidget {
  const _TextFieldsPreview();

  @override
  State<_TextFieldsPreview> createState() => _TextFieldsPreviewState();
}

class _TextFieldsPreviewState extends State<_TextFieldsPreview> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _errorController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _errorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Text Fields', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 16),
        OcariTextField(
          label: 'Email',
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16),
        OcariTextField(
          label: 'Password',
          controller: _passwordController,
          obscureText: true,
        ),
        const SizedBox(height: 16),
        OcariTextField(
          label: 'With Error',
          controller: _errorController,
          errorText: 'This field is required',
        ),
      ],
    );
  }
}

class _ColorChip extends StatelessWidget {
  final String label;
  final Color color;

  const _ColorChip(this.label, this.color);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.black26),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: Theme.of(context).textTheme.labelSmall),
      ],
    );
  }
}

class _OcarinaPreviewSection extends StatefulWidget {
  const _OcarinaPreviewSection();

  @override
  State<_OcarinaPreviewSection> createState() => _OcarinaPreviewSectionState();
}

class _OcarinaPreviewSectionState extends State<_OcarinaPreviewSection> {
  final _noteNames = <String>[
    'A4', 'As4', 'B4', 'C5', 'Cs5', 'D5', 'Ds5', 'E5', 'F5', 'Fs5',
    'G5', 'Gs5', 'A5', 'As5', 'B5', 'C6', 'Cs6', 'D6', 'Ds6', 'E6', 'F6',
  ];

  final Map<String, SongNote> _notes = {};
  int _currentIndex = 0;
  Timer? _timer;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final raw = await rootBundle.loadString('assets/data/fingerings.json');
    final json = jsonDecode(raw) as Map<String, dynamic>;
    final allNotes = json['notes'] as Map<String, dynamic>;

    for (final name in _noteNames) {
      final entry = allNotes[name] as Map<String, dynamic>;
      _notes[name] = SongNote(
        note: name,
        top: (entry['top'] as List).cast<int>(),
        bot: (entry['bot'] as List).cast<int>(),
        sub: (entry['sub'] as List).cast<int>(),
        middle: (entry['middle'] as List).cast<int>(),
        timestampMs: 0,
        durationMs: 500,
        noteValue: 'quarter',
      );
    }

    if (mounted) {
      setState(() => _loaded = true);
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (mounted) {
          setState(() => _currentIndex = (_currentIndex + 1) % _noteNames.length);
        }
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ocarina Canvas',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 16),
        if (!_loaded)
          const SizedBox(
            height: 200,
            child: Center(child: CircularProgressIndicator()),
          )
        else ...[
          Text(
            'Cycling through ${_noteNames.length} notes',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).extension<AppColors>()!.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          OcarinaCanvas(note: _notes[_noteNames[_currentIndex]]),
        ],
      ],
    );
  }
}

class _NotesTrackPreviewSection extends StatefulWidget {
  const _NotesTrackPreviewSection();

  @override
  State<_NotesTrackPreviewSection> createState() =>
      _NotesTrackPreviewSectionState();
}

class _NotesTrackPreviewSectionState
    extends State<_NotesTrackPreviewSection> {
  List<SongNote> _notes = [];
  Duration _position = Duration.zero;
  bool _loaded = false;
  bool _playing = false;
  Timer? _timer;
  int _speedIndex = 0;
  final _speeds = [0.25, 0.5, 0.75, 1.0, 1.5, 2.0];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final raw =
        await rootBundle.loadString('assets/data/songs/binks_sake.json');
    final json = jsonDecode(raw) as Map<String, dynamic>;
    final notesJson = json['notes_json'] as Map<String, dynamic>;
    final notesList = notesJson['notes'] as List<dynamic>;

    _notes = notesList
        .map((n) => SongNote.fromJson(n as Map<String, dynamic>))
        .toList();

    if (mounted) setState(() => _loaded = true);
  }

  void _togglePlay() {
    if (_playing) {
      _timer?.cancel();
    } else {
      final lastNote = _notes.last;
      final totalMs = lastNote.timestampMs + lastNote.durationMs;
      final speed = _speeds[_speedIndex];
      const interval = Duration(milliseconds: 16);
      final stepMs = 16 * speed;

      _timer = Timer.periodic(interval, (_) {
        if (!mounted) return;
        setState(() {
          final next = _position.inMilliseconds + stepMs;
          if (next >= totalMs) {
            _position = Duration(milliseconds: totalMs);
            _timer?.cancel();
            _playing = false;
          } else {
            _position = Duration(milliseconds: next.round());
          }
        });
      });
    }
    setState(() => _playing = !_playing);
  }

  void _reset() {
    _timer?.cancel();
    setState(() {
      _position = Duration.zero;
      _playing = false;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Notes Track',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 16),
        if (!_loaded)
          const SizedBox(
            height: 300,
            child: Center(child: CircularProgressIndicator()),
          )
        else ...[
          SizedBox(
            height: 300,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                color: Theme.of(context).brightness == Brightness.dark
                    ? const Color(0xFF131326)
                    : colors.surface,
                child: NotesTrack(
                  notes: _notes,
                  position: _position,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                _fmt(_position),
                style: TextStyle(color: colors.textSecondary, fontSize: 12),
              ),
              const Spacer(),
              Text(
                '${_position.inMilliseconds ~/ 1000}s',
                style: TextStyle(color: colors.textSecondary, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OcariButton(
                label: _playing ? 'Pause' : 'Play',
                isFullWidth: false,
                onPressed: _loaded ? _togglePlay : null,
              ),
              const SizedBox(width: 12),
              OcariButton(
                label: 'Reset',
                isFullWidth: false,
                onPressed: _loaded ? _reset : null,
              ),
              const SizedBox(width: 12),
              Text(
                '${_speeds[_speedIndex]}×',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colors.accent,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 4),
              GestureDetector(
                onTap: () {
                  setState(() =>
                      _speedIndex = (_speedIndex + 1) % _speeds.length);
                },
                child: Icon(
                  Icons.speed_rounded,
                  color: colors.accent,
                  size: 20,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  String _fmt(Duration d) {
    final m = d.inMinutes;
    final s = d.inSeconds % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }
}
