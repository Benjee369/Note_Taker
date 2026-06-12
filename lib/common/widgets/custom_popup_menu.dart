import 'package:flutter/material.dart';
import 'package:notes/common/widgets/text_widget.dart';
import '../../constants/app_sizes.dart';

class CustomPopupMenu {
  static Future<void> show({
    required BuildContext context,
    required Offset position,
    required List<PopupMenuItemData> items,
    required Function(int) onSelected,
  }) async {
    final selected = await showMenu<int>(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy,
        position.dx,
        position.dy,
      ),
      // color: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      items: items.map((item) {
        return PopupMenuItem<int>(
          value: item.value,
          child: Row(
            children: [
              Icon(
                item.icon,
                size: 20,
              ),
              gapW8,
              TextWidget(text:item.label),
            ],
          ),
        );
      }).toList(),
    );

    if (selected != null) {
      onSelected(selected);
    }
  }
}

class PopupMenuItemData {
  final int value;
  final IconData icon;
  final String label;

  PopupMenuItemData({
    required this.value,
    required this.icon,
    required this.label,
  });
}
