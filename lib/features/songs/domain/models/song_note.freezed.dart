// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'song_note.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SongNote _$SongNoteFromJson(Map<String, dynamic> json) {
  return _SongNote.fromJson(json);
}

/// @nodoc
mixin _$SongNote {
  String get note => throw _privateConstructorUsedError;
  List<int> get top => throw _privateConstructorUsedError;
  List<int> get bot => throw _privateConstructorUsedError;
  List<int> get sub => throw _privateConstructorUsedError;
  List<int> get middle => throw _privateConstructorUsedError;
  @JsonKey(name: 'timestamp_ms')
  int get timestampMs => throw _privateConstructorUsedError;
  @JsonKey(name: 'duration_ms')
  int get durationMs => throw _privateConstructorUsedError;
  @JsonKey(name: 'note_value')
  String get noteValue => throw _privateConstructorUsedError;

  /// Serializes this SongNote to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SongNote
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SongNoteCopyWith<SongNote> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SongNoteCopyWith<$Res> {
  factory $SongNoteCopyWith(SongNote value, $Res Function(SongNote) then) =
      _$SongNoteCopyWithImpl<$Res, SongNote>;
  @useResult
  $Res call(
      {String note,
      List<int> top,
      List<int> bot,
      List<int> sub,
      List<int> middle,
      @JsonKey(name: 'timestamp_ms') int timestampMs,
      @JsonKey(name: 'duration_ms') int durationMs,
      @JsonKey(name: 'note_value') String noteValue});
}

/// @nodoc
class _$SongNoteCopyWithImpl<$Res, $Val extends SongNote>
    implements $SongNoteCopyWith<$Res> {
  _$SongNoteCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SongNote
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? note = null,
    Object? top = null,
    Object? bot = null,
    Object? sub = null,
    Object? middle = null,
    Object? timestampMs = null,
    Object? durationMs = null,
    Object? noteValue = null,
  }) {
    return _then(_value.copyWith(
      note: null == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String,
      top: null == top
          ? _value.top
          : top // ignore: cast_nullable_to_non_nullable
              as List<int>,
      bot: null == bot
          ? _value.bot
          : bot // ignore: cast_nullable_to_non_nullable
              as List<int>,
      sub: null == sub
          ? _value.sub
          : sub // ignore: cast_nullable_to_non_nullable
              as List<int>,
      middle: null == middle
          ? _value.middle
          : middle // ignore: cast_nullable_to_non_nullable
              as List<int>,
      timestampMs: null == timestampMs
          ? _value.timestampMs
          : timestampMs // ignore: cast_nullable_to_non_nullable
              as int,
      durationMs: null == durationMs
          ? _value.durationMs
          : durationMs // ignore: cast_nullable_to_non_nullable
              as int,
      noteValue: null == noteValue
          ? _value.noteValue
          : noteValue // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SongNoteImplCopyWith<$Res>
    implements $SongNoteCopyWith<$Res> {
  factory _$$SongNoteImplCopyWith(
          _$SongNoteImpl value, $Res Function(_$SongNoteImpl) then) =
      __$$SongNoteImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String note,
      List<int> top,
      List<int> bot,
      List<int> sub,
      List<int> middle,
      @JsonKey(name: 'timestamp_ms') int timestampMs,
      @JsonKey(name: 'duration_ms') int durationMs,
      @JsonKey(name: 'note_value') String noteValue});
}

/// @nodoc
class __$$SongNoteImplCopyWithImpl<$Res>
    extends _$SongNoteCopyWithImpl<$Res, _$SongNoteImpl>
    implements _$$SongNoteImplCopyWith<$Res> {
  __$$SongNoteImplCopyWithImpl(
      _$SongNoteImpl _value, $Res Function(_$SongNoteImpl) _then)
      : super(_value, _then);

  /// Create a copy of SongNote
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? note = null,
    Object? top = null,
    Object? bot = null,
    Object? sub = null,
    Object? middle = null,
    Object? timestampMs = null,
    Object? durationMs = null,
    Object? noteValue = null,
  }) {
    return _then(_$SongNoteImpl(
      note: null == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String,
      top: null == top
          ? _value._top
          : top // ignore: cast_nullable_to_non_nullable
              as List<int>,
      bot: null == bot
          ? _value._bot
          : bot // ignore: cast_nullable_to_non_nullable
              as List<int>,
      sub: null == sub
          ? _value._sub
          : sub // ignore: cast_nullable_to_non_nullable
              as List<int>,
      middle: null == middle
          ? _value._middle
          : middle // ignore: cast_nullable_to_non_nullable
              as List<int>,
      timestampMs: null == timestampMs
          ? _value.timestampMs
          : timestampMs // ignore: cast_nullable_to_non_nullable
              as int,
      durationMs: null == durationMs
          ? _value.durationMs
          : durationMs // ignore: cast_nullable_to_non_nullable
              as int,
      noteValue: null == noteValue
          ? _value.noteValue
          : noteValue // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SongNoteImpl implements _SongNote {
  const _$SongNoteImpl(
      {required this.note,
      required final List<int> top,
      required final List<int> bot,
      required final List<int> sub,
      required final List<int> middle,
      @JsonKey(name: 'timestamp_ms') required this.timestampMs,
      @JsonKey(name: 'duration_ms') required this.durationMs,
      @JsonKey(name: 'note_value') required this.noteValue})
      : _top = top,
        _bot = bot,
        _sub = sub,
        _middle = middle;

  factory _$SongNoteImpl.fromJson(Map<String, dynamic> json) =>
      _$$SongNoteImplFromJson(json);

  @override
  final String note;
  final List<int> _top;
  @override
  List<int> get top {
    if (_top is EqualUnmodifiableListView) return _top;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_top);
  }

  final List<int> _bot;
  @override
  List<int> get bot {
    if (_bot is EqualUnmodifiableListView) return _bot;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_bot);
  }

  final List<int> _sub;
  @override
  List<int> get sub {
    if (_sub is EqualUnmodifiableListView) return _sub;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_sub);
  }

  final List<int> _middle;
  @override
  List<int> get middle {
    if (_middle is EqualUnmodifiableListView) return _middle;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_middle);
  }

  @override
  @JsonKey(name: 'timestamp_ms')
  final int timestampMs;
  @override
  @JsonKey(name: 'duration_ms')
  final int durationMs;
  @override
  @JsonKey(name: 'note_value')
  final String noteValue;

  @override
  String toString() {
    return 'SongNote(note: $note, top: $top, bot: $bot, sub: $sub, middle: $middle, timestampMs: $timestampMs, durationMs: $durationMs, noteValue: $noteValue)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SongNoteImpl &&
            (identical(other.note, note) || other.note == note) &&
            const DeepCollectionEquality().equals(other._top, _top) &&
            const DeepCollectionEquality().equals(other._bot, _bot) &&
            const DeepCollectionEquality().equals(other._sub, _sub) &&
            const DeepCollectionEquality().equals(other._middle, _middle) &&
            (identical(other.timestampMs, timestampMs) ||
                other.timestampMs == timestampMs) &&
            (identical(other.durationMs, durationMs) ||
                other.durationMs == durationMs) &&
            (identical(other.noteValue, noteValue) ||
                other.noteValue == noteValue));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      note,
      const DeepCollectionEquality().hash(_top),
      const DeepCollectionEquality().hash(_bot),
      const DeepCollectionEquality().hash(_sub),
      const DeepCollectionEquality().hash(_middle),
      timestampMs,
      durationMs,
      noteValue);

  /// Create a copy of SongNote
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SongNoteImplCopyWith<_$SongNoteImpl> get copyWith =>
      __$$SongNoteImplCopyWithImpl<_$SongNoteImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SongNoteImplToJson(
      this,
    );
  }
}

abstract class _SongNote implements SongNote {
  const factory _SongNote(
          {required final String note,
          required final List<int> top,
          required final List<int> bot,
          required final List<int> sub,
          required final List<int> middle,
          @JsonKey(name: 'timestamp_ms') required final int timestampMs,
          @JsonKey(name: 'duration_ms') required final int durationMs,
          @JsonKey(name: 'note_value') required final String noteValue}) =
      _$SongNoteImpl;

  factory _SongNote.fromJson(Map<String, dynamic> json) =
      _$SongNoteImpl.fromJson;

  @override
  String get note;
  @override
  List<int> get top;
  @override
  List<int> get bot;
  @override
  List<int> get sub;
  @override
  List<int> get middle;
  @override
  @JsonKey(name: 'timestamp_ms')
  int get timestampMs;
  @override
  @JsonKey(name: 'duration_ms')
  int get durationMs;
  @override
  @JsonKey(name: 'note_value')
  String get noteValue;

  /// Create a copy of SongNote
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SongNoteImplCopyWith<_$SongNoteImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
