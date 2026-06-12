import 'package:flutter/material.dart';

import 'package:ocari/core/theme/note_colors.dart';
import 'package:ocari/features/songs/domain/models/song_note.dart';

class NotesLegend extends StatelessWidget {
  final List<SongNote> notes;

  const NotesLegend({super.key, required this.notes});

  @override
  Widget build(BuildContext context) {
    final uniqueNotes = <String>{};
    final legendItems = <MapEntry<String, Color>>[];
    for (final note in notes) {
      if (uniqueNotes.add(note.note)) {
        legendItems.add(MapEntry(note.note, NoteColors.forNote(note.note)));
      }
    }

    return Wrap(
      spacing: 8,
      runSpacing: 4,
      alignment: WrapAlignment.center,
      children: legendItems
          .map((e) => Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: e.value,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    e.key,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withAlpha(120),
                    ),
                  ),
                ],
              ))
          .toList(),
    );
  }
}
