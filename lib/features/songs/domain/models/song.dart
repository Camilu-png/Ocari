import 'dart:convert';

import 'package:ocari/core/difficulty.dart';

class Song {
  final String id;
  final String title;
  final Difficulty difficulty;
  final int durationSeconds;
  final String? artist;
  final bool isLocked;
  final String? audioUrl;
  final Map<String, dynamic>? notesJson;

  const Song({
    required this.id,
    required this.title,
    this.difficulty = Difficulty.easy,
    this.durationSeconds = 0,
    this.artist,
    this.isLocked = false,
    this.audioUrl,
    this.notesJson,
  });

  factory Song.fromSupabase(Map<String, dynamic> map) {
    return Song(
      id: map['id'] as String,
      title: map['title'] as String,
      artist: map['artist'] as String?,
      difficulty: Difficulty.values.firstWhere(
        (d) => d.name == map['difficulty'] as String,
      ),
      durationSeconds: map['duration_seconds'] as int,
      isLocked: map['is_premium'] as bool? ?? false,
      audioUrl: map['audio_url'] as String?,
      notesJson: _parseNotesJson(map['notes_json']),
    );
  }

  static Map<String, dynamic>? _parseNotesJson(dynamic value) {
    if (value == null) return null;
    if (value is Map<String, dynamic>) return value;
    if (value is String) {
      try {
        return jsonDecode(value) as Map<String, dynamic>;
      } catch (_) {
        return null;
      }
    }
    return null;
  }
}
