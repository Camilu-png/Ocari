// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PlayerStateImpl _$$PlayerStateImplFromJson(Map<String, dynamic> json) =>
    _$PlayerStateImpl(
      song: Song.fromJson(json['song'] as Map<String, dynamic>),
      notes: (json['notes'] as List<dynamic>)
          .map((e) => SongNote.fromJson(e as Map<String, dynamic>))
          .toList(),
      currentNoteIndex: (json['currentNoteIndex'] as num).toInt(),
      isPlaying: json['isPlaying'] as bool,
      speed: (json['speed'] as num).toDouble(),
      position: Duration(microseconds: (json['position'] as num).toInt()),
    );

Map<String, dynamic> _$$PlayerStateImplToJson(_$PlayerStateImpl instance) =>
    <String, dynamic>{
      'song': instance.song,
      'notes': instance.notes,
      'currentNoteIndex': instance.currentNoteIndex,
      'isPlaying': instance.isPlaying,
      'speed': instance.speed,
      'position': instance.position.inMicroseconds,
    };
