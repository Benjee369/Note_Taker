import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:notes/feature_home/data/local/note_database.dart';

import '../data/local/open_note_database.dart';
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

  Future<void> setOpenNote(String uuid) async {
    await openNoteDatabase.setOpenNote(uuid);
  }

  Future<bool> checkOpenNote() async {
    final noteUuid = await openNoteDatabase.getOpenNote();
    if (noteUuid != null) {
      await getSingleNote(noteUuid);
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
    await noteDatabase.saveNote(note);
    await setOpenNote(note.uuid);
    getNotes();
  }

  Future<void> getSingleNote(String uuid) async {
    _noteModel = await noteDatabase.getSingleNote(uuid);
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

  Future pinNote(NoteModel note) async {
    final updatedNote = note.copyWith(pinned: true);
    await noteDatabase.saveNote(updatedNote);
    getNotes();
  }

  Future unpinNote(NoteModel note) async {
    final updatedNote = note.copyWith(pinned: false);
    await noteDatabase.saveNote(updatedNote);
    getNotes();
  }

  Future bulkDeleteNotes(Set<String> uuids) async {
    _notes.removeWhere((note) => uuids.contains(note.uuid));
    notifyListeners();

    for (String uuid in uuids) {
      deleteNote(uuid, shouldRefresh: false);
    }
  }

  Future deleteNote(
    String uuid, {
    bool shouldRefresh = true,
  }) async {
    await noteDatabase.deleteNote(uuid);
    await clearOpenNote();
    if (shouldRefresh) {
      getNotes();
    }
  }
}
