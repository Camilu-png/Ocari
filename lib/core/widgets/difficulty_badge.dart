import 'package:flutter/material.dart';
import 'package:ocari/core/difficulty.dart';
import 'package:ocari/core/theme/app_theme.dart';

class DifficultyBadge extends StatelessWidget {
  final Difficulty difficulty;

  const DifficultyBadge({super.key, required this.difficulty});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    final (Color bg, Color fg) = switch (difficulty) {
      Difficulty.easy => (colors.diffEasyBg, colors.diffEasyText),
      Difficulty.medium => (colors.diffMediumBg, colors.diffMediumText),
      Difficulty.hard => (colors.diffHardBg, colors.diffHardText),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        difficulty.label,
        style: TextStyle(
          color: fg,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
