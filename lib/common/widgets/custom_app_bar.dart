import 'package:flutter/material.dart';
import 'package:notes/common/widgets/text_widget.dart';

enum AppBarButtonType {
  backButton,
  closeButton,
  none,
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final AppBarButtonType buttonType;
  final VoidCallback? onBackPress;
  final List<Widget>? actions;
  final bool? isCenter;

  const CustomAppBar({
    super.key,
    this.title,
    this.onBackPress,
    this.actions,
    this.isCenter = false,
    required this.buttonType,
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
                // color: AppColors.lightestGrey,
                borderRadius: BorderRadius.circular(200),
              ),
              child: Icon(
                Icons.close,
                size: 22,
              ),
            ),
          ),
        );
      case AppBarButtonType.none:
        return const SizedBox.shrink();
    }
  }

  @override
  Size get preferredSize => Size.fromHeight(60);
}
