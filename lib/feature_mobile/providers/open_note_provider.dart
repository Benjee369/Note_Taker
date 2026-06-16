import 'package:flutter/cupertino.dart';

import '../data/local/note_database.dart';
import '../data/local/open_note_database.dart';

class OpenNoteProvider with ChangeNotifier {
  final NoteDatabase noteDatabase;
  final OpenNoteDatabase openNoteDatabase;

  OpenNoteProvider(
    this.noteDatabase,
    this.openNoteDatabase,
  );

  Future checkOpenNote() async {
    final noteUuid = await openNoteDatabase.getOpenNote();
    if (noteUuid != null) {

    }
  }
}
