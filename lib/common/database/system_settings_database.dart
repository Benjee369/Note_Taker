import 'dart:developer';

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

    if (data == null) return null;

    final json = Map<String, dynamic>.from(data);

    // FIX nested Hive map issue
    if (json['noteFontSettings'] != null) {
      json['noteFontSettings'] =
      Map<String, dynamic>.from(json['noteFontSettings']);
    }

    final settings = SystemSettingsModel.fromJson(json);

    log(
      'read these settings from the db ${settings.toJson()}',
      name: 'SystemSettingsDB',
    );

    return settings;
  }

  Future setSystemSettings(
    SystemSettingsModel settings,
  ) async {
    final box = await _getBox();
    box.put(
      'settings',
      settings.toJson(),
    );
    log(
      'wrote these settings to the db ${settings.toJson()}',
      name: 'SystemSettingsDB',
    );
  }

  Future clearSettings() async {
    final box = await _getBox();
    box.clear();
  }
}
