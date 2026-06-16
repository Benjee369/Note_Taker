import 'package:flutter/material.dart';
import 'package:notes/common/databases/theme_database.dart';
import 'package:notes/core/app.dart';
import 'package:provider/provider.dart';
import '../common/providers/theme_provider.dart';
import '../feature_mobile/data/local/note_database.dart';
import '../feature_mobile/data/local/open_note_database.dart';
import '../feature_mobile/data/local/view_mode_database.dart';
import '../feature_mobile/providers/note_provider.dart';
import '../feature_mobile/providers/view_mode_provider.dart';

class ProviderLayer extends StatelessWidget {
  const ProviderLayer({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => NoteDatabase()),
        Provider(create: (_) => ViewModeDatabase()),
        Provider(create: (_) => ThemeDatabase()),
        Provider(create: (_) => OpenNoteDatabase()),
        ChangeNotifierProvider(
          create: (context) => NoteProvider(
            context.read<NoteDatabase>(),
            context.read<OpenNoteDatabase>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => ThemeProvider(
            context.read<ThemeDatabase>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => ViewModeProvider(
            context.read<ViewModeDatabase>(),
          ),
        ),
      ],
      child: App(),
    );
  }
}
