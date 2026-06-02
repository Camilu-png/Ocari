import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:ocari/features/songs/domain/models/song.dart';
import 'package:ocari/features/songs/domain/repositories/song_repository.dart';

class SupabaseSongRepository implements SongRepository {
  final SupabaseClient _client;

  SupabaseSongRepository(this._client);

  Map<String, dynamic> _normalize(Map<String, dynamic> raw) {
    final data = Map<String, dynamic>.from(raw);
    data['artist'] ??= 'Desconocido';

    if (data['notes_json'] is String) {
      try {
        data['notes_json'] =
            jsonDecode(data['notes_json'] as String) as Map<String, dynamic>;
      } catch (_) {
        data['notes_json'] = null;
      }
    }

    return data;
  }

  @override
  Future<List<Song>> fetchAll() async {
    try {
      final response = await _client.from('songs').select('*');
      return (response as List)
          .map((e) => Song.fromJson(_normalize(e as Map<String, dynamic>)))
          .toList();
    } catch (_) {
      return _fallbackAll();
    }
  }

  @override
  Future<Song?> fetchById(String id) async {
    try {
      final response =
          await _client.from('songs').select('*').eq('id', id).maybeSingle();
      if (response == null) return null;
      return Song.fromJson(_normalize(response));
    } catch (_) {
      return _fallbackById(id);
    }
  }

  Future<List<Song>> _fallbackAll() async {
    try {
      final manifest = await rootBundle.loadString('AssetManifest.json');
      final assets = (jsonDecode(manifest) as Map<String, dynamic>).keys;
      final songFiles = assets
          .where((a) =>
              a.startsWith('assets/data/songs/') && a.endsWith('.json'))
          .toList();

      final songs = <Song>[];
      for (final path in songFiles) {
        final jsonStr = await rootBundle.loadString(path);
        final data = jsonDecode(jsonStr) as Map<String, dynamic>;
        data['id'] = path.split('/').last.replaceAll('.json', '');
        songs.add(Song.fromJson(_normalize(data)));
      }
      return songs;
    } catch (_) {
      return [];
    }
  }

  Future<Song?> _fallbackById(String id) async {
    try {
      final jsonStr =
          await rootBundle.loadString('assets/data/songs/$id.json');
      final data = jsonDecode(jsonStr) as Map<String, dynamic>;
      data['id'] = id;
      return Song.fromJson(_normalize(data));
    } catch (_) {
      return null;
    }
  }
}
