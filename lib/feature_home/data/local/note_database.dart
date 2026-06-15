import 'dart:developer';

import 'package:hive/hive.dart';
import 'package:notes/feature_home/models/note_model.dart';

class NoteDatabase {
  static Box? _noteBox;
  static const String valueName = 'notes';

  Future<Box> getBox() async {
    if (_noteBox != null && _noteBox!.isOpen) return _noteBox!;
    _noteBox = await Hive.openBox('notesBox');
    return _noteBox!;
  }

  Future saveNote(NoteModel note) async {
    final box = await getBox();
    await box.put(note.uuid, note.toJson());
    log('saved noted with id ${note.uuid}...', name: 'NoteDatabase');
  }

  Future<List<NoteModel>> getNotes() async {
    log('getting notes...', name: 'NoteDatabase');
    final box = await getBox();

    final notes = box.values
        .map((note) => NoteModel.fromJson(Map<String, dynamic>.from(note)))
        .toList();
    log('got (${notes.length})list of notes $notes...');
    return notes;
  }

  Future<NoteModel?> getSingleNote(String uuid) async {
    final box = await getBox();
    final note = await box.get(uuid);
    if (note == null) return null;
    return NoteModel.fromJson(Map<String, dynamic>.from(note));
  }

  Future deleteNote(String uuid) async {
    final box = await getBox();
    await box.delete(uuid);
    log('deleted note $uuid...', name: 'NoteDatabase');
  }
}
