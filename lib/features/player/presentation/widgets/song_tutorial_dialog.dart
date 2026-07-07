import 'package:flutter/material.dart';

import 'package:ocari/core/theme/app_theme.dart';

class SongTutorialDialog extends StatelessWidget {
  final String songTitle;
  final VoidCallback onAcknowledged;

  const SongTutorialDialog({
    super.key,
    required this.songTitle,
    required this.onAcknowledged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return AlertDialog(
      backgroundColor: colors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      title: Text(
        'Tips for "$songTitle"',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: colors.onBgLight,
        ),
        textAlign: TextAlign.center,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _tip(colors, Icons.music_note_rounded, 'Follow the notes on the track'),
          const SizedBox(height: 12),
          _tip(colors, Icons.palette_rounded, 'Each note has a unique color'),
          const SizedBox(height: 12),
          _tip(
            colors,
            Icons.speed_rounded,
            'Change speed with the × button',
          ),
          const SizedBox(height: 12),
          _tip(
            colors,
            Icons.touch_app_rounded,
            'Tap the ocarina holes to play',
          ),
        ],
      ),
      actions: [
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: () {
              onAcknowledged();
              Navigator.of(context).pop();
            },
            child: const Text('Got it!'),
          ),
        ),
      ],
    );
  }

  Widget _tip(AppColors colors, IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 20, color: colors.accent),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: colors.onBgLight,
            ),
          ),
        ),
      ],
    );
  }
}
