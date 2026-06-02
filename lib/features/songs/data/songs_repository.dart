import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:ocari/features/songs/domain/models/song.dart';

class SongsRepository {
  final SupabaseClient _client;

  SongsRepository(this._client);

  Future<List<Song>> fetchAll() async {
    final response = await _client.from('songs').select('*');
    return (response as List)
        .map((e) => Song.fromSupabase(e as Map<String, dynamic>))
        .toList();
  }

  Future<Song?> fetchById(String id) async {
    final response =
        await _client.from('songs').select('*').eq('id', id).maybeSingle();
    if (response == null) return null;
    return Song.fromSupabase(response);
  }
}
