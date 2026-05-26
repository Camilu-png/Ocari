import 'package:ocari/core/difficulty.dart';

class Song {
  final String id;
  final String title;
  final Difficulty difficulty;
  final int durationSeconds;
  final String? artist;
  final bool isLocked;

  const Song({
    required this.id,
    required this.title,
    this.difficulty = Difficulty.easy,
    this.durationSeconds = 0,
    this.artist,
    this.isLocked = false,
  });
}
