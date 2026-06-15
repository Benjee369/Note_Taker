import 'package:hive/hive.dart';

class ThemeDatabase {
  static Box? _themeBox;

  Future<Box> getBox() async {
    if (_themeBox != null && _themeBox!.isOpen) return _themeBox!;
    _themeBox = await Hive.openBox('themeBox');
    return _themeBox!;
  }

  Future<bool> getTheme() async {
    final box = await getBox();
    final view = box.get('theme');
    return view ?? true;
  }

  Future setTheme(bool view) async {
    final box = await getBox();
    box.put('theme', view);
  }
}