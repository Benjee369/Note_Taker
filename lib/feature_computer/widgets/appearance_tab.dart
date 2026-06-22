import 'package:dropdown_button2/dropdown_button2.dart';
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
  List<String> colors = [
    "green",
    "blue",
    "red",
    "purple",
  ];

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
              TextWidget(
                text: Strings.darkMode,
                align: TextAlign.center,
              ),
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
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Row(
            children: [
              Icon(
                Icons.color_lens_rounded,
              ),
              gapW4,
              TextWidget(
                text: 'Change theme color',
                align: TextAlign.center,
              ),
              Spacer(),
              DropdownButtonHideUnderline(
                child: DropdownButton2(
                  isExpanded: true,
                  hint: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextWidget(
                        text: systemSettings.systemSettingsModel.themeColorName,
                        textColor: systemSettings
                            .getColor(
                              systemSettings.systemSettingsModel.themeColorName,
                            )
                            .withOpacity(0.9),
                      ),
                      SizedBox(
                        width: 10,
                        height: 10,
                        child: ColoredBox(
                          color: systemSettings.getColor(
                            systemSettings.systemSettingsModel.themeColorName,
                          ),
                        ),
                      )
                    ],
                  ),
                  items: colors
                      .map(
                        (c) => DropdownItem(
                          value: c,
                          height: 30,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextWidget(
                                text: c,
                                textColor:
                                    systemSettings.getColor(c).withOpacity(0.9),
                              ),
                              SizedBox(
                                width: 10,
                                height: 10,
                                child: ColoredBox(
                                  color: systemSettings.getColor(c),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (val) => {
                    systemSettings.changeThemeColor(val!)
                  },
                  buttonStyleData: const ButtonStyleData(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    height: 30,
                    width: 140,
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
