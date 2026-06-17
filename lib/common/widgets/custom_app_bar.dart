import 'package:flutter/material.dart';
import 'package:notes/common/widgets/text_widget.dart';

enum AppBarButtonType {
  backButton,
  closeButton,
  menuButton,
  custom,
  none,
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final AppBarButtonType buttonType;
  final VoidCallback? onBackPress;
  final List<Widget>? actions;
  final bool? isCenter;
  final IconData? customIcon;

  const CustomAppBar({
    super.key,
    this.title,
    this.onBackPress,
    this.actions,
    this.isCenter = false,
    required this.buttonType,
    this.customIcon,
  });

  @override
  Widget build(BuildContext context) {
    // final isIOS = Platform.isIOS;

    return AppBar(
      title: TextWidget(
        text: title != null ? title! : '',
        fontWeight: FontWeight.bold,
        size: 20,
      ),
      centerTitle: isCenter ?? true,
      // backgroundColor: Colors.transparent,
      // surfaceTintColor: Colors.transparent,
      // foregroundColor: Colors.transparent,
      leading: _leadingButton(context),
      actions: actions,
    );
  }

  Widget? _leadingButton(BuildContext context) {
    switch (buttonType) {
      case AppBarButtonType.backButton:
        return IconButton(
          icon: Container(
            padding: const EdgeInsets.all(1),
            decoration: BoxDecoration(
              // color: AppColors.lightestGrey,
              borderRadius: BorderRadius.circular(200),
            ),
            child: Icon(
              Icons.chevron_left_rounded,
              size: 40,
            ),
          ),
          onPressed: () {
            onBackPress == null ? Navigator.pop(context) : onBackPress?.call();
          },
        );
      case AppBarButtonType.closeButton:
        return GestureDetector(
          onTap: () {
            onBackPress == null ? Navigator.pop(context) : onBackPress?.call();
          },
          child: Center(
            child: Container(
              height: 40,
              width: 40,
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(200),
              ),
              child: Icon(
                Icons.close,
                size: 22,
              ),
            ),
          ),
        );
      case AppBarButtonType.menuButton:
        return IconButton(
          onPressed: () => Scaffold.of(context).openDrawer(),
          icon: Icon(Icons.menu),
        );
      case AppBarButtonType.custom:
        return IconButton(
          onPressed: () {
            onBackPress?.call();
          },
          icon: Icon(
            customIcon,
          ),
        );
      case AppBarButtonType.none:
        return const SizedBox.shrink();
    }
  }

  @override
  Size get preferredSize => Size.fromHeight(60);
}
