import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ocari/core/theme/app_theme.dart';
import 'package:ocari/core/theme/note_colors.dart';
import 'package:ocari/core/widgets/notes_track.dart';
import 'package:ocari/core/widgets/ocarina_canvas.dart';
import 'package:ocari/features/onboarding/presentation/providers/onboarding_provider.dart';
import 'package:ocari/features/onboarding/presentation/services/note_player.dart';
import 'package:ocari/features/songs/domain/models/song_note.dart';

const List<SongNote> _demoNotes = [
  SongNote(
    note: 'C5',
    top: [1, 1, 1, 1],
    bot: [1, 1, 1, 1],
    sub: [1, 1],
    middle: [0, 0],
    timestampMs: 0,
    durationMs: 1200,
    noteValue: 'C5',
  ),
  SongNote(
    note: 'D5',
    top: [1, 1, 1, 1],
    bot: [1, 1, 1, 0],
    sub: [1, 1],
    middle: [0, 0],
    timestampMs: 1200,
    durationMs: 1200,
    noteValue: 'D5',
  ),
  SongNote(
    note: 'E5',
    top: [1, 1, 1, 1],
    bot: [1, 1, 0, 0],
    sub: [1, 1],
    middle: [0, 0],
    timestampMs: 2400,
    durationMs: 1200,
    noteValue: 'E5',
  ),
  SongNote(
    note: 'F5',
    top: [1, 1, 1, 1],
    bot: [1, 0, 0, 0],
    sub: [1, 1],
    middle: [0, 0],
    timestampMs: 3600,
    durationMs: 1200,
    noteValue: 'F5',
  ),
  SongNote(
    note: 'G5',
    top: [1, 1, 1, 1],
    bot: [0, 0, 0, 0],
    sub: [1, 1],
    middle: [0, 0],
    timestampMs: 4800,
    durationMs: 1200,
    noteValue: 'G5',
  ),
  SongNote(
    note: 'A5',
    top: [1, 1, 0, 1],
    bot: [0, 0, 0, 0],
    sub: [1, 1],
    middle: [0, 0],
    timestampMs: 6000,
    durationMs: 1200,
    noteValue: 'A5',
  ),
];

final _demoTotalMs = _demoNotes.last.timestampMs + _demoNotes.last.durationMs;

final _animDuration = Duration(milliseconds: _demoTotalMs * 2);

class OnboardingDialog extends ConsumerStatefulWidget {
  const OnboardingDialog({super.key});

  @override
  ConsumerState<OnboardingDialog> createState() => _OnboardingDialogState();
}

class _OnboardingDialogState extends ConsumerState<OnboardingDialog> {
  final NotePlayer _notePlayer = NotePlayer();
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _notePlayer.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _onSkip() {
    ref.read(onboardingProvider.notifier).complete();
    Navigator.of(context).pop();
  }

