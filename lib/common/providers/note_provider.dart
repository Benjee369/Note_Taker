import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:notes/common/models/folder_model.dart';
import '../database/folder_database.dart';
import '../database/note_database.dart';
import '../database/open_note_database.dart';
import '../models/note_model.dart';

class NoteProvider with ChangeNotifier {
  final NoteDatabase noteDatabase;
  final OpenNoteDatabase openNoteDatabase;
  final FolderDatabase folderDatabase;

  NoteProvider(
    this.noteDatabase,
    this.openNoteDatabase,
    this.folderDatabase,
  ) {
    getNotes();
  }

  List<NoteModel> _notes = [];
  bool _isGettingNotes = false;
  NoteModel? _noteModel;

  List<NoteModel> get notes => _notes;
  bool get isGettingNotes => _isGettingNotes;
  NoteModel? get noteModel => _noteModel;

  List<FolderModel> _folders = [];
  List<FolderModel> get folders => _folders;

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
    final index = _notes.indexWhere(
      (n) => n.uuid == note.uuid,
    );
    if (index == -1) {
      _notes.add(note);
    } else {
      _notes[index] = note;
    }
    notifyListeners();

    await noteDatabase.saveNote(note);
    setOpenNote(note.uuid);
  }

  void getSingleNote(String uuid) {
    final index = _notes.indexWhere(
      (n) => n.uuid == uuid,
    );
    if (index == -1) {
      _noteModel = null;
    } else {
      _noteModel = _notes[index];
    }
    notifyListeners();
  }

  Future<void> getNotes() async {
    log(
      'getting notes...',
      name: 'NoteProvider',
    );

    _notes = await noteDatabase.getNotes();
    _folders = await folderDatabase.getFolders();
    notifyListeners();
  }

  Future<void> setPinned(
    NoteModel note,
    bool pinned,
  ) async {
    final updated = note.copyWith(
      isPinned: pinned,
    );
    final index = _notes.indexWhere(
      (n) => n.uuid == updated.uuid,
    );
    if (index != -1) {
      _notes[index] = updated;
    }
    notifyListeners();
    await noteDatabase.saveNote(updated);
  }

  Future bulkDeleteNotes(Set<String> uuids) async {
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
    _notes.removeWhere(
      (n) => n.uuid == uuid,
    );
    notifyListeners();
    noteDatabase.deleteNote(uuid);
    if (_noteModel?.uuid == uuid) {
      clearOpenNote();
    }
    if (shouldRefresh) {
      getNotes();
    }
  }

  Future getFolders() async {
    final folders = await folderDatabase.getFolders();
    _folders = folders;
    notifyListeners();
  }

  Future<void> createFolder(
    FolderModel folder,
  ) async {
    log(
      'creating folder ${folder.toJson()}...',
      name: 'FolderProvider',
    );
    await folderDatabase.saveFolder(folder);
    await getFolders();
    notifyListeners();
  }

  Future<void> addToFolder(
    NoteModel note,
    String folderUuid,
  ) async {
    final updatedNote = note.copyWith(
      folderUuid: folderUuid,
    );
    await saveNote(updatedNote);
    notifyListeners();
  }

  Future deleteFolder(String folderUuid) async {
    _folders.removeWhere((f) => f.uuid == folderUuid);
    _notes.removeWhere((n) => n.folderUuid == folderUuid);
    notifyListeners();
  }

  List<Universal> processNotesAndFolders() {
    List<Universal> processed = [];
    for (final folder in _folders) {
      processed.add(Folder(folder));

      processed.addAll(
        _notes.where((n) => n.folderUuid == folder.uuid).map(
              (n) => ActualNote(n),
            ),
      );
    }

    processed.addAll(
      _notes.where((n) => n.folderUuid == null).map(
            (n) => ActualNote(n),
          ),
    );
    return processed;
  }
}

abstract class Universal {}

class Folder extends Universal {
  final FolderModel folderModel;
  Folder(this.folderModel);
}

class ActualNote extends Universal {
  final NoteModel noteModel;
  ActualNote(this.noteModel);
}
