import 'package:flutter/material.dart';
import 'package:notes/common/database/folder_database.dart';
import 'package:notes/common/database/system_settings_database.dart';
import 'package:notes/common/providers/system_settings_provider.dart';
import 'package:notes/core/app.dart';
import 'package:notes/feature_computer/providers/settings_tab_index_provider.dart';
import 'package:provider/provider.dart';
import '../common/database/note_database.dart';
import '../common/database/open_note_database.dart';
import '../common/providers/note_provider.dart';

class ProviderLayer extends StatelessWidget {
  const ProviderLayer({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => NoteDatabase()),
        Provider(create: (_) => OpenNoteDatabase()),
        Provider(create: (_) => SystemSettingsDatabase()),
        Provider(create: (_) => FolderDatabase()),
        ChangeNotifierProvider(
          create: (context) => SettingsTabIndexProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => SystemSettingsProvider(
            context.read<SystemSettingsDatabase>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => NoteProvider(
            context.read<NoteDatabase>(),
            context.read<OpenNoteDatabase>(),
            context.read<FolderDatabase>(),
          ),
        ),
      ],
      child: App(),
    );
  }
}
