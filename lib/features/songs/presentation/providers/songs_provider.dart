import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:ocari/features/songs/data/repositories/supabase_song_repository.dart';
import 'package:ocari/features/songs/domain/models/song.dart';
import 'package:ocari/features/songs/domain/repositories/song_repository.dart';

final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

final songRepositoryProvider = Provider<SongRepository>((ref) {
  return SupabaseSongRepository(ref.watch(supabaseClientProvider));
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
