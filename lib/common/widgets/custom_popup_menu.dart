import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class CustomPopupMenu extends StatelessWidget {
  final void Function(int value) onSelected;
  final List<PopupMenuItemData> items;
  final double yOffset;
  final Widget? child;

  const CustomPopupMenu(
      {super.key,
        required this.onSelected,
        required this.items,
        this.yOffset = 50,
        this.child});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      style: ButtonStyle(padding: WidgetStatePropertyAll(EdgeInsets.zero)),
      color: AppColors.white,
      offset: Offset(-10, yOffset),
      icon: Container(
        padding: EdgeInsets.all(5),
        color: Theme.of(context).colorScheme.primary,
        child: Icon(
          Icons.more_vert_outlined,
          color: Theme.of(context).colorScheme.secondary,
          size: 17,
        ),
      ),
      borderRadius: BorderRadius.circular(20),
      onSelected: onSelected,
      itemBuilder: (context) {
        return items
            .map(
              (item) => PopupMenuItem<int>(
            value: item.value,
            child: Text(item.label),
            // Row(
            //   children: [
            //     Icon(
            //       item.icon,
            //       size: 20,
            //       color: AppColors.primaryColour,
            //     ),
            //     gapW8,
            //     Text(item.label),
            //   ],
            // ),
          ),
        )
            .toList();
      },
      child: child,
    );
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