// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'song_note.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SongNoteImpl _$$SongNoteImplFromJson(Map<String, dynamic> json) =>
    _$SongNoteImpl(
      note: json['note'] as String,
      top: (json['top'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
      bot: (json['bot'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
      sub: (json['sub'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
      middle: (json['middle'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
      timestampMs: (json['timestamp_ms'] as num).toInt(),
      durationMs: (json['duration_ms'] as num).toInt(),
      noteValue: json['note_value'] as String,
    );

Map<String, dynamic> _$$SongNoteImplToJson(_$SongNoteImpl instance) =>
    <String, dynamic>{
      'note': instance.note,
      'top': instance.top,
      'bot': instance.bot,
      'sub': instance.sub,
      'middle': instance.middle,
      'timestamp_ms': instance.timestampMs,
      'duration_ms': instance.durationMs,
      'note_value': instance.noteValue,
    };
