import 'package:flutter/material.dart';
import 'package:notes/feature_computer/screens/computer_settings_screen.dart';

Future<dynamic> settingsDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        content: ComputerSettingsScreen(),
      );
    },
  );
}
