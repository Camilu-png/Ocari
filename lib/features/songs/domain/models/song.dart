// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

import 'difficulty.dart';

part 'song.freezed.dart';
part 'song.g.dart';

@freezed
class Song with _$Song {
  const factory Song({
    required String id,
    required String title,
    @Default('Unknown') String artist,
    required Difficulty difficulty,
    @JsonKey(name: 'duration_seconds') required int durationSeconds,
    @Default(false) @JsonKey(name: 'is_premium') bool isPremium,
    @JsonKey(name: 'audio_url') String? audioPath,
    @JsonKey(name: 'notes_json') Map<String, dynamic>? notesJson,
  }) = _Song;

  factory Song.fromJson(Map<String, dynamic> json) => _$SongFromJson(json);
}
