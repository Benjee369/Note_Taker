import 'package:hive/hive.dart';

import '../models/system_settings_model.dart';

class SystemSettingsDatabase {
  static Box? _systemSettingsBox;

  Future<Box> _getBox() async {
    if (_systemSettingsBox != null && _systemSettingsBox!.isOpen) {
      return _systemSettingsBox!;
    }
    _systemSettingsBox = await Hive.openBox('systemSettings');
    return _systemSettingsBox!;
  }

  Future<SystemSettingsModel?> getSystemSettings() async {
    final box = await _getBox();
    final data = box.get('settings');
    if(data != null){
      final settings = SystemSettingsModel.fromJson(
        Map<String, dynamic>.from(data),
      );
    return settings;
    }
    return null;
  }

  Future setSystemSettings(
    SystemSettingsModel settings,
  ) async {
    final box = await _getBox();
    box.put(
      'settings',
      settings.toJson(),
    );
  }

  Future clearSettings() async {
    final box = await _getBox();
    box.clear();
  }
}
