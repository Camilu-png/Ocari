import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ocari/features/auth/presentation/providers/auth_notifier.dart';
import 'package:ocari/features/songs/data/repositories/firebase_song_repository.dart';
import 'package:ocari/features/songs/domain/models/song.dart';
import 'package:ocari/features/songs/domain/repositories/song_repository.dart';

final songRepositoryProvider = Provider<SongRepository>((ref) {
  return FirebaseSongRepository(
    ref.watch(firebaseFirestoreProvider),
  );
});

final songsProvider =
    AsyncNotifierProvider<SongsNotifier, List<Song>>(SongsNotifier.new);

class SongsNotifier extends AsyncNotifier<List<Song>> {
  @override
  Future<List<Song>> build() async {
    final repo = ref.read(songRepositoryProvider);
    return repo.fetchAll();
  }

  Future<Song?> getById(String id) async {
    final songs = state.valueOrNull;
    if (songs != null) {
      final cached = songs.where((s) => s.id == id).firstOrNull;
      if (cached != null) return cached;
    }
    final repo = ref.read(songRepositoryProvider);
    return repo.fetchById(id);
  }

  Future<void> refresh() async {
    final repo = ref.read(songRepositoryProvider);
    state = const AsyncLoading();
    state = AsyncData(await repo.fetchAll());
  }
}

final songByIdProvider = FutureProvider.family<Song?, String>((ref, id) async {
  return ref.read(songsProvider.notifier).getById(id);
});
