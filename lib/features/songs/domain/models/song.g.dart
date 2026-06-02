// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'song.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SongImpl _$$SongImplFromJson(Map<String, dynamic> json) => _$SongImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      artist: json['artist'] as String? ?? 'Desconocido',
      difficulty: json['difficulty'] as String,
      durationSeconds: (json['duration_seconds'] as num).toInt(),
      isPremium: json['is_premium'] as bool? ?? false,
      audioPath: json['audio_url'] as String?,
      notesJson: json['notes_json'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$SongImplToJson(_$SongImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'artist': instance.artist,
      'difficulty': instance.difficulty,
      'duration_seconds': instance.durationSeconds,
      'is_premium': instance.isPremium,
      'audio_url': instance.audioPath,
      'notes_json': instance.notesJson,
    };
