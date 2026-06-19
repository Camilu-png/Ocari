// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'song_note.freezed.dart';
part 'song_note.g.dart';

@freezed
class SongNote with _$SongNote {
  const factory SongNote({
    required String note,
    required List<int> top,
    required List<int> bot,
    required List<int> sub,
    required List<int> middle,
    @JsonKey(name: 'timestamp_ms') required int timestampMs,
    @JsonKey(name: 'duration_ms') required int durationMs,
    @JsonKey(name: 'note_value') required String noteValue,
  }) = _SongNote;

  factory SongNote.fromJson(Map<String, dynamic> json) =>
      _$SongNoteFromJson(json);
}
