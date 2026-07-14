import 'package:flutter/material.dart';

import 'package:ocari/core/theme/app_theme.dart';

class TutorialStep {
  final GlobalKey? targetKey;
  final String text;
  final double? spotlightHeightFraction;
  final double? spotlightOffsetY;

  const TutorialStep({
    this.targetKey,
    required this.text,
    this.spotlightHeightFraction,
    this.spotlightOffsetY,
  });

  bool get isCentered => targetKey == null;
}

class TutorialOverlay {
  static OverlayEntry? _entry;
  static _TutorialOverlayState? _state;

  static void show(
    BuildContext context, {
    required List<TutorialStep> steps,
    required VoidCallback onCompleted,
    required VoidCallback onSkipped,
  }) {
    dismiss();

    final overlay = Overlay.of(context);
    _entry = OverlayEntry(
      builder: (_) => _TutorialOverlayWidget(
        steps: steps,
        onCompleted: onCompleted,
        onSkipped: onSkipped,
      ),
    );
    overlay.insert(_entry!);
  }

  static void nextStep() {
    _state?.nextStep();
  }

  static void dismiss() {
    _entry?.remove();
    _entry = null;
    _state = null;
  }
}

class _TutorialOverlayWidget extends StatefulWidget {
  final List<TutorialStep> steps;
  final VoidCallback onCompleted;
  final VoidCallback onSkipped;

  const _TutorialOverlayWidget({
    required this.steps,
    required this.onCompleted,
    required this.onSkipped,
  });

  @override
  State<_TutorialOverlayWidget> createState() => _TutorialOverlayState();
}

