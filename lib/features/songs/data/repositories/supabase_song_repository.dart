import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:ocari/features/songs/domain/models/song.dart';
import 'package:ocari/features/songs/domain/models/song_note.dart';
import 'package:ocari/features/songs/domain/repositories/song_repository.dart';

class SupabaseSongRepository implements SongRepository {
  final SupabaseClient _client;
  final AssetBundle _bundle;

  SupabaseSongRepository(this._client, [AssetBundle? bundle])
      : _bundle = bundle ?? rootBundle;

  @visibleForTesting
  static Map<String, dynamic> normalize(Map<String, dynamic> raw) {
    final data = Map<String, dynamic>.from(raw);

    if (data['notes_json'] is String) {
      try {
        final decoded = jsonDecode(data['notes_json'] as String);
        if (decoded is Map<String, dynamic>) {
          data['notes_json'] = decoded;
        } else if (decoded is List) {
          data['notes_json'] = <String, dynamic>{'notes': decoded};
        } else {
          data['notes_json'] = null;
        }
      } catch (_) {
        data['notes_json'] = null;
      }
    } else if (data['notes_json'] is List) {
      data['notes_json'] = <String, dynamic>{'notes': data['notes_json']};
    }

    return data;
  }

  static List<SongNote> parseNotes(Map<String, dynamic> notesJson) {
    final notesValue = notesJson['notes'];
    if (notesValue is List) {
      return notesValue
          .map((n) => SongNote.fromJson(n as Map<String, dynamic>))
          .toList();
    }

    final firstValue = notesJson.values.firstOrNull;
    if (firstValue is List) {
      return firstValue
          .map((n) => SongNote.fromJson(n as Map<String, dynamic>))
          .toList();
    }

    final noteList = notesJson.entries
        .where((e) => e.value is List)
        .map((e) => e.value as List)
        .expand((l) => l)
        .map((n) => SongNote.fromJson(n as Map<String, dynamic>))
        .toList();
    if (noteList.isNotEmpty) return noteList;

    throw FormatException(
      'No notes array found in notesJson. '
      'Available keys: ${notesJson.keys.join(", ")}',
    );
  }

  @visibleForTesting
  Future<List<Song>> fetchAllFromSupabase() async {
    final response = await _client.from('songs').select('*');
    return (response as List)
        .map((e) => Song.fromJson(normalize(e as Map<String, dynamic>)))
        .toList();
  }

  @visibleForTesting
  Future<Song?> fetchByIdFromSupabase(String id) async {
    final response =
        await _client.from('songs').select('*').eq('id', id).maybeSingle();
    if (response == null) return null;
    return Song.fromJson(normalize(response));
  }

  @override
  Future<List<Song>> fetchAll() async {
    try {
      return await fetchAllFromSupabase();
    } catch (e) {
      debugPrint('Supabase fetchAll failed, falling back to local assets: $e');
      return _fallbackAll();
    }
  }

  @override
  Future<Song?> fetchById(String id) async {
    try {
      return await fetchByIdFromSupabase(id);
    } catch (e) {
      debugPrint('Supabase fetchById($id) failed, falling back: $e');
      return _fallbackById(id);
    }
  }

  Future<List<Song>> _fallbackAll() async {
    try {
      final indexJson =
          await _bundle.loadString('assets/data/songs_index.json');
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
    } catch (e) {
      debugPrint('Fallback: failed to load song index: $e');
      return [];
    }
  }

  Future<Song?> _fallbackById(String id) async {
    try {
      final path = 'assets/data/songs/$id.json';
      final jsonStr = await _bundle.loadString(path);
      final data = jsonDecode(jsonStr) as Map<String, dynamic>;
      data['id'] = id;
      debugPrint('jsonStr: $jsonStr');
      return Song.fromJson(normalize(data));
    } catch (e) {
      debugPrint('Fallback: failed to load song $id: $e');
      return null;
    }
  }
}
