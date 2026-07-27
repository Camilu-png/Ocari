import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ocari/core/services/preferences_service.dart';
import 'package:ocari/core/theme/app_theme.dart';
import 'package:ocari/core/theme/note_colors.dart';
import 'package:ocari/core/widgets/ocarina_canvas.dart';
import 'package:ocari/features/onboarding/presentation/services/note_player.dart';
import 'package:ocari/features/player/domain/models/legend_note.dart';
import 'package:ocari/features/songs/domain/models/song_note.dart';

class ColorLegendSheet extends ConsumerStatefulWidget {
  const ColorLegendSheet({super.key});

  @override
  ConsumerState<ColorLegendSheet> createState() => _ColorLegendSheetState();
}

class _ColorLegendSheetState extends ConsumerState<ColorLegendSheet> {
  List<LegendNote> _notes = [];
  LegendNote? _selectedNote;
  bool _loading = true;
  bool _useFlats = false;
  final NotePlayer _notePlayer = NotePlayer();

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  @override
  void dispose() {
    _notePlayer.dispose();
    super.dispose();
  }

  Future<void> _loadNotes() async {
    try {
      final prefs = await ref.read(preferencesServiceProvider.future);
      final useFlats = await prefs.useFlats();

      final jsonStr = await rootBundle.loadString('assets/data/fingerings.json');
      final data = json.decode(jsonStr) as Map<String, dynamic>;
      final notesMap = data['notes'] as Map<String, dynamic>;

      final notes = <LegendNote>[];
      for (final entry in notesMap.entries) {
        final name = entry.key;
        final noteData = entry.value as Map<String, dynamic>;
        final color = NoteColors.forNote(name);

        notes.add(LegendNote(
          name: name,
          color: color,
          fingering: SongNote(
            note: name,
            top: List<int>.from(noteData['top']),
            bot: List<int>.from(noteData['bot']),
            sub: List<int>.from(noteData['sub']),
            middle: List<int>.from(noteData['middle']),
            timestampMs: 0,
            durationMs: 1000,
            noteValue: name,
          ),
        ));
      }

      notes.sort((a, b) => _noteSortKey(a.name).compareTo(_noteSortKey(b.name)));

      if (mounted) {
        setState(() {
          _notes = notes;
          _useFlats = useFlats;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  void _onNoteTap(LegendNote note) {
    setState(() => _selectedNote = note);
    _notePlayer.play(note.name);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: isDark ? colors.bgDark : colors.bgLight,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                width: 36,
                height: 4,
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                decoration: BoxDecoration(
                  color: colors.textSecondary.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Text(
                'Color Legend',
                style: context.textTheme.headlineSmall?.copyWith(
                  color: colors.onBgLight,
                ),
              ),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  'Each note has its own color. Tap a note to see its fingering on the ocarina.',
                  textAlign: TextAlign.center,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: colors.textSecondary,
                    height: 1.3,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _buildEnharmonicToggle(colors),
              const SizedBox(height: 12),
              Expanded(
                child: _loading
                    ? const Center(child: CircularProgressIndicator())
                    : OrientationBuilder(
                        builder: (context, orientation) {
                          if (orientation == Orientation.landscape) {
                            return _buildLandscapeContent(
                                colors, scrollController);
                          }
                          return _buildPortraitContent(
                              colors, scrollController);
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEnharmonicToggle(AppColors colors) {
    return GestureDetector(
      onTap: () async {
        setState(() => _useFlats = !_useFlats);
        try {
          final prefs = await ref.read(preferencesServiceProvider.future);
          await prefs.setUseFlats(_useFlats);
        } catch (_) {}
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: _useFlats
              ? colors.accent.withValues(alpha: 0.15)
              : colors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _useFlats
                ? colors.accent.withValues(alpha: 0.4)
                : colors.textSecondary.withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.tune,
              size: 16,
              color: _useFlats ? colors.accent : colors.textSecondary,
            ),
            const SizedBox(width: 6),
            Text(
              _useFlats ? 'Flats (Bb)' : 'Sharps (#)',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: _useFlats ? colors.accent : colors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwatchGrid(AppColors colors) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      alignment: WrapAlignment.center,
      children: _notes.map((note) {
        return _Swatch(
          note: note,
          isSelected: _selectedNote?.name == note.name,
          useFlats: _useFlats,
          borderColor: colors.textSecondary.withValues(alpha: 0.2),
          textColor: colors.textSecondary,
          onTap: () => _onNoteTap(note),
        );
      }).toList(),
    );
  }

  Widget _buildOcarinaPreview(AppColors colors) {
    if (_selectedNote == null) {
      return Center(
        child: Text(
          'Select a note',
          style: context.textTheme.bodyMedium?.copyWith(
            color: colors.textSecondary,
          ),
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '${_selectedNote!.name}  ·  ${_solfege(_selectedNote!.name, useFlats: _useFlats)}',
          style: context.textTheme.titleMedium?.copyWith(
            color: _selectedNote!.color,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: 200,
          child: OcarinaCanvas(note: _selectedNote!.fingering),
        ),
      ],
    );
  }

  Widget _buildPortraitContent(
      AppColors colors, ScrollController scrollController) {
    return SingleChildScrollView(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          _buildSwatchGrid(colors),
          const SizedBox(height: 24),
          _buildOcarinaPreview(colors),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildLandscapeContent(
      AppColors colors, ScrollController scrollController) {
    return Row(
      children: [
        Expanded(
          child: SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: _buildSwatchGrid(colors),
          ),
        ),
        const SizedBox(width: 16),
        Container(
          width: 240,
          padding: const EdgeInsets.only(right: 24, top: 16, bottom: 16),
          child: _buildOcarinaPreview(colors),
        ),
      ],
    );
  }

  static String _solfege(String note, {required bool useFlats}) {
    const solfegeMap = {
      'C': 'Do',
      'D': 'Re',
      'E': 'Mi',
      'F': 'Fa',
      'G': 'Sol',
      'A': 'La',
      'B': 'Si',
    };

    final m = RegExp(r'^([A-G])([sf]?)(\d+)$').firstMatch(note);
    if (m == null) return note;

    final letter = m.group(1)!;
    final accidental = m.group(2)!;
    final octave = m.group(3)!;
    final base = solfegeMap[letter] ?? letter;

    if (accidental.isEmpty) return '$base · oct $octave';

    final symbol = (accidental == 'f') == useFlats ? 'b' : '#';
    return '$base$symbol · oct $octave';
  }

  static int _noteSortKey(String note) {
    final m = RegExp(r'^([A-G])([sf]?)(\d+)$').firstMatch(note);
    if (m == null) return 0;
    const chromatic = {'C': 0, 'D': 2, 'E': 4, 'F': 5, 'G': 7, 'A': 9, 'B': 11};
    var pitch = chromatic[m.group(1)!]!;
    if (m.group(2) == 's') pitch++;
    if (m.group(2) == 'f') pitch--;
    return int.parse(m.group(3)!) * 12 + pitch;
  }
}

class _Swatch extends StatefulWidget {
  final LegendNote note;
  final bool isSelected;
  final bool useFlats;
  final Color borderColor;
  final Color textColor;
  final VoidCallback onTap;

  const _Swatch({
    required this.note,
    required this.isSelected,
    required this.useFlats,
    required this.borderColor,
    required this.textColor,
    required this.onTap,
  });

  @override
  State<_Swatch> createState() => _SwatchState();
}

class _SwatchState extends State<_Swatch>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scale = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final solfegeName = _ColorLegendSheetState._solfege(
      widget.note.name,
      useFlats: widget.useFlats,
    );

    return GestureDetector(
      onTapDown: (_) {
        _animController.forward();
        widget.onTap();
      },
      onTapUp: (_) => _animController.reverse(),
      onTapCancel: () => _animController.reverse(),
      child: AnimatedBuilder(
        animation: _scale,
        builder: (context, child) => Transform.scale(
          scale: _scale.value,
          child: child,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: widget.note.color,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: widget.isSelected
                      ? widget.note.color
                      : widget.borderColor,
                  width: widget.isSelected ? 2.0 : 1.0,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              widget.note.name,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: widget.textColor,
              ),
            ),
            Text(
              solfegeName,
              style: TextStyle(
                fontSize: 8,
                color: widget.textColor.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
