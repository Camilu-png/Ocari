// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_song_progress.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserSongProgressImpl _$$UserSongProgressImplFromJson(
        Map<String, dynamic> json) =>
    _$UserSongProgressImpl(
      id: json['id'] as String?,
      userId: json['user_id'] as String,
      songId: json['song_id'] as String,
      playCount: (json['play_count'] as num).toInt(),
      completed: json['completed'] as bool,
      lastPlayedAt: DateTime.parse(json['last_played_at'] as String),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$UserSongProgressImplToJson(
        _$UserSongProgressImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'song_id': instance.songId,
      'play_count': instance.playCount,
      'completed': instance.completed,
      'last_played_at': instance.lastPlayedAt.toIso8601String(),
      'created_at': instance.createdAt?.toIso8601String(),
    };
