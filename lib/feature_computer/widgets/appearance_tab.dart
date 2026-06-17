import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/providers/system_settings_provider.dart';
import '../../common/widgets/text_widget.dart';
import '../../constants/app_sizes.dart';
import '../../constants/strings.dart';

class AppearanceTab extends StatefulWidget {
  const AppearanceTab({super.key});

  @override
  State<AppearanceTab> createState() => _AppearanceTabState();
}

class _AppearanceTabState extends State<AppearanceTab> {
  @override
  Widget build(BuildContext context) {
    final systemSettings = context.watch<SystemSettingsProvider>();

    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Row(
            children: [
              AnimatedSwitcher(
                duration: Duration(milliseconds: 50),
                child: Icon(
                  systemSettings.systemSettingsModel.theme
                      ? Icons.wb_sunny_rounded
                      : Icons.mode_night_rounded,
                ),
              ),
              gapW4,
              TextWidget(text: Strings.darkMode, align: TextAlign.center,),
              Spacer(),
              Switch(
                value: !systemSettings.systemSettingsModel.theme,
                onChanged: (_) {
                  systemSettings.toggleTheme();
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
