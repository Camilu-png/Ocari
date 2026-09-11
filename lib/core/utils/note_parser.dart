import 'dart:convert';

import 'package:ocari/features/songs/domain/models/song_note.dart';

Map<String, dynamic> normalizeSongData(Map<String, dynamic> raw) {
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

List<SongNote> parseNotes(Map<String, dynamic> notesJson) {
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