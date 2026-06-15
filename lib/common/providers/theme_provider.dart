import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:notes/common/databases/theme_database.dart';

class ThemeProvider with ChangeNotifier {
  final ThemeDatabase themeDatabase;
  ThemeProvider(this.themeDatabase);

  ThemeMode themeMode = ThemeMode.light;

  void toggleTheme() async {
    themeMode = themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    log('toggled theme to $themeMode');
    await themeDatabase.setTheme(themeMode != ThemeMode.dark);
    notifyListeners();
  }

  Future<void> getViewMode() async {
    final theme = await themeDatabase.getTheme();
    themeMode = theme ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}
