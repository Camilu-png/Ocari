// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'player_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PlayerState _$PlayerStateFromJson(Map<String, dynamic> json) {
  return _PlayerState.fromJson(json);
}

/// @nodoc
mixin _$PlayerState {
  Song get song => throw _privateConstructorUsedError;
  List<SongNote> get notes => throw _privateConstructorUsedError;
  bool get isAudioReady => throw _privateConstructorUsedError;
  int get currentNoteIndex => throw _privateConstructorUsedError;
  bool get isPlaying => throw _privateConstructorUsedError;
  double get speed => throw _privateConstructorUsedError;
  Duration get position => throw _privateConstructorUsedError;

  /// Serializes this PlayerState to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PlayerState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PlayerStateCopyWith<PlayerState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlayerStateCopyWith<$Res> {
  factory $PlayerStateCopyWith(
          PlayerState value, $Res Function(PlayerState) then) =
      _$PlayerStateCopyWithImpl<$Res, PlayerState>;
  @useResult
  $Res call(
      {Song song,
      List<SongNote> notes,
      bool isAudioReady,
      int currentNoteIndex,
      bool isPlaying,
      double speed,
      Duration position});

  $SongCopyWith<$Res> get song;
}

/// @nodoc
class _$PlayerStateCopyWithImpl<$Res, $Val extends PlayerState>
    implements $PlayerStateCopyWith<$Res> {
  _$PlayerStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PlayerState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? song = null,
    Object? notes = null,
    Object? isAudioReady = null,
    Object? currentNoteIndex = null,
    Object? isPlaying = null,
    Object? speed = null,
    Object? position = null,
  }) {
    return _then(_value.copyWith(
      song: null == song
          ? _value.song
          : song // ignore: cast_nullable_to_non_nullable
              as Song,
      notes: null == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as List<SongNote>,
      isAudioReady: null == isAudioReady
          ? _value.isAudioReady
          : isAudioReady // ignore: cast_nullable_to_non_nullable
              as bool,
      currentNoteIndex: null == currentNoteIndex
          ? _value.currentNoteIndex
          : currentNoteIndex // ignore: cast_nullable_to_non_nullable
              as int,
      isPlaying: null == isPlaying
          ? _value.isPlaying
          : isPlaying // ignore: cast_nullable_to_non_nullable
              as bool,
      speed: null == speed
          ? _value.speed
          : speed // ignore: cast_nullable_to_non_nullable
              as double,
      position: null == position
          ? _value.position
          : position // ignore: cast_nullable_to_non_nullable
              as Duration,
    ) as $Val);
  }

  /// Create a copy of PlayerState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SongCopyWith<$Res> get song {
    return $SongCopyWith<$Res>(_value.song, (value) {
      return _then(_value.copyWith(song: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PlayerStateImplCopyWith<$Res>
    implements $PlayerStateCopyWith<$Res> {
  factory _$$PlayerStateImplCopyWith(
          _$PlayerStateImpl value, $Res Function(_$PlayerStateImpl) then) =
      __$$PlayerStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Song song,
      List<SongNote> notes,
      bool isAudioReady,
      int currentNoteIndex,
      bool isPlaying,
      double speed,
      Duration position});

  @override
  $SongCopyWith<$Res> get song;
}

/// @nodoc
class __$$PlayerStateImplCopyWithImpl<$Res>
    extends _$PlayerStateCopyWithImpl<$Res, _$PlayerStateImpl>
    implements _$$PlayerStateImplCopyWith<$Res> {
  __$$PlayerStateImplCopyWithImpl(
      _$PlayerStateImpl _value, $Res Function(_$PlayerStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of PlayerState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? song = null,
    Object? notes = null,
    Object? isAudioReady = null,
    Object? currentNoteIndex = null,
    Object? isPlaying = null,
    Object? speed = null,
    Object? position = null,
  }) {
    return _then(_$PlayerStateImpl(
      song: null == song
          ? _value.song
          : song // ignore: cast_nullable_to_non_nullable
              as Song,
      notes: null == notes
          ? _value._notes
          : notes // ignore: cast_nullable_to_non_nullable
              as List<SongNote>,
      isAudioReady: null == isAudioReady
          ? _value.isAudioReady
          : isAudioReady // ignore: cast_nullable_to_non_nullable
              as bool,
      currentNoteIndex: null == currentNoteIndex
          ? _value.currentNoteIndex
          : currentNoteIndex // ignore: cast_nullable_to_non_nullable
              as int,
      isPlaying: null == isPlaying
          ? _value.isPlaying
          : isPlaying // ignore: cast_nullable_to_non_nullable
              as bool,
      speed: null == speed
          ? _value.speed
          : speed // ignore: cast_nullable_to_non_nullable
              as double,
      position: null == position
          ? _value.position
          : position // ignore: cast_nullable_to_non_nullable
              as Duration,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PlayerStateImpl implements _PlayerState {
  const _$PlayerStateImpl(
      {required this.song,
      required final List<SongNote> notes,
      this.isAudioReady = false,
      required this.currentNoteIndex,
      required this.isPlaying,
      required this.speed,
      required this.position})
      : _notes = notes;

  factory _$PlayerStateImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlayerStateImplFromJson(json);

  @override
  final Song song;
  final List<SongNote> _notes;
  @override
  List<SongNote> get notes {
    if (_notes is EqualUnmodifiableListView) return _notes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_notes);
  }

  @override
  @JsonKey()
  final bool isAudioReady;
  @override
  final int currentNoteIndex;
  @override
  final bool isPlaying;
  @override
  final double speed;
  @override
  final Duration position;

  @override
  String toString() {
    return 'PlayerState(song: $song, notes: $notes, isAudioReady: $isAudioReady, currentNoteIndex: $currentNoteIndex, isPlaying: $isPlaying, speed: $speed, position: $position)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlayerStateImpl &&
            (identical(other.song, song) || other.song == song) &&
            const DeepCollectionEquality().equals(other._notes, _notes) &&
            (identical(other.isAudioReady, isAudioReady) ||
                other.isAudioReady == isAudioReady) &&
            (identical(other.currentNoteIndex, currentNoteIndex) ||
                other.currentNoteIndex == currentNoteIndex) &&
            (identical(other.isPlaying, isPlaying) ||
                other.isPlaying == isPlaying) &&
            (identical(other.speed, speed) || other.speed == speed) &&
            (identical(other.position, position) ||
                other.position == position));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      song,
      const DeepCollectionEquality().hash(_notes),
      isAudioReady,
      currentNoteIndex,
      isPlaying,
      speed,
      position);

  /// Create a copy of PlayerState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PlayerStateImplCopyWith<_$PlayerStateImpl> get copyWith =>
      __$$PlayerStateImplCopyWithImpl<_$PlayerStateImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PlayerStateImplToJson(
      this,
    );
  }
}

abstract class _PlayerState implements PlayerState {
  const factory _PlayerState(
      {required final Song song,
      required final List<SongNote> notes,
      final bool isAudioReady,
      required final int currentNoteIndex,
      required final bool isPlaying,
      required final double speed,
      required final Duration position}) = _$PlayerStateImpl;

  factory _PlayerState.fromJson(Map<String, dynamic> json) =
      _$PlayerStateImpl.fromJson;

  @override
  Song get song;
  @override
  List<SongNote> get notes;
  @override
  bool get isAudioReady;
  @override
  int get currentNoteIndex;
  @override
  bool get isPlaying;
  @override
  double get speed;
  @override
  Duration get position;

  /// Create a copy of PlayerState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PlayerStateImplCopyWith<_$PlayerStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
