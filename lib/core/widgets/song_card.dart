import 'package:flutter/material.dart';
import 'package:ocari/core/theme/app_theme.dart';
import 'package:ocari/features/songs/domain/models/difficulty.dart';
import 'difficulty_badge.dart';

class SongCard extends StatelessWidget {
  static const double _lockedOpacity = 0.5;

  final String title;
  final Difficulty difficulty;
  final int durationSeconds;
  final VoidCallback onTap;
  final String? artist;
  final bool isLocked;

  const SongCard({
    super.key,
    required this.title,
    required this.difficulty,
    required this.durationSeconds,
    required this.onTap,
    this.artist,
    this.isLocked = false,
  });

  String _formatDuration(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Opacity(
      opacity: isLocked ? _lockedOpacity : 1,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.borderRadiusLg,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: AppRadius.borderRadiusLg,
          ),
          child: Row(
            children: [
              Icon(
                Icons.music_note_rounded,
                color: colors.accent,
                size: 32,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.label(colors.onBgLight),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (artist != null)
                      Text(
                        artist!,
                        style: AppTextStyles.caption(colors.textSecondary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              if (isLocked)
                Icon(
                  Icons.lock_rounded,
                  color: colors.textSecondary,
                  size: 20,
                )
              else
                DifficultyBadge(difficulty: difficulty),
              const SizedBox(width: AppSpacing.sm),
              Text(
                _formatDuration(durationSeconds),
                style: AppTextStyles.caption(colors.textSecondary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
