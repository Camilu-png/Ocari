import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ocari/core/theme/app_theme.dart';
import 'package:ocari/features/songs/domain/models/song_note.dart';

const double ocarinaSvgW = 286.0;
const double ocarinaSvgH = 173.0;

class OcarinaCanvas extends ConsumerStatefulWidget {
  final SongNote? note;

  const OcarinaCanvas({super.key, required this.note});

  @override
  ConsumerState<OcarinaCanvas> createState() => _OcarinaCanvasState();
}

class _OcarinaCanvasState extends ConsumerState<OcarinaCanvas>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  SongNote? _previousNote;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _previousNote = widget.note;
    _controller.value = 1.0;
  }

  @override
  void didUpdateWidget(OcarinaCanvas old) {
    super.didUpdateWidget(old);
    if (old.note != widget.note) {
      final shouldAnimate = old.note != null && widget.note != null;
      if (shouldAnimate) {
        _previousNote = old.note;
        _controller.forward(from: 0);
      } else {
        _previousNote = widget.note;
        _controller.value = 1.0;
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final note = widget.note;

    final bodyColor = isDark ? colors.surface : colors.bgLight;
    final bodyHighlight =
        isDark ? colors.accent.withAlpha(40) : Colors.white.withAlpha(60);
    final borderColor = isDark
        ? colors.accent.withAlpha(80)
        : colors.textSecondary.withAlpha(120);
    final pressedColor = colors.primary;
    final holeBorderColor = isDark
        ? colors.accent.withAlpha(70)
        : colors.textSecondary.withAlpha(100);
    final shadowColor =
        isDark ? Colors.black.withAlpha(60) : Colors.black.withAlpha(30);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AspectRatio(
          aspectRatio: ocarinaSvgW / ocarinaSvgH,
          child: AnimatedBuilder(
            animation: _animation,
            builder: (context, _) {
              return CustomPaint(
                painter: _OcarinaPainter(
                  currentNote: note,
                  previousNote: _previousNote,
                  progress: _animation.value,
                  bodyColor: bodyColor,
                  bodyHighlight: bodyHighlight,
                  borderColor: borderColor,
                  pressedColor: pressedColor,
                  holeBorderColor: holeBorderColor,
                  shadowColor: shadowColor,
                ),
                child: const SizedBox.expand(),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Text(
          note?.note ?? '--',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: colors.accent,
            fontFamily: '.SF Pro Display',
          ),
        ),
      ],
    );
  }
}

class _OcarinaPainter extends CustomPainter {
  final SongNote? currentNote;
  final SongNote? previousNote;
  final double progress;
  final Color bodyColor;
  final Color bodyHighlight;
  final Color borderColor;
  final Color pressedColor;
  final Color holeBorderColor;
  final Color shadowColor;

  static const double _svgW = ocarinaSvgW;
  static const double _svgH = ocarinaSvgH;

  const _OcarinaPainter({
    required this.currentNote,
    required this.previousNote,
    required this.progress,
    required this.bodyColor,
    required this.bodyHighlight,
    required this.borderColor,
    required this.pressedColor,
    required this.holeBorderColor,
    required this.shadowColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / _svgW;
    final scaleY = size.height / _svgH;

    final bodyPath = _buildBodyPath(scaleX, scaleY);

    canvas.drawShadow(bodyPath, shadowColor, size.height * 0.04, false);

    canvas.drawPath(
        bodyPath,
        Paint()
          ..color = bodyColor
          ..style = PaintingStyle.fill);

    canvas.drawPath(
      bodyPath,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [bodyHighlight, bodyHighlight.withAlpha(0)],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height)),
    );

    canvas.drawPath(
        bodyPath,
        Paint()
          ..color = borderColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5);

    _drawHoles(canvas, scaleX, scaleY, pressedColor, holeBorderColor);
  }

  // Path extraído directamente del SVG — coordenadas escaladas al canvas
  Path _buildBodyPath(double sx, double sy) {
    return Path()
      ..moveTo(113.461 * sx, 170.69 * sy)
      ..lineTo(110.603 * sx, 168.262 * sy)
      ..cubicTo(109.173 * sx, 167.048 * sy, 108.697 * sx, 162.595 * sy,
          108.697 * sx, 162.595 * sy)
      ..lineTo(107.744 * sx, 156.524 * sy)
      ..lineTo(106.315 * sx, 146.81 * sy)
      ..lineTo(104.409 * sx, 136.69 * sy)
      ..lineTo(102.503 * sx, 129.405 * sy)
      ..lineTo(100.598 * sx, 125.762 * sy)
      ..lineTo(97.7391 * sx, 120.095 * sy)
      ..lineTo(95.3569 * sx, 116.452 * sy)
      ..lineTo(93.4512 * sx, 113.619 * sy)
      ..lineTo(90.1162 * sx, 110.786 * sy)
      ..lineTo(85.8283 * sx, 108.762 * sy)
      ..lineTo(81.064 * sx, 106.738 * sy)
      ..lineTo(75.3468 * sx, 105.119 * sy)
      ..lineTo(65.3417 * sx, 102.69 * sy)
      ..lineTo(56.766 * sx, 100.667 * sy)
      ..lineTo(49.1431 * sx, 99.0476 * sy)
      ..lineTo(40.0909 * sx, 97.0238 * sy)
      ..lineTo(33.8973 * sx, 95.8095 * sy)
      ..lineTo(26.7509 * sx, 94.1905 * sy)
      ..lineTo(20.5572 * sx, 92.1667 * sy)
      ..lineTo(14.8401 * sx, 90.1429 * sy)
      ..lineTo(11.0286 * sx, 87.7143 * sy)
      ..lineTo(6.74075 * sx, 84.8809 * sy)
      ..lineTo(3.88217 * sx, 82.0476 * sy)
      ..lineTo(1.97643 * sx, 79.2143 * sy)
      ..lineTo(1.49999 * sx, 76.7857 * sy)
      ..lineTo(1.49999 * sx, 74.7619 * sy)
      ..lineTo(1.97643 * sx, 72.3333 * sy)
      ..lineTo(2.92928 * sx, 69.9048 * sy)
      ..lineTo(4.35858 * sx, 67.0714 * sy)
      ..lineTo(6.74075 * sx, 63.8333 * sy)
      ..lineTo(9.59933 * sx, 60.5952 * sy)
      ..lineTo(13.4108 * sx, 57.3571 * sy)
      ..lineTo(18.1751 * sx, 53.7143 * sy)
      ..lineTo(21.5101 * sx, 51.2857 * sy)
      ..lineTo(25.3216 * sx, 48.8571 * sy)
      ..lineTo(28.1801 * sx, 46.8333 * sy)
      ..lineTo(32.468 * sx, 44.4048 * sy)
      ..lineTo(41.5202 * sx, 39.5476 * sy)
      ..lineTo(51.5253 * sx, 34.6905 * sy)
      ..lineTo(61.5303 * sx, 30.2381 * sy)
      ..lineTo(72.9646 * sx, 25.381 * sy)
      ..lineTo(84.8754 * sx, 21.3333 * sy)
      ..lineTo(108.221 * sx, 14.8571 * sy)
      ..lineTo(128.231 * sx, 10.8095 * sy)
      ..lineTo(158.246 * sx, 5.95238 * sy)
      ..lineTo(187.785 * sx, 3.11905 * sy)
      ..lineTo(214.941 * sx, 1.5 * sy)
      ..lineTo(236.38 * sx, 1.5 * sy)
      ..lineTo(252.103 * sx, 1.5 * sy)
      ..lineTo(259.249 * sx, 2.71429 * sy)
      ..lineTo(267.825 * sx, 3.92857 * sy)
      ..lineTo(276.877 * sx, 5.95238 * sy)
      ..lineTo(280.212 * sx, 7.57143 * sy)
      ..lineTo(282.594 * sx, 9.19047 * sy)
      ..lineTo(284.5 * sx, 11.619 * sy)
      ..lineTo(284.5 * sx, 14.0476 * sy)
      ..lineTo(282.594 * sx, 17.6905 * sy)
      ..lineTo(278.306 * sx, 22.1429 * sy)
      ..lineTo(271.16 * sx, 27.8095 * sy)
      ..lineTo(256.867 * sx, 37.5238 * sy)
      ..lineTo(241.145 * sx, 47.2381 * sy)
      ..lineTo(220.182 * sx, 60.5952 * sy)
      ..lineTo(200.172 * sx, 72.3333 * sy)
      ..lineTo(179.209 * sx, 84.8809 * sy)
      ..lineTo(164.916 * sx, 92.9762 * sy)
      ..lineTo(155.864 * sx, 100.667 * sy)
      ..lineTo(151.099 * sx, 107.952 * sy)
      ..lineTo(146.811 * sx, 119.69 * sy)
      ..lineTo(143 * sx, 135.881 * sy)
      ..lineTo(140.141 * sx, 155.714 * sy)
      ..lineTo(137.759 * sx, 166.238 * sy)
      ..cubicTo(137.759 * sx, 166.238 * sy, 135.854 * sx, 170.286 * sy,
          133.471 * sx, 170.69 * sy)
      ..cubicTo(131.089 * sx, 171.095 * sy, 127.981 * sx, 171.422 * sy,
          124.896 * sx, 171.5 * sy)
      ..lineTo(113.461 * sx, 170.69 * sy)
      ..close();
  }

  void _drawHoles(
    Canvas canvas,
    double sx,
    double sy,
    Color pressedColor,
    Color borderColor,
  ) {
    // Radio exacto del SVG (r=10 y r=7.5) escalado al canvas
    final rBig = 10.0 * sx;
    final rSmall = 7.5 * sx;

    // Coordenadas cx/cy exactas de cada círculo en el SVG
    // top: mano izquierda (índice→meñique de derecha a izquierda en pantalla)
    final topPositions = <Offset>[
      Offset(41.5001 * sx, 72.4998 * sy), // top-0
      Offset(72.5001 * sx, 69.4998 * sy), // top-1
      Offset(101.5 * sx, 53.4998 * sy), // top-2
      Offset(119.5 * sx, 29.4998 * sy), // top-3
    ];

    // bot: mano derecha (índice→meñique)
    final botPositions = <Offset>[
      Offset(153.5 * sx, 84.4998 * sy), // bot-0
      Offset(185.5 * sx, 57.4998 * sy), // bot-1
      Offset(216.5 * sx, 34.4998 * sy), // bot-2
      Offset(251.5 * sx, 20.4998 * sy), // bot-3
    ];

    // sub: pulgares
    final subPositions = <Offset>[
      Offset(83.5 * sx, 140.5 * sy), // sub-0 (pulgar izquierdo)
      Offset(168.5 * sx, 132.5 * sy), // sub-1 (pulgar derecho)
    ];

    // middle: hoyo central (ambas palmas)
    final middlePositions = <Offset>[
      Offset(86.0001 * sx, 89.9999 * sy), // middle-0
      Offset(168.0 * sx, 38.9998 * sy), // middle-1
    ];

    for (int i = 0; i < 4; i++) {
      _drawSingleHole(canvas, topPositions[i], rBig, _interpolateHole('top', i),
          pressedColor, borderColor);
    }
    for (int i = 0; i < 4; i++) {
      _drawSingleHole(canvas, botPositions[i], rBig, _interpolateHole('bot', i),
          pressedColor, borderColor);
    }
    for (int i = 0; i < 2; i++) {
      _drawSingleHole(canvas, subPositions[i], rBig, _interpolateHole('sub', i),
          pressedColor, borderColor);
    }
    for (int i = 0; i < 2; i++) {
      _drawSingleHole(canvas, middlePositions[i], rSmall,
          _interpolateHole('middle', i), pressedColor, borderColor);
    }
  }

  double _interpolateHole(String row, int index) {
    final List<int>? prev;
    final List<int>? curr;

    switch (row) {
      case 'top':
        prev = previousNote?.top;
        curr = currentNote?.top;
      case 'bot':
        prev = previousNote?.bot;
        curr = currentNote?.bot;
      case 'sub':
        prev = previousNote?.sub;
        curr = currentNote?.sub;
      case 'middle':
        prev = previousNote?.middle;
        curr = currentNote?.middle;
      default:
        return 0;
    }

    final prevVal = prev != null && index < prev.length ? prev[index] : 0;
    final currVal = curr != null && index < curr.length ? curr[index] : 0;

    if (prevVal == currVal) return currVal.toDouble();
    if (prevVal == 1) return 1.0 - progress;
    return progress;
  }

  void _drawSingleHole(
    Canvas canvas,
    Offset center,
    double radius,
    double fillAmount,
    Color pressedColor,
    Color borderColor,
  ) {
    // Fondo del hoyo (siempre visible como hueco)
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = borderColor.withAlpha(30)
        ..style = PaintingStyle.fill,
    );

    // Relleno según si está presionado
    if (fillAmount > 0) {
      canvas.drawCircle(
        center,
        radius,
        Paint()
          ..color = pressedColor.withAlpha((fillAmount * 255).round())
          ..style = PaintingStyle.fill,
      );
    }

    // Borde siempre visible
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = borderColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
  }

  @override
  bool shouldRepaint(_OcarinaPainter oldDelegate) {
    return oldDelegate.currentNote != currentNote ||
        oldDelegate.previousNote != previousNote ||
        oldDelegate.progress != progress ||
        oldDelegate.bodyColor != bodyColor ||
        oldDelegate.bodyHighlight != bodyHighlight ||
        oldDelegate.borderColor != borderColor ||
        oldDelegate.pressedColor != pressedColor ||
        oldDelegate.holeBorderColor != holeBorderColor ||
        oldDelegate.shadowColor != shadowColor;
  }
}
