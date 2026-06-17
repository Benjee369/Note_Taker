import 'package:flutter/material.dart';
import '../../common/widgets/text_widget.dart';
import '../../constants/app_sizes.dart';

class SettingsTileWidget extends StatelessWidget {
  final String title;
  final IconData icon;
  final Function(String) onTap;

  const SettingsTileWidget({
    super.key,
    required this.title,
    required this.icon, required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap:()=> onTap.call(title),
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
