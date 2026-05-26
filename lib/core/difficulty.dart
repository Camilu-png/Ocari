enum Difficulty {
  easy,
  medium,
  hard;

  String get label => switch (this) {
        Difficulty.easy => 'Easy',
        Difficulty.medium => 'Medium',
        Difficulty.hard => 'Hard',
      };
}
