import 'package:flutter/material.dart';
import 'package:notes/constants/app_colors.dart';
import '../../common/widgets/text_widget.dart';
import '../../constants/app_sizes.dart';

class SettingsTileWidget extends StatelessWidget {
  final String title;
  final IconData icon;
  final Function(String) onTap;
  final bool isSelected;

  const SettingsTileWidget({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Column(
      children: [
        ListTile(
          selected: isSelected,
          selectedTileColor: theme.primary,
          selectedColor:  theme.primary,
          onTap: () => onTap.call(title),
          contentPadding: EdgeInsets.zero,
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 22,
              ),
              gapW8,
              TextWidget(text: title)
            ],
          ),
        ),
        Divider(
          height: 1,
        )
      ],
    );
  }
}
