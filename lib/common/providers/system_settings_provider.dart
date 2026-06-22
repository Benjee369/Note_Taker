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
    sideBarWidth: 400,
    themeColorName: 'orange',
    noteFontSettings: NoteFontSettings(
      fontSize: 16,
      isFontWeighted: false,
      fontHeight: 1.2,
    ),
  );
  SystemSettingsModel get systemSettingsModel => _systemSettingsModel;

  void toggleTheme() {
    final updatedSettings = _systemSettingsModel.copyWith(
      theme: !_systemSettingsModel.theme,
    );
    _systemSettingsModel = updatedSettings;
    systemSettingsDatabase.setSystemSettings(updatedSettings);
    notifyListeners();
  }

  void toggleViewMode() {
    final updatedSettings = _systemSettingsModel.copyWith(
      viewMode: !_systemSettingsModel.viewMode,
    );
    _systemSettingsModel = updatedSettings;
    systemSettingsDatabase.setSystemSettings(updatedSettings);
    notifyListeners();
  }

  void setSideBarWidth(
    double width, {
    bool shouldSave = true,
  }) {
    final updatedSettings = _systemSettingsModel.copyWith(
      sideBarWidth: width,
    );
    _systemSettingsModel = updatedSettings;
    if (shouldSave) {
      systemSettingsDatabase.setSystemSettings(updatedSettings);
    }
    notifyListeners();
  }

  Color getColor(String name) {
    switch (name) {
      case 'orange':
        return Color(0xFFF59E0B);
      case 'green':
        return Colors.green;
      case 'blue':
        return Colors.blue;
      case 'red':
        return Colors.red;
      case 'purple':
        return Colors.purple;
      default:
        return Colors.orange;
    }
  }

  void changeThemeColor(String colorName) {
    final updatedSettings = _systemSettingsModel.copyWith(
      themeColorName: colorName,
    );
    _systemSettingsModel = updatedSettings;
    systemSettingsDatabase.setSystemSettings(updatedSettings);
    notifyListeners();
  }

  void changeFontSize(double size) {
    final noteFontSettings = _systemSettingsModel.noteFontSettings;
    final updatedSettings = _systemSettingsModel.copyWith(
      noteFontSettings: noteFontSettings.copyWith(fontSize: size),
    );
    _systemSettingsModel = updatedSettings;
    systemSettingsDatabase.setSystemSettings(updatedSettings);
    notifyListeners();
  }

  void toggleFontWeight() {
    final noteFontSettings = _systemSettingsModel.noteFontSettings;
    final updatedSettings = _systemSettingsModel.copyWith(
      noteFontSettings: noteFontSettings.copyWith(
        isFontWeighted: !noteFontSettings.isFontWeighted,
      ),
    );
    _systemSettingsModel = updatedSettings;
    systemSettingsDatabase.setSystemSettings(updatedSettings);
    notifyListeners();
  }

  Future<void> getSystemSettings() async {
    final settings = await systemSettingsDatabase.getSystemSettings();
    if (settings != null) {
      _systemSettingsModel = settings;
    }
    notifyListeners();
  }
}
