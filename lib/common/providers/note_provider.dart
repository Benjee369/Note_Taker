import 'dart:developer';
import 'package:flutter/cupertino.dart';
import '../database/note_database.dart';
import '../database/open_note_database.dart';
import '../models/note_model.dart';

class NoteProvider with ChangeNotifier {
  final NoteDatabase noteDatabase;
  final OpenNoteDatabase openNoteDatabase;

  NoteProvider(
    this.noteDatabase,
    this.openNoteDatabase,
  ) {
    getNotes();
  }

  List<NoteModel> _notes = [];
  bool _isGettingNotes = false;
  NoteModel? _noteModel;

  List<NoteModel> get notes => _notes;
  bool get isGettingNotes => _isGettingNotes;
  NoteModel? get noteModel => _noteModel;

  void clearNotes() {
    _notes = [];
    notifyListeners();
  }

  void setOpenNote(String uuid) {
    getSingleNote(uuid);
    openNoteDatabase.setOpenNote(uuid);
  }

  Future<bool> checkOpenNote() async {
    final noteUuid = await openNoteDatabase.getOpenNote();
    if (noteUuid != null) {
      getSingleNote(noteUuid);
      return true;
    } else {
      return false;
    }
  }

  Future<void> clearOpenNote() async {
    await openNoteDatabase.clearOpenNote();
    _noteModel = null;
    notifyListeners();
  }

  Future<void> saveNote(NoteModel note) async {
    final index = _notes.indexWhere((n) => n.uuid == note.uuid);
    if (index == -1) {
      _notes.add(note);
    } else {
      _notes[index] = note;
    }
    notifyListeners();

    await noteDatabase.saveNote(note);
    setOpenNote(note.uuid);
    // getNotes();
  }

  void getSingleNote(String uuid) {
    final index = _notes.indexWhere((n) => n.uuid == uuid);
    if (index == -1) {
      _noteModel = null;
    } else {
      _noteModel = _notes[index];
    }
    // final note = _notes.firstWhere((n) => n.uuid == uuid);
    // _noteModel = note;
    notifyListeners();
  }

  Future<void> getNotes() async {
    log('getting notes...', name: 'NoteProvider');
    _isGettingNotes = _notes.isEmpty;
    notifyListeners();

    final dbNotes = await noteDatabase.getNotes();
    _notes = dbNotes;
    // notifyListeners();

    _isGettingNotes = false;
    notifyListeners();
  }

  Future<void> setPinned(NoteModel note, bool pinned) async {
    final updated = note.copyWith(isPinned: pinned);
    final index = _notes.indexWhere((n) => n.uuid == updated.uuid);
    if (index != -1) {
      _notes[index] = updated;
    }
    notifyListeners();
    await noteDatabase.saveNote(updated);
  }

  Future bulkDeleteNotes(Set<String> uuids) async {
    // _notes.removeWhere((note) => uuids.contains(note.uuid));
    // notifyListeners();

    for (String uuid in uuids) {
      deleteNote(
        uuid,
        shouldRefresh: false,
      );
    }
  }

  Future deleteNote(
    String uuid, {
    bool shouldRefresh = true,
  }) async {
    _notes.removeWhere((n) => n.uuid == uuid);
    notifyListeners();
    noteDatabase.deleteNote(uuid);
    if (_noteModel?.uuid == uuid) {
      await clearOpenNote();
    }
    if (shouldRefresh) {
      getNotes();
    }
  }
}
