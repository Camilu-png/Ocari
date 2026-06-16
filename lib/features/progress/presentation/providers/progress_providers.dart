import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ocari/features/progress/data/repositories/supabase_user_song_progress_repository.dart';
import 'package:ocari/features/progress/domain/repositories/user_song_progress_repository.dart';
import 'package:ocari/features/songs/presentation/providers/songs_provider.dart';

final userSongProgressRepositoryProvider =
    Provider<UserSongProgressRepository>((ref) {
  return SupabaseUserSongProgressRepository(ref.watch(supabaseClientProvider));
});
