import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:ocari/features/progress/domain/models/user_song_progress.dart';
import 'package:ocari/features/progress/domain/repositories/user_song_progress_repository.dart';

class SupabaseUserSongProgressRepository
    implements UserSongProgressRepository {
  final SupabaseClient _client;

  SupabaseUserSongProgressRepository(this._client);

  @override
  Future<UserSongProgress> recordCompletion({
    required String userId,
    required String songId,
  }) async {
    final response = await _client.rpc('record_song_completion', params: {
      'p_user_id': userId,
      'p_song_id': songId,
    });

    final row = response as List<dynamic>? ?? [response];
    if (row.isEmpty) {
      throw Exception('record_song_completion returned no data');
    }

    return UserSongProgress.fromJson(row.first as Map<String, dynamic>);
  }
}
