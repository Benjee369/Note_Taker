import 'package:flutter/material.dart';
import 'package:notes/common/database/system_settings_database.dart';
import 'package:notes/common/providers/system_settings_provider.dart';
import 'package:notes/feature_auth/splash_screen.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SystemSettingsDatabase>().getSystemSettings();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SystemSettingsProvider>(
      builder: (context, systemSettings, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            brightness: Brightness.light,
            scaffoldBackgroundColor: AppColors.white,
            colorScheme: ColorScheme.fromSeed(
              seedColor: AppColors.primaryColor,
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
              seedColor: AppColors.primaryColor,
              brightness: Brightness.dark,
            ),
            primaryColor: AppColors.white,
            textTheme: const TextTheme(
              bodyLarge: TextStyle(color: AppColors.white),
              bodyMedium: TextStyle(color: AppColors.white),
              titleLarge: TextStyle(color: AppColors.white),
            ),
          ),
          themeMode: systemSettings.systemSettingsModel.theme
              ? ThemeMode.light
              : ThemeMode.dark,
          home: SplashScreen(),
        );
      },
    );
  }
}
