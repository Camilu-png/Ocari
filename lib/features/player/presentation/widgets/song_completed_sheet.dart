import 'package:flutter/material.dart';

import 'package:ocari/core/theme/app_theme.dart';

({String title, String subtitle}) _completionMessage(int playCount) {
  return switch (playCount) {
    1 => (
        title: '¡Primera interpretación!',
        subtitle: 'Toda gran melodía comienza con una sola nota.',
      ),
    2 || 3 => (
        title: 'Ya estás tomando ritmo',
        subtitle: 'Cada repetición fortalece tu memoria musical.',
      ),
    4 || 5 || 6 => (
        title: 'La melodía empieza a quedarse contigo',
        subtitle: 'Los movimientos de tus dedos ya son más naturales.',
      ),
    7 || 8 || 9 => (
        title: 'Casi un maestro',
        subtitle: 'La práctica constante es el secreto de todo músico.',
      ),
    10 || 11 || 12 => (
        title: 'Ya conoces esta canción bastante bien',
        subtitle: 'Ahora puedes concentrarte en tu fluidez.',
      ),
    _ => (
        title: 'Canción dominada',
        subtitle: 'Esta melodía ya forma parte de tu repertorio.',
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
      ? 'Has tocado esta canción 1 vez.'
      : 'Has tocado esta canción $playCount veces.';

  showModalBottomSheet(
    context: context,
    backgroundColor: colors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (ctx) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
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
                  child: const Text('Tocar de nuevo'),
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
                    'Volver al catálogo',
                    style: TextStyle(color: colors.textSecondary),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
