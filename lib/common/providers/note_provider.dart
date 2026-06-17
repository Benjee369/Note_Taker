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
  );

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
  }

  Future<void> saveNote(NoteModel note) async {
    _notes.add(note);
    notifyListeners();

    noteDatabase.saveNote(note);
    setOpenNote(note.uuid);
    getNotes();
  }

  void getSingleNote(String uuid) {
    final note = _notes.firstWhere((n) => n.uuid == uuid);
    _noteModel = note;
    notifyListeners();
  }

  Future<void> getNotes() async {
    log('getting notes...', name: 'NoteProvider');
    _isGettingNotes = _notes.isEmpty;
    notifyListeners();

    final dbNotes = await noteDatabase.getNotes();
    _notes = dbNotes;
    notifyListeners();

    _isGettingNotes = false;
    notifyListeners();
  }

  void pinNote(NoteModel note) {
    final updatedNote = note.copyWith(isPinned: true);

    final index = _notes.indexWhere(
      (n) => n.uuid == updatedNote.uuid,
    );
    if (index != -1) {
      _notes[index] = updatedNote;
    }
    notifyListeners();
    noteDatabase.saveNote(updatedNote);
    getNotes();
  }

  void unpinNote(NoteModel note) {
    final updatedNote = note.copyWith(isPinned: false);

    final index = _notes.indexWhere(
      (n) => n.uuid == updatedNote.uuid,
    );
    if (index != -1) {
      _notes[index] = updatedNote;
    }
    notifyListeners();
    noteDatabase.saveNote(updatedNote);
    getNotes();
  }

  Future bulkDeleteNotes(Set<String> uuids) async {
    _notes.removeWhere((note) => uuids.contains(note.uuid));
    notifyListeners();

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
    clearOpenNote();
    if (shouldRefresh) {
      getNotes();
    }
  }
}
