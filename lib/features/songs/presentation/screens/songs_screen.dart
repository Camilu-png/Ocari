import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../auth/presentation/providers/auth_notifier.dart';

class Song {
  final String id;
  final String title;

  const Song({required this.id, required this.title});
}

final songsProvider = Provider<List<Song>>((ref) {
  return const [
    Song(id: '1', title: 'Twinkle Twinkle Little Star'),
    Song(id: '2', title: 'Mary Had a Little Lamb'),
    Song(id: '3', title: 'Happy Birthday'),
  ];
});

class SongsScreen extends ConsumerWidget {
  const SongsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final songs = ref.watch(songsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Songs'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await ref.read(authProvider.notifier).logout();
              if (context.mounted) {
                context.go('/login');
              }
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Songs Screen'),
            const SizedBox(height: 24),
            ...songs.map((song) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: FilledButton(
                onPressed: () => context.go('/player/${song.id}'),
                child: Text(song.title),
              ),
            )),
          ],
        ),
      ),
    );
  }
}