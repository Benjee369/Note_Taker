import 'package:hive/hive.dart';

class ViewModeDatabase {
  static Box? _viewModeBox;

  Future<Box> getBox() async {
    if (_viewModeBox != null && _viewModeBox!.isOpen) return _viewModeBox!;
    _viewModeBox = await Hive.openBox('viewMode');
    return _viewModeBox!;
  }

  Future<bool> getViewMode() async {
    final box = await getBox();
    final view = box.get('view');
    return view ?? true;
  }

  Future setViewMode(bool view) async {
    final box = await getBox();
    box.put('view', view);
  }

  Future clearView() async {
    final box = await getBox();
    box.clear();
  }
}
