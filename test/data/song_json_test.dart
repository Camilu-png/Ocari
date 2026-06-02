import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Song JSON files', () {
    test('zeldas_lullaby.json se parsea sin errores', () {
      final file = File('assets/data/songs/zeldas_lullaby.json');
      expect(file.existsSync(), isTrue, reason: 'File must exist');

      final jsonStr = file.readAsStringSync();
      final data = json.decode(jsonStr);

      expect(data['bpm'], 120);
      expect(data['time_signature'], '4/4');
      expect(data['notes'], isA<List>());
      expect(data['notes'].length, greaterThan(0));

      for (final note in data['notes']) {
        expect(note['note'], isA<String>());
        expect(note['top'], isA<List>());
        expect(note['bot'], isA<List>());
        expect(note['sub'], isA<List>());
        expect(note['middle'], isA<List>());
        expect(note['timestamp_ms'], isA<int>());
        expect(note['duration_ms'], isA<int>());
        expect(
          note['note_value'],
          isIn([
            'whole',
            'half',
            'quarter',
            'eighth',
            'sixteenth',
            'dotted_half',
            'dotted_quarter',
            'dotted_eighth',
          ]),
        );
      }
    });

    test('fingerings.json se parsea sin errores', () {
      final file = File('assets/data/fingerings.json');
      expect(file.existsSync(), isTrue, reason: 'File must exist');

      final jsonStr = file.readAsStringSync();
      final data = json.decode(jsonStr);

      expect(data['instrument'], '12-hole ocarina');
      expect(data['tuning'], 'Bb');
      expect(data['notes'], isA<Map>());
      expect(data['notes'].length, greaterThan(0));
    });
  });
}