class _TutorialOverlayState extends State<_TutorialOverlayWidget>
    with SingleTickerProviderStateMixin {
  int _currentStep = 0;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  bool _isTransitioning = false;

  @override
  void initState() {
    super.initState();
    TutorialOverlay._state = this;
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );
    _fadeController.value = 1.0;
  }

  @override
  void dispose() {
    TutorialOverlay._state = null;
    _fadeController.dispose();
    super.dispose();
  }

  void nextStep() {
    if (_isTransitioning) return;
    if (_currentStep < widget.steps.length - 1) {
      _advanceStep(_currentStep + 1);
    } else {
      _complete();
    }
  }

  void _advanceStep(int newStep) {
    _isTransitioning = true;
    _fadeController.reverse().then((_) {
      if (!mounted) return;
      setState(() => _currentStep = newStep);
      _fadeController.forward().then((_) {
        _isTransitioning = false;
      });
    });
  }

  void _complete() {
    _fadeController.reverse().then((_) {
      TutorialOverlay.dismiss();
      widget.onCompleted();
    });
  }

  void _skip() {
    _fadeController.reverse().then((_) {
      TutorialOverlay.dismiss();
      widget.onSkipped();
    });
  }

  @override
  Widget build(BuildContext context) {
    final step = widget.steps[_currentStep];
    final colors = context.colors;
    final screenSize = MediaQuery.of(context).size;

    Rect? spotlightRect;
    if (!step.isCentered) {
      spotlightRect = _getSpotlightRect(step, screenSize);
    }

    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, _) {
        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                onTap: step.isCentered ? null : () {},
                behavior: HitTestBehavior.translucent,
                child: CustomPaint(
                  painter: _SpotlightPainter(
                    spotlightRect: spotlightRect,
                    opacity: _fadeAnimation.value * 0.6,
                  ),
                ),
              ),
            ),
            if (spotlightRect != null)
              Positioned(
                left: spotlightRect.left - 4,
                top: spotlightRect.top - 4,
                width: spotlightRect.width + 8,
                height: spotlightRect.height + 8,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: colors.accent.withValues(alpha: _fadeAnimation.value),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            FadeTransition(
              opacity: _fadeAnimation,
              child: _buildTooltip(
                context,
                step,
                spotlightRect,
                screenSize,
                colors,
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).padding.top + 8,
              right: 16,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: TextButton(
                  onPressed: _skip,
                  child: Text(
                    'Saltar tutorial',
                    style: TextStyle(
                      color: colors.onAccent,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: MediaQuery.of(context).padding.bottom + 16,
              left: 0,
              right: 0,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: _buildStepIndicator(colors),
              ),
            ),
          ],
        );
      },
    );
  }

  Rect _getSpotlightRect(TutorialStep step, Size screenSize) {
    final key = step.targetKey!;
    final renderObject = key.currentContext?.findRenderObject();
    if (renderObject == null || !renderObject.attached) {
      return Rect.fromCenter(
        center: Offset(screenSize.width / 2, screenSize.height / 2),
        width: 200,
        height: 200,
      );
    }

    final renderBox = renderObject as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);
    var rect = Rect.fromLTWH(
      offset.dx,
      offset.dy,
      renderBox.size.width,
      renderBox.size.height,
    );

    if (step.spotlightHeightFraction != null) {
      final fraction = step.spotlightHeightFraction!;
      final offsetY = step.spotlightOffsetY ?? 0.0;
      final h = rect.height * fraction;
      final y = rect.top + (rect.height * 0.75) - (h / 2) + offsetY;
      rect = Rect.fromLTWH(rect.left, y, rect.width, h);
    }

    return rect;
  }

  Widget _buildTooltip(
    BuildContext context,
    TutorialStep step,
    Rect? spotlightRect,
    Size screenSize,
    AppColors colors,
  ) {
    final isLastStep = _currentStep == widget.steps.length - 1;
    final tooltipWidth = (screenSize.width * 0.85).clamp(280.0, 400.0);

    double tooltipLeft;
    double tooltipTop;

    if (step.isCentered || spotlightRect == null) {
      tooltipLeft = (screenSize.width - tooltipWidth) / 2;
      tooltipTop = screenSize.height * 0.35;
    } else {
      tooltipLeft = (screenSize.width - tooltipWidth) / 2;
      final spaceAbove = spotlightRect.top - 80;
      final spaceBelow =
          screenSize.height - spotlightRect.bottom - 80;

      if (spaceAbove > 100) {
        tooltipTop = spotlightRect.top - 140;
      } else if (spaceBelow > 100) {
        tooltipTop = spotlightRect.bottom + 20;
      } else {
        tooltipTop = spotlightRect.bottom + 16;
      }
    }

    return Positioned(
      left: tooltipLeft,
      top: tooltipTop,
      width: tooltipWidth,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!step.isCentered)
                Container(
                  width: 36,
                  height: 36,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: colors.accent.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _iconForStep(_currentStep),
                    color: colors.accent,
                    size: 20,
                  ),
                ),
              Text(
                step.text,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: colors.onBgLight,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: isLastStep ? _complete : nextStep,
                  style: FilledButton.styleFrom(
                    backgroundColor: colors.accent,
                    foregroundColor: colors.onAccent,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    isLastStep ? '¡Empezar!' : 'Siguiente',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepIndicator(AppColors colors) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.steps.length, (i) {
        final isActive = i == _currentStep;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: isActive
                ? colors.accent
                : colors.accent.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }

  IconData _iconForStep(int step) {
    switch (step) {
      case 0:
        return Icons.view_stream_rounded;
      case 1:
        return Icons.horizontal_rule_rounded;
      case 2:
        return Icons.album_rounded;
      case 3:
        return Icons.palette_rounded;
      case 4:
        return Icons.speed_rounded;
      case 5:
        return Icons.play_arrow_rounded;
      default:
        return Icons.info_outline;
    }
  }
}

class _SpotlightPainter extends CustomPainter {
  final Rect? spotlightRect;
  final double opacity;

  _SpotlightPainter({this.spotlightRect, required this.opacity});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black.withValues(alpha: opacity);

    final fullPath = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    if (spotlightRect != null) {
      const radius = 12.0;
      final holePath = Path()
        ..addRRect(RRect.fromRectAndRadius(spotlightRect!, const Radius.circular(radius)));

      final combinedPath = Path.combine(
        PathOperation.difference,
        fullPath,
        holePath,
      );
      canvas.drawPath(combinedPath, paint);
    } else {
      canvas.drawPath(fullPath, paint);
    }
  }

  @override
  bool shouldRepaint(_SpotlightPainter oldDelegate) =>
      oldDelegate.spotlightRect != spotlightRect ||
      oldDelegate.opacity != opacity;
}
