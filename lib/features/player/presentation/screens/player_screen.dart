import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PlayerScreen extends StatelessWidget {
  final String songId;

  const PlayerScreen({super.key, required this.songId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Player')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Player Screen - Song: $songId'),
            const SizedBox(height: 24),
            FilledButton(
onPressed: () => context.go('/songs'),
                child: const Text('Back to Songs'),
            ),
          ],
        ),
      ),
    );
  }
}