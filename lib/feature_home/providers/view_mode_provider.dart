import 'package:flutter/material.dart';
import 'package:notes/feature_home/data/local/view_mode_database.dart';

class ViewModeProvider with ChangeNotifier {
  final ViewModeDatabase viewModeDatabase;
  ViewModeProvider(this.viewModeDatabase);

  bool _viewMode = false;
  bool get viewMode => _viewMode;

  void toggleViewMode() async {
    _viewMode = !viewMode;
    await viewModeDatabase.setViewMode(_viewMode);
    notifyListeners();
  }

  Future<void> getViewMode() async {
    final view = await viewModeDatabase.getViewMode();
    _viewMode = view;
    notifyListeners();
  }
}
