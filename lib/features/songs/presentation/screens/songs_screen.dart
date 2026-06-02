import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:ocari/core/widgets/ocari_scaffold.dart';
import 'package:ocari/core/widgets/song_card.dart';
import 'package:ocari/features/auth/presentation/providers/auth_notifier.dart';
import 'package:ocari/features/songs/presentation/providers/songs_provider.dart';

class SongsScreen extends ConsumerWidget {
  const SongsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final songsAsync = ref.watch(songsProvider);

    return OcariScaffold(
      title: 'Songs',
      actions: [
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () async {
            final confirmed = await showDialog<bool>(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('Sign out'),
                content: const Text('Are you sure you want to sign out?'),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.of(ctx).pop(false),
                      child: const Text('Cancel')),
                  TextButton(
                      onPressed: () => Navigator.of(ctx).pop(true),
                      child: const Text('Sign out')),
                ],
              ),
            );
            if (confirmed == true) {
              await ref.read(authProvider.notifier).logout();
              if (context.mounted) {
                context.go('/login');
              }
            }
          },
        ),
      ],
      body: songsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Failed to load songs: $err')),
        data: (songs) => ListView(
          padding: const EdgeInsets.all(16),
          children: songs
              .map((song) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: SongCard(
                      title: song.title,
                      artist: song.artist,
                      difficulty: song.difficulty,
                      durationSeconds: song.durationSeconds,
                      isLocked: song.isLocked,
                      onTap: () => context.push('/player/${song.id}'),
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }
}
