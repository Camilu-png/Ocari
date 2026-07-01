import 'package:flutter/material.dart';

import 'package:ocari/core/theme/app_theme.dart';

({String title, String subtitle}) _completionMessage(int playCount) {
  return switch (playCount) {
     1 => (
        title: 'First performance!',
        subtitle: 'Every great melody starts with a single note.',
      ),
    2 || 3 => (
        title: 'Finding the rhythm',
        subtitle: 'Each repetition strengthens your musical memory.',
      ),
    4 || 5 || 6 => (
        title: 'The melody is sticking with you',
        subtitle: 'Your finger movements are becoming more natural.',
      ),
    7 || 8 || 9 => (
        title: 'Almost a master',
        subtitle: 'Consistent practice is the secret of every musician.',
      ),
    10 || 11 || 12 => (
        title: 'You know this song well now',
        subtitle: 'Now you can focus on your fluency.',
      ),
    _ => (
        title: 'Song mastered',
        subtitle: 'This melody is now part of your repertoire.',
      ),
  };
}

void showSongCompletedSheet(
  BuildContext context, {
  required String songTitle,
  required int playCount,
  required VoidCallback onPlayAgain,
  required VoidCallback onGoToCatalog,
}) {
  final colors = context.colors;
  final msg = _completionMessage(playCount);
  final countText = playCount == 1
      ? 'You have played this song 1 time.'
      : 'You have played this song $playCount times.';

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: colors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (ctx) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
              Text(
                msg.title,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: colors.onBgLight,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                songTitle,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: colors.accent,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                msg.subtitle,
                style: TextStyle(
                  fontSize: 14,
                  color: colors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                countText,
                style: TextStyle(
                  fontSize: 13,
                  color: colors.textSecondary,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.lg),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    onPlayAgain();
                  },
                  child: const Text('Play again'),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    onGoToCatalog();
                  },
                  child: Text(
                    'Back to catalog',
                    style: TextStyle(color: colors.textSecondary),
                  ),
                ),
              ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
