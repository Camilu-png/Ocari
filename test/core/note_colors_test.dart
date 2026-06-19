import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ocari/core/theme/note_colors.dart';

void main() {
  group('NoteColors', () {
    test('forNote returns expected color for A4', () {
      expect(NoteColors.forNote('A4'), const Color(0xFF7F77DD));
    });

    test('forNote returns expected color for B4', () {
      expect(NoteColors.forNote('B4'), const Color(0xFF5B8ED6));
    });

    test('forNote returns expected color for C5', () {
      expect(NoteColors.forNote('C5'), const Color(0xFFE87FA3));
    });

    test('forNote returns expected color for D5', () {
      expect(NoteColors.forNote('D5'), const Color(0xFFE05555));
    });

    test('forNote returns expected color for E5', () {
      expect(NoteColors.forNote('E5'), const Color(0xFFD4B520));
    });

    test('forNote returns expected color for F5', () {
      expect(NoteColors.forNote('F5'), const Color(0xFF27AE60));
    });

    test('forNote returns expected color for G5', () {
      expect(NoteColors.forNote('G5'), const Color(0xFF3D8BD0));
    });

    test('forNote returns expected color for A5', () {
      expect(NoteColors.forNote('A5'), const Color(0xFF7F77DD));
    });

    test('forNote returns expected color for F6', () {
      expect(NoteColors.forNote('F6'), const Color(0xFF27AE60));
    });

    test('forNote returns fallback for unknown note', () {
      expect(NoteColors.forNote('X9'), const Color(0xFF888888));
    });

    test('forNote returns same color for enharmonic equivalents', () {
      expect(NoteColors.forNote('As4'), NoteColors.forNote('Bf4'));
      expect(NoteColors.forNote('Cs5'), NoteColors.forNote('Df5'));
      expect(NoteColors.forNote('Ds5'), NoteColors.forNote('Ef5'));
      expect(NoteColors.forNote('Fs5'), NoteColors.forNote('Gf5'));
      expect(NoteColors.forNote('Gs5'), NoteColors.forNote('Af5'));
      expect(NoteColors.forNote('As5'), NoteColors.forNote('Bf5'));
      expect(NoteColors.forNote('Cs6'), NoteColors.forNote('Df6'));
      expect(NoteColors.forNote('Ds6'), NoteColors.forNote('Ef6'));
    });

    test('forNote returns same color across octaves', () {
      expect(NoteColors.forNote('A4'), NoteColors.forNote('A5'));
      expect(NoteColors.forNote('B4'), NoteColors.forNote('B5'));
      expect(NoteColors.forNote('C5'), NoteColors.forNote('C6'));
      expect(NoteColors.forNote('D5'), NoteColors.forNote('D6'));
      expect(NoteColors.forNote('E5'), NoteColors.forNote('E6'));
      expect(NoteColors.forNote('F5'), NoteColors.forNote('F6'));
    });

    test('palette contains all 29 entries', () {
      expect(NoteColors.palette.length, 29);
    });

    test('all palette entries have distinct colors per pitch class', () {
      final colorsByPitchClass = <String, Color>{
        'A': const Color(0xFF7F77DD),
        'As': const Color(0xFF9060C0),
        'Bf': const Color(0xFF9060C0),
        'B': const Color(0xFF5B8ED6),
        'C': const Color(0xFFE87FA3),
        'Cs': const Color(0xFFE06080),
        'Df': const Color(0xFFE06080),
        'D': const Color(0xFFE05555),
        'Ds': const Color(0xFFE08040),
        'Ef': const Color(0xFFE08040),
        'E': const Color(0xFFD4B520),
        'F': const Color(0xFF27AE60),
        'Fs': const Color(0xFF2090A0),
        'Gf': const Color(0xFF2090A0),
        'G': const Color(0xFF3D8BD0),
        'Gs': const Color(0xFF8B60C0),
        'Af': const Color(0xFF8B60C0),
      };

      for (final entry in NoteColors.palette.entries) {
        final pitchClass = entry.key.replaceAll(RegExp(r'[0-9]'), '');
        expect(
          entry.value,
          colorsByPitchClass[pitchClass],
          reason: '${entry.key} should match pitch class $pitchClass color',
        );
      }
    });
  });
}
