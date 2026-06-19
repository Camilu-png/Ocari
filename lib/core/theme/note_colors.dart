import 'package:flutter/material.dart';

class NoteColors {
  NoteColors._();

  static const Map<String, Color> palette = {
    'A4': Color(0xFF7F77DD),
    'As4': Color(0xFF9060C0),
    'Bf4': Color(0xFF9060C0),
    'B4': Color(0xFF5B8ED6),
    'C5': Color(0xFFE87FA3),
    'Cs5': Color(0xFFE06080),
    'Df5': Color(0xFFE06080),
    'D5': Color(0xFFE05555),
    'Ds5': Color(0xFFE08040),
    'Ef5': Color(0xFFE08040),
    'E5': Color(0xFFD4B520),
    'F5': Color(0xFF27AE60),
    'Fs5': Color(0xFF2090A0),
    'Gf5': Color(0xFF2090A0),
    'G5': Color(0xFF3D8BD0),
    'Gs5': Color(0xFF8B60C0),
    'Af5': Color(0xFF8B60C0),
    'A5': Color(0xFF7F77DD),
    'As5': Color(0xFF9060C0),
    'Bf5': Color(0xFF9060C0),
    'B5': Color(0xFF5B8ED6),
    'C6': Color(0xFFE87FA3),
    'Cs6': Color(0xFFE06080),
    'Df6': Color(0xFFE06080),
    'D6': Color(0xFFE05555),
    'Ds6': Color(0xFFE08040),
    'Ef6': Color(0xFFE08040),
    'E6': Color(0xFFD4B520),
    'F6': Color(0xFF27AE60),
  };

  static Color forNote(String note) =>
      palette[note] ?? const Color(0xFF888888);
}
