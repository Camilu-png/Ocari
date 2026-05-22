import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class DifficultyBadge extends StatelessWidget {
  final String difficulty;

  const DifficultyBadge({super.key, required this.difficulty});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    final (Color bg, Color fg, String label) = switch (difficulty.toLowerCase()) {
      'easy' => (colors.diffEasyBg, colors.diffEasyText, 'Fácil'),
      'medium' => (colors.diffMediumBg, colors.diffMediumText, 'Medio'),
      'hard' => (colors.diffHardBg, colors.diffHardText, 'Difícil'),
      _ => (colors.textSecondary, colors.onBgLight, difficulty),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: fg,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}