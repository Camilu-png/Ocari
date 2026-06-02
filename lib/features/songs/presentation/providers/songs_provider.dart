import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:ocari/features/songs/data/songs_repository.dart';
import 'package:ocari/features/songs/domain/models/song.dart';

final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

final songsRepositoryProvider = Provider<SongsRepository>((ref) {
  return SongsRepository(ref.watch(supabaseClientProvider));
});

final songsProvider = FutureProvider<List<Song>>((ref) async {
  return ref.watch(songsRepositoryProvider).fetchAll();
});

final songByIdProvider = FutureProvider.family<Song?, String>((ref, id) async {
  return ref.watch(songsRepositoryProvider).fetchById(id);
});
