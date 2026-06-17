import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notes/common/database/system_settings_database.dart';
import 'package:notes/common/models/system_settings_model.dart';

class SystemSettingsProvider with ChangeNotifier {
  final SystemSettingsDatabase systemSettingsDatabase;
  SystemSettingsProvider(this.systemSettingsDatabase) {
    getSystemSettings();
  }

  SystemSettingsModel _systemSettingsModel = SystemSettingsModel(
    theme: false,
    viewMode: false,
  );
  SystemSettingsModel get systemSettingsModel => _systemSettingsModel;

  void toggleTheme() async {
    final updatedSettings = _systemSettingsModel.copyWith(
      theme: !_systemSettingsModel.theme,
    );
    _systemSettingsModel = updatedSettings;
    systemSettingsDatabase.setSystemSettings(updatedSettings);
    notifyListeners();
  }

  void toggleViewMode() async {
    final updatedSettings = _systemSettingsModel.copyWith(
      viewMode: !_systemSettingsModel.viewMode,
    );
    _systemSettingsModel = updatedSettings;
    systemSettingsDatabase.setSystemSettings(updatedSettings);
    notifyListeners();
  }

  Future<void> getSystemSettings() async {
    final settings = await systemSettingsDatabase.getSystemSettings();
    _systemSettingsModel = settings;
    notifyListeners();
  }
}
