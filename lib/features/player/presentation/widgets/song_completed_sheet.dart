import 'package:flutter/material.dart';

import 'package:ocari/core/theme/app_theme.dart';

void showSongCompletedSheet(
  BuildContext context, {
  required String songTitle,
  required int playCount,
  required VoidCallback onPlayAgain,
  required VoidCallback onGoToCatalog,
}) {
  final colors = context.colors;

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
                'Cancion completada',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: colors.onBgLight,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                songTitle,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: colors.accent,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                playCount == 1
                    ? 'Has tocado esta cancion 1 vez'
                    : 'Has tocado esta cancion $playCount veces',
                style: TextStyle(
                  fontSize: 14,
                  color: colors.textSecondary,
                ),
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
                    'Volver al catalogo',
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
