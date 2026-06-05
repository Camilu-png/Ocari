import 'package:freezed_annotation/freezed_annotation.dart';

@JsonEnum()
enum Difficulty {
  @JsonValue('easy')
  easy,
  @JsonValue('medium')
  medium,
  @JsonValue('hard')
  hard;
}

