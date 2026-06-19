// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_song_progress.freezed.dart';
part 'user_song_progress.g.dart';

@freezed
class UserSongProgress with _$UserSongProgress {
  const factory UserSongProgress({
    String? id,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'song_id') required String songId,
    @JsonKey(name: 'play_count') required int playCount,
    required bool completed,
    @JsonKey(name: 'last_played_at') required DateTime lastPlayedAt,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _UserSongProgress;

  factory UserSongProgress.fromJson(Map<String, dynamic> json) =>
      _$UserSongProgressFromJson(json);
}
