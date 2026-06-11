import 'package:flutter/material.dart';

import 'package:ocari/core/theme/app_theme.dart';
import 'package:ocari/core/theme/note_colors.dart';
import 'package:ocari/features/songs/domain/models/song_note.dart';

const double pixelsPerMs = 0.08;
const double separatorWidth = 8.0;
const double horizontalPadding = 8.0;
const double labelHeight = 20.0;

typedef _FingerGetter = int Function(SongNote);

final List<_FingerGetter?> _columnGetters = [
  (n) => n.top[0],
  (n) => n.top[1],
  (n) => n.top[2],
  (n) => n.top[3],
  null,
  (n) => n.middle[0],
  (n) => n.middle[1],
  null,
  (n) => n.bot[0],
  (n) => n.bot[1],
  (n) => n.bot[2],
  (n) => n.bot[3],
  null,
  (n) => n.sub[0],
  (n) => n.sub[1],
];

const List<String> _columnLabels = [
  'T0', 'T1', 'T2', 'T3', '',
  'M0', 'M1', '',
  'B0', 'B1', 'B2', 'B3', '',
  'S0', 'S1',
];

const int columnCount = 12;
const int separatorCount = 3;

class NotesTrack extends StatelessWidget {
  final List<SongNote> notes;
  final Duration position;

