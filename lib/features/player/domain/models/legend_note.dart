import 'package:flutter/material.dart';
import 'package:ocari/features/songs/domain/models/song_note.dart';

class LegendNote {
  final String name;
  final Color color;
  final SongNote fingering;

  const LegendNote({
    required this.name,
    required this.color,
    required this.fingering,
  });
}
