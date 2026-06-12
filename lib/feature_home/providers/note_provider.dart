import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:notes/feature_home/data/local/note_database.dart';

import '../models/note_model.dart';

class NoteProvider with ChangeNotifier {
  final NoteDatabase noteDatabase;

  NoteProvider(this.noteDatabase);

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

  Future<void> saveNote(NoteModel note) async {
    await NoteDatabase().saveNote(note);
    getNotes();
  }

  Future<void> getSingleNote(String uuid) async {
    _noteModel = await NoteDatabase().getSingleNote(uuid);
    notifyListeners();
  }

  Future<void> getNotes() async {
    log('getting notes...', name: 'NoteProvider');
    _isGettingNotes = _notes.isEmpty;
    notifyListeners();

    final dbNotes = await NoteDatabase().getNotes();
    _notes = dbNotes;
    notifyListeners();

    _isGettingNotes = false;
    notifyListeners();
  }

  Future pinNote(NoteModel note) async {
    final updatedNote = note.copyWith(pinned: true);
    await NoteDatabase().saveNote(updatedNote);
    getNotes();
  }

  Future unpinNote(NoteModel note) async {
    final updatedNote = note.copyWith(pinned: false);
    await NoteDatabase().saveNote(updatedNote);
    getNotes();
  }

  Future deleteNote(String uuid) async {
    await NoteDatabase().deleteNote(uuid);
    getNotes();
  }
}