  void _onNext() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  void _onBack() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  void _onFinish() {
    ref.read(onboardingProvider.notifier).complete();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? colors.bgDark : colors.bgLight,
      body: SafeArea(
        child: Stack(
          children: [
            PageView(
              controller: _pageController,
              onPageChanged: (page) => setState(() => _currentPage = page),
              children: [
                _WelcomePage(onNext: _onNext),
                _NotesTrackDemoPage(
                  notes: _demoNotes,
                  totalMs: _demoTotalMs,
                  notePlayer: _notePlayer,
                ),
                _ColorPalettePage(),
                _OcarinaDemoPage(
                  notes: _demoNotes,
                  totalMs: _demoTotalMs,
                  notePlayer: _notePlayer,
                ),
                _ReadyPage(onFinish: _onFinish),
              ],
            ),
            if (_currentPage < 4)
              Positioned(
                top: 8,
                right: 8,
                child: TextButton(
                  onPressed: _onSkip,
                  child: Text(
                    'Saltar',
                    style: TextStyle(color: colors.textSecondary),
                  ),
                ),
              ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: _BottomBar(
                currentPage: _currentPage,
                totalPages: 5,
                canGoBack: _currentPage > 0,
                onBack: _onBack,
                onFinish: _onFinish,
                onNext: _onNext,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final bool canGoBack;
  final VoidCallback onBack;
  final VoidCallback onFinish;
  final VoidCallback onNext;

  const _BottomBar({
    required this.currentPage,
    required this.totalPages,
    required this.canGoBack,
    required this.onBack,
    required this.onFinish,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isLastPage = currentPage == totalPages - 1;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      color: Theme.of(context).brightness == Brightness.dark
          ? colors.bgDark.withValues(alpha: 0.95)
          : colors.bgLight.withValues(alpha: 0.95),
      child: Row(
        children: [
          if (canGoBack)
            TextButton.icon(
              onPressed: onBack,
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 16),
              label: const Text('Atrás'),
            )
          else
            const SizedBox(width: 80),
          const Spacer(),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(totalPages, (i) {
              return Container(
                width: i == currentPage ? 20 : 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 3),
                decoration: BoxDecoration(
                  color: i == currentPage
                      ? colors.accent
                      : colors.textSecondary.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
          const Spacer(),
          if (isLastPage)
            FilledButton(
              onPressed: onFinish,
              child: const Text('Ir al catálogo'),
            )
          else
            FilledButton(
              onPressed: onNext,
              child: const Text('Siguiente'),
            ),
        ],
      ),
    );
  }
}

class _WelcomePage extends StatelessWidget {
  final VoidCallback onNext;

  const _WelcomePage({required this.onNext});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(flex: 2),
          Icon(Icons.music_note_rounded, size: 80, color: colors.accent),
          const SizedBox(height: 24),
          Text(
            'Aprende a tocar\nla ocarina con Ocari',
            textAlign: TextAlign.center,
            style: context.textTheme.headlineMedium?.copyWith(
              color: colors.onBgLight,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Te guiaremos a través de los conceptos básicos para que puedas '
            'empezar a tocar tus canciones favoritas.',
            textAlign: TextAlign.center,
            style: context.textTheme.bodyLarge?.copyWith(
              color: colors.textSecondary,
              height: 1.4,
            ),
          ),
          const Spacer(flex: 3),
        ],
      ),
    );
  }
}

class _NotesTrackDemoPage extends StatefulWidget {
  final List<SongNote> notes;
  final int totalMs;
  final NotePlayer notePlayer;

  const _NotesTrackDemoPage({
    required this.notes,
    required this.totalMs,
    required this.notePlayer,
  });

  @override
  State<_NotesTrackDemoPage> createState() => _NotesTrackDemoPageState();
}

class _NotesTrackDemoPageState extends State<_NotesTrackDemoPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _positionMs;
  Duration _position = Duration.zero;
  int _lastPlayedIndex = -1;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: _animDuration,
    );
    _positionMs = Tween<double>(
      begin: -2000,
      end: widget.totalMs.toDouble() + 2000,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    ));

    _controller.addListener(_onUpdate);
    _controller.forward();
  }

  void _onUpdate() {
    final ms = _positionMs.value.round();
    int activeIndex = -1;
    for (int i = 0; i < widget.notes.length; i++) {
      if (ms >= widget.notes[i].timestampMs &&
          ms < widget.notes[i].timestampMs + widget.notes[i].durationMs) {
        activeIndex = i;
        break;
      }
    }
    if (activeIndex != -1 && activeIndex != _lastPlayedIndex) {
      _lastPlayedIndex = activeIndex;
      widget.notePlayer.play(
        widget.notes[activeIndex].note,
        duration: Duration(milliseconds: widget.notes[activeIndex].durationMs),
      );
    } else if (activeIndex == -1 && _lastPlayedIndex != -1) {
      _lastPlayedIndex = -1;
      widget.notePlayer.stop();
    }
    if (mounted) {
      setState(() {
        _position = Duration(milliseconds: ms);
      });
    }
  }

  @override
  void dispose() {
    widget.notePlayer.stop();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 48),
          Icon(Icons.swap_vert_rounded, size: 36, color: colors.accent),
          const SizedBox(height: 16),
          Text(
            'El carril de notas',
            style: context.textTheme.headlineSmall?.copyWith(
              color: colors.onBgLight,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Las notas caen por el carril. Toca cuando pasen por la línea.',
            textAlign: TextAlign.center,
            style: context.textTheme.bodyMedium?.copyWith(
              color: colors.textSecondary,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                color: Theme.of(context).brightness == Brightness.dark
                    ? const Color(0xFF131326)
                    : colors.surface,
                child: NotesTrack(
                  notes: widget.notes,
                  position: _position,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _ColorPalettePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    final paletteEntries = NoteColors.palette.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Icon(Icons.palette_rounded, size: 36, color: colors.accent),
          const SizedBox(height: 16),
          Text(
            'Los colores de las notas',
            style: context.textTheme.headlineSmall?.copyWith(
              color: colors.onBgLight,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Cada nota musical tiene su propio color. Así podrás '
            'identificarlas rápidamente mientras tocas.',
            textAlign: TextAlign.center,
            style: context.textTheme.bodyMedium?.copyWith(
              color: colors.textSecondary,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: paletteEntries.map((entry) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: entry.value,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color:
                                  colors.textSecondary.withValues(alpha: 0.2),
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          entry.key,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: colors.textSecondary,
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

class _OcarinaDemoPage extends StatefulWidget {
  final List<SongNote> notes;
  final int totalMs;
  final NotePlayer notePlayer;

  const _OcarinaDemoPage({
    required this.notes,
    required this.totalMs,
    required this.notePlayer,
  });

  @override
  State<_OcarinaDemoPage> createState() => _OcarinaDemoPageState();
}

class _OcarinaDemoPageState extends State<_OcarinaDemoPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _positionMs;
  SongNote? _activeNote;
  int _lastPlayedIndex = -1;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: _animDuration,
    );
    _positionMs = Tween<double>(
      begin: -2000,
      end: widget.totalMs.toDouble() + 2000,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    ));

    _controller.addListener(_onUpdate);
    _controller.forward();
  }

  void _onUpdate() {
    final ms = _positionMs.value.round();
    SongNote? found;
    int foundIndex = -1;
    for (int i = 0; i < widget.notes.length; i++) {
      if (ms >= widget.notes[i].timestampMs &&
          ms < widget.notes[i].timestampMs + widget.notes[i].durationMs) {
        found = widget.notes[i];
        foundIndex = i;
        break;
      }
    }
    if (foundIndex != -1 && foundIndex != _lastPlayedIndex) {
      _lastPlayedIndex = foundIndex;
      widget.notePlayer.play(
        found!.note,
        duration: Duration(milliseconds: found.durationMs),
      );
    } else if (foundIndex == -1 && _lastPlayedIndex != -1) {
      _lastPlayedIndex = -1;
      widget.notePlayer.stop();
    }
    if (found != _activeNote && mounted) {
      setState(() => _activeNote = found);
    }
  }

  @override
  void dispose() {
    widget.notePlayer.stop();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Icon(Icons.touch_app_rounded, size: 36, color: colors.accent),
          const SizedBox(height: 16),
          Text(
            'La ocarina',
            style: context.textTheme.headlineSmall?.copyWith(
              color: colors.onBgLight,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Los hoyos se iluminan del color de la nota activa. '
            'Solo tapa los hoyos que se encienden.',
            textAlign: TextAlign.center,
            style: context.textTheme.bodyMedium?.copyWith(
              color: colors.textSecondary,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: 260,
            child: OcarinaCanvas(note: _activeNote),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

class _ReadyPage extends StatelessWidget {
  final VoidCallback onFinish;

  const _ReadyPage({required this.onFinish});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(flex: 2),
          Icon(
            Icons.celebration_rounded,
            size: 80,
            color: colors.accent,
          ),
          const SizedBox(height: 24),
          Text(
            '¡Listo para tocar!',
            textAlign: TextAlign.center,
            style: context.textTheme.headlineMedium?.copyWith(
              color: colors.onBgLight,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Ahora puedes explorar el catálogo de canciones '
            'y empezar a practicar.',
            textAlign: TextAlign.center,
            style: context.textTheme.bodyLarge?.copyWith(
              color: colors.textSecondary,
              height: 1.4,
            ),
          ),
          const Spacer(flex: 3),
        ],
      ),
    );
  }
}
