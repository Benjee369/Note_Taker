import 'package:flutter/cupertino.dart';
import 'package:notes/feature_home/data/local/note_database.dart';
import 'package:notes/feature_home/data/local/open_note_database.dart';

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
