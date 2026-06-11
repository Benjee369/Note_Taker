import 'package:flutter/material.dart';
import 'package:notes/feature_auth/splash_screen.dart';
import 'package:notes/feature_home/data/local/note_database.dart';
import 'package:notes/feature_home/providers/note_provider.dart';
import 'package:provider/provider.dart';

import '../common/providers/theme_provider.dart';
import '../constants/app_colors.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => NoteDatabase()),
        ChangeNotifierProvider(
          create: (context) => NoteProvider(context.read<NoteDatabase>()),
        ),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            theme: ThemeData(
              brightness: Brightness.light,
              scaffoldBackgroundColor: AppColors.white,
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.blue,
                brightness: Brightness.light,
              ),
              primaryColor: AppColors.black,
              textTheme: const TextTheme(
                bodyLarge: TextStyle(color: AppColors.black),
                bodyMedium: TextStyle(color: AppColors.black),
                titleLarge: TextStyle(color: AppColors.black),
              ),
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              scaffoldBackgroundColor: AppColors.black,
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.blue,
                brightness: Brightness.dark,
              ),
              primaryColor: AppColors.white,
              textTheme: const TextTheme(
                bodyLarge: TextStyle(color: AppColors.white),
                bodyMedium: TextStyle(color: AppColors.white),
                titleLarge: TextStyle(color: AppColors.white),
              ),
            ),

            themeMode: ThemeMode.system,
            home: SplashScreen(),
          );
        },
      ),
    );
  }
}

// Switch(
// value: context.watch<ThemeProvider>().themeMode == ThemeMode.dark,
// onChanged: (_) {
// context.read<ThemeProvider>().toggleTheme();
// },
// )
