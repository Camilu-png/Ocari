// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_song_progress.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserSongProgress _$UserSongProgressFromJson(Map<String, dynamic> json) {
  return _UserSongProgress.fromJson(json);
}

/// @nodoc
mixin _$UserSongProgress {
  String? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'song_id')
  String get songId => throw _privateConstructorUsedError;
  @JsonKey(name: 'play_count')
  int get playCount => throw _privateConstructorUsedError;
  bool get completed => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_played_at')
  DateTime get lastPlayedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this UserSongProgress to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserSongProgress
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserSongProgressCopyWith<UserSongProgress> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserSongProgressCopyWith<$Res> {
  factory $UserSongProgressCopyWith(
          UserSongProgress value, $Res Function(UserSongProgress) then) =
      _$UserSongProgressCopyWithImpl<$Res, UserSongProgress>;
  @useResult
  $Res call(
      {String? id,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'song_id') String songId,
      @JsonKey(name: 'play_count') int playCount,
      bool completed,
      @JsonKey(name: 'last_played_at') DateTime lastPlayedAt,
      @JsonKey(name: 'created_at') DateTime? createdAt});
}

/// @nodoc
class _$UserSongProgressCopyWithImpl<$Res, $Val extends UserSongProgress>
    implements $UserSongProgressCopyWith<$Res> {
  _$UserSongProgressCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserSongProgress
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? userId = null,
    Object? songId = null,
    Object? playCount = null,
    Object? completed = null,
    Object? lastPlayedAt = null,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      songId: null == songId
          ? _value.songId
          : songId // ignore: cast_nullable_to_non_nullable
              as String,
      playCount: null == playCount
          ? _value.playCount
          : playCount // ignore: cast_nullable_to_non_nullable
              as int,
      completed: null == completed
          ? _value.completed
          : completed // ignore: cast_nullable_to_non_nullable
              as bool,
      lastPlayedAt: null == lastPlayedAt
          ? _value.lastPlayedAt
          : lastPlayedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserSongProgressImplCopyWith<$Res>
    implements $UserSongProgressCopyWith<$Res> {
  factory _$$UserSongProgressImplCopyWith(_$UserSongProgressImpl value,
          $Res Function(_$UserSongProgressImpl) then) =
      __$$UserSongProgressImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? id,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'song_id') String songId,
      @JsonKey(name: 'play_count') int playCount,
      bool completed,
      @JsonKey(name: 'last_played_at') DateTime lastPlayedAt,
      @JsonKey(name: 'created_at') DateTime? createdAt});
}

/// @nodoc
class __$$UserSongProgressImplCopyWithImpl<$Res>
    extends _$UserSongProgressCopyWithImpl<$Res, _$UserSongProgressImpl>
    implements _$$UserSongProgressImplCopyWith<$Res> {
  __$$UserSongProgressImplCopyWithImpl(_$UserSongProgressImpl _value,
      $Res Function(_$UserSongProgressImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserSongProgress
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? userId = null,
    Object? songId = null,
    Object? playCount = null,
    Object? completed = null,
    Object? lastPlayedAt = null,
    Object? createdAt = freezed,
  }) {
    return _then(_$UserSongProgressImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      songId: null == songId
          ? _value.songId
          : songId // ignore: cast_nullable_to_non_nullable
              as String,
      playCount: null == playCount
          ? _value.playCount
          : playCount // ignore: cast_nullable_to_non_nullable
              as int,
      completed: null == completed
          ? _value.completed
          : completed // ignore: cast_nullable_to_non_nullable
              as bool,
      lastPlayedAt: null == lastPlayedAt
          ? _value.lastPlayedAt
          : lastPlayedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserSongProgressImpl implements _UserSongProgress {
  const _$UserSongProgressImpl(
      {this.id,
      @JsonKey(name: 'user_id') required this.userId,
      @JsonKey(name: 'song_id') required this.songId,
      @JsonKey(name: 'play_count') required this.playCount,
      required this.completed,
      @JsonKey(name: 'last_played_at') required this.lastPlayedAt,
      @JsonKey(name: 'created_at') this.createdAt});

  factory _$UserSongProgressImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserSongProgressImplFromJson(json);

  @override
  final String? id;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  @JsonKey(name: 'song_id')
  final String songId;
  @override
  @JsonKey(name: 'play_count')
  final int playCount;
  @override
  final bool completed;
  @override
  @JsonKey(name: 'last_played_at')
  final DateTime lastPlayedAt;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  @override
  String toString() {
    return 'UserSongProgress(id: $id, userId: $userId, songId: $songId, playCount: $playCount, completed: $completed, lastPlayedAt: $lastPlayedAt, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserSongProgressImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.songId, songId) || other.songId == songId) &&
            (identical(other.playCount, playCount) ||
                other.playCount == playCount) &&
            (identical(other.completed, completed) ||
                other.completed == completed) &&
            (identical(other.lastPlayedAt, lastPlayedAt) ||
                other.lastPlayedAt == lastPlayedAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, userId, songId, playCount,
      completed, lastPlayedAt, createdAt);

  /// Create a copy of UserSongProgress
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserSongProgressImplCopyWith<_$UserSongProgressImpl> get copyWith =>
      __$$UserSongProgressImplCopyWithImpl<_$UserSongProgressImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserSongProgressImplToJson(
      this,
    );
  }
}

abstract class _UserSongProgress implements UserSongProgress {
  const factory _UserSongProgress(
          {final String? id,
          @JsonKey(name: 'user_id') required final String userId,
          @JsonKey(name: 'song_id') required final String songId,
          @JsonKey(name: 'play_count') required final int playCount,
          required final bool completed,
          @JsonKey(name: 'last_played_at') required final DateTime lastPlayedAt,
          @JsonKey(name: 'created_at') final DateTime? createdAt}) =
      _$UserSongProgressImpl;

  factory _UserSongProgress.fromJson(Map<String, dynamic> json) =
      _$UserSongProgressImpl.fromJson;

  @override
  String? get id;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  @JsonKey(name: 'song_id')
  String get songId;
  @override
  @JsonKey(name: 'play_count')
  int get playCount;
  @override
  bool get completed;
  @override
  @JsonKey(name: 'last_played_at')
  DateTime get lastPlayedAt;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;

  /// Create a copy of UserSongProgress
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserSongProgressImplCopyWith<_$UserSongProgressImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
