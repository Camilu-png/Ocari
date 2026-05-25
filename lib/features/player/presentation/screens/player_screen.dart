import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:ocari/core/widgets/ocari_button.dart';
import 'package:ocari/core/widgets/ocari_scaffold.dart';

class PlayerScreen extends StatelessWidget {
  final String songId;

  const PlayerScreen({super.key, required this.songId});

  @override
  Widget build(BuildContext context) {
    return OcariScaffold(
      title: 'Player',
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Player Screen - Song: $songId'),
            const SizedBox(height: 24),
            OcariButton(
              label: 'Back to Songs',
              onPressed: () => context.go('/songs'),
              isFullWidth: false,
            ),
          ],
        ),
      ),
    );
  }
}
