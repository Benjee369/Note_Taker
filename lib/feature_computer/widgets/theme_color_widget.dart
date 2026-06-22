import 'package:flutter/material.dart';
import 'package:notes/common/providers/system_settings_provider.dart';

import '../../common/widgets/text_widget.dart';

class ThemeColorWidget extends StatelessWidget {
  final String name;
  final SystemSettingsProvider systemSettings;
  const ThemeColorWidget({
    super.key,
    required this.name,
    required this.systemSettings,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextWidget(
          text: name,
          textColor: systemSettings.getColor(name).withValues(alpha: 0.9),
        ),
        SizedBox(
          width: 10,
          height: 10,
          child: ColoredBox(
            color: systemSettings.getColor(name),
          ),
        )
      ],
    );
  }
}