  const NotesTrack({
    super.key,
    required this.notes,
    required this.position,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final trackHeight = constraints.maxHeight;
        final double posMs = position.inMilliseconds.toDouble();
        final lineY = trackHeight * 0.75;

        final double usableWidth = width - 2 * horizontalPadding;
        final double columnsTotalWidth = usableWidth - separatorCount * separatorWidth;
        final double colWidth = columnsTotalWidth / columnCount;

        final List<double> colStarts = [];
        double x = horizontalPadding;
        for (int i = 0; i < _columnGetters.length; i++) {
          if (_columnGetters[i] == null) {
            x += separatorWidth;
            colStarts.add(-1);
          } else {
            colStarts.add(x);
            x += colWidth;
          }
        }

        final labelColor = colors.textSecondary.withAlpha(120);
        final lineColor = colors.textSecondary.withAlpha(60);

        return Column(
          children: [
            Expanded(
              child: ClipRect(
                child: Stack(
                  children: [
                    ..._buildTimeGrid(
                      trackHeight, lineY, posMs, width, lineColor,
                    ),
                    ..._buildColumnBackgrounds(
                      trackHeight, colStarts,
                    ),
                    ..._buildBlocks(
                      trackHeight, lineY, posMs, colWidth, colStarts,
                    ),
                    _buildHitLine(width, lineY, labelColor, lineColor),
                  ],
                ),
              ),
            ),
            _buildLabels(colWidth, colStarts, labelColor),
          ],
        );
      },
    );
  }

  List<Widget> _buildColumnBackgrounds(
    double trackHeight,
    List<double> colStarts,
  ) {
    final widgets = <Widget>[];
    for (int i = 0; i < _columnGetters.length; i++) {
      if (_columnGetters[i] == null) {
        final sepX = colStarts[i];
        if (sepX >= 0) {
          widgets.add(
            Positioned(
              left: sepX,
              top: 0,
              width: separatorWidth,
              height: trackHeight,
              child: IgnorePointer(
                child: Container(
                  color: Colors.white.withAlpha(8),
                ),
              ),
            ),
          );
        }
      }
    }
    return widgets;
  }

  List<Widget> _buildTimeGrid(
    double trackHeight,
    double lineY,
    double posMs,
    double trackWidth,
    Color baseColor,
  ) {
    const double minorMs = 1000.0;
    const int majorStep = 4;

    final double viewTop = posMs - 12000;
    final double viewBottom = posMs + 12000;
    final double startMs = (viewTop / minorMs).ceil() * minorMs;

    final widgets = <Widget>[];
    final int count = ((viewBottom - startMs) / minorMs).ceil() + 1;
    for (int i = 0; i < count; i++) {
      final double t = startMs + i * minorMs;
      final double y = (posMs - t) * pixelsPerMs + lineY;
      if (y < 0 || y > trackHeight) continue;

      final bool isMajor = i % majorStep == 0;
      widgets.add(
        Positioned(
          left: 0,
          top: y,
          width: trackWidth,
          child: Container(
            height: 1,
            color: baseColor.withAlpha(isMajor ? 18 : 8),
          ),
        ),
      );
    }
    return widgets;
  }

  List<Widget> _buildBlocks(
    double trackHeight,
    double lineY,
    double posMs,
    double colWidth,
    List<double> colStarts,
  ) {
    if (notes.isEmpty) return const [];

    const double windowMs = 12000;
    final double viewTop = posMs - windowMs;
    final double viewBottom = posMs + windowMs;

    final int firstIdx = _findFirstVisible(viewTop);
    final int lastIdx = _findLastVisible(viewBottom);

        final widgets = <Widget>[];
    for (int i = firstIdx; i <= lastIdx && i < notes.length; i++) {
      final note = notes[i];
      final double blockEnd = (posMs - note.timestampMs - note.durationMs) * pixelsPerMs + lineY;
      final double rawHeight = note.durationMs * pixelsPerMs;
      final double blockH = rawHeight.clamp(8.0, double.infinity);
      final double blockTop = blockEnd;

      if (blockTop + blockH < 0 || blockTop > trackHeight) continue;

      final Color color = NoteColors.forNote(note.note);
      final hsl = HSLColor.fromColor(color);
      final topColor = hsl.withLightness((hsl.lightness + 0.15).clamp(0.0, 1.0)).toColor();
      final bottomColor = hsl.withLightness((hsl.lightness - 0.15).clamp(0.0, 1.0)).toColor();

      for (int ci = 0; ci < _columnGetters.length; ci++) {
        final getter = _columnGetters[ci];
        if (getter == null) continue;
        if (getter(note) == 0) continue;

        final cx = colStarts[ci];
        if (cx < 0) continue;

        final bool mergeLeft = ci > 0 &&
            _columnGetters[ci - 1] != null &&
            _columnGetters[ci - 1]!(note) == 1;
        final bool mergeRight = ci < _columnGetters.length - 1 &&
            _columnGetters[ci + 1] != null &&
            _columnGetters[ci + 1]!(note) == 1;

        widgets.add(
          Positioned(
            left: cx,
            top: blockTop,
            width: colWidth,
            height: blockH,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [topColor, color, bottomColor],
                  stops: const [0.0, 0.3, 1.0],
                ),
                borderRadius: BorderRadius.only(
                  topLeft: mergeLeft ? Radius.zero : const Radius.circular(3),
                  topRight: mergeRight ? Radius.zero : const Radius.circular(3),
                  bottomLeft: mergeLeft ? Radius.zero : const Radius.circular(3),
                  bottomRight: mergeRight ? Radius.zero : const Radius.circular(3),
                ),
                boxShadow: [
                  BoxShadow(
                    color: color.withAlpha(100),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                  BoxShadow(
                    color: color.withAlpha(40),
                    blurRadius: 12,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
          ),
        );
      }
    }

    return widgets;
  }

  int _findFirstVisible(double timestampMs) {
    int lo = 0;
    int hi = notes.length;
    while (lo < hi) {
      final mid = (lo + hi) ~/ 2;
      if (notes[mid].timestampMs + notes[mid].durationMs < timestampMs) {
        lo = mid + 1;
      } else {
        hi = mid;
      }
    }
    return lo;
  }

  int _findLastVisible(double timestampMs) {
    int lo = 0;
    int hi = notes.length;
    while (lo < hi) {
      final mid = (lo + hi) ~/ 2;
      if (notes[mid].timestampMs <= timestampMs) {
        lo = mid + 1;
      } else {
        hi = mid;
      }
    }
    return lo - 1;
  }

  Widget _buildHitLine(double width, double lineY, Color labelColor, Color lineColor) {
    return Positioned(
      left: 0,
      top: lineY,
      width: width,
      height: 20,
      child: Row(
        children: [
          const SizedBox(width: 8),
          Text(
            'TOCA AHORA',
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: labelColor,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              height: 2,
              color: lineColor,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget _buildLabels(double colWidth, List<double> colStarts, Color labelColor) {
    return SizedBox(
      height: labelHeight,
      child: Stack(
        children: [
          for (int i = 0; i < _columnGetters.length; i++)
            if (_columnGetters[i] != null)
              Positioned(
                left: colStarts[i],
                top: 4,
                width: colWidth,
                child: Text(
                  _columnLabels[i],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w500,
                    color: labelColor,
                  ),
                ),
              ),
        ],
      ),
    );
  }
}
