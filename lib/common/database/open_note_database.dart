import 'package:hive/hive.dart';

class OpenNoteDatabase {
  static Box? _openNoteBox;

  Future<Box> getBox() async {
    if (_openNoteBox != null && _openNoteBox!.isOpen) return _openNoteBox!;
    _openNoteBox = await Hive.openBox('openNoteBox');
    return _openNoteBox!;
  }

  Future<String?> getOpenNote() async {
    final box = await getBox();
    final uuid = await box.get('note');
    if (uuid == null) return null;
    return uuid;
  }

  Future setOpenNote(String uuid) async {
    final box = await getBox();
    await box.put('note', uuid);
  }

  Future clearOpenNote() async {
    final box = await getBox();
    await box.clear();
  }
}
