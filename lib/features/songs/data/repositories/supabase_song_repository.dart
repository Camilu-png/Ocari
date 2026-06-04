import 'dart:convert';

import 'package:flutter/foundation.dart';
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
    } catch (e) {
      debugPrint('Supabase fetchAll failed, falling back to local assets: $e');
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
    } catch (e) {
      debugPrint('Supabase fetchById($id) failed, falling back: $e');
      return _fallbackById(id);
    }
  }

  Future<List<Song>> _fallbackAll() async {
    final indexJson = await rootBundle.loadString('assets/data/songs_index.json');
    final ids = jsonDecode(indexJson) as List<dynamic>;

    final songs = <Song>[];
    for (final id in ids) {
      try {
        final song = await _fallbackById(id as String);
        if (song != null) {
          songs.add(song);
        } else {
          debugPrint('Fallback: failed to load song $id');
        }
      } catch (e) {
        debugPrint('Fallback: error loading song $id: $e');
      }
    }
    return songs;
  }

  Future<Song?> _fallbackById(String id) async {
    final path = 'assets/data/songs/$id.json';
    final jsonStr = await rootBundle.loadString(path);
    final data = jsonDecode(jsonStr) as Map<String, dynamic>;
    data['id'] = id;
    return Song.fromJson(_normalize(data));
  }
}
