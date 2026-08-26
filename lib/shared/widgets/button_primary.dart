import 'package:flutter/material.dart';
import 'package:notes/shared/widgets/text_widget.dart';
import 'package:notes/shared/constants/app_sizes.dart';
import 'package:notes/shared/constants/app_colors.dart';

class ButtonPrimary extends StatelessWidget {
  final String text;
  final VoidCallback function;
  final Color? color;
  final double? width;
  final double? textSize;
  final bool? active;
  final bool isLoading;
  final double? verticalPadding;
  final double? horizontalPadding;
  final double? borderRadius;
  final bool? isOutlined;
  final Color? textColor;
  final Color? hoverColor;
  final IconData? icon;
  final Color? iconColor;

  const ButtonPrimary({
    super.key,
    required this.text,
    required this.function,
    this.color,
    this.textSize,
    this.active = true,
    this.width,
    this.isLoading = false,
    this.verticalPadding,
    this.horizontalPadding,
    this.borderRadius,
    this.isOutlined,
    this.textColor,
    this.hoverColor,
    this.icon,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? MediaQuery.of(context).size.width * 0.2,
      child: ElevatedButton(
        onPressed: () {
          if (active != true || isLoading) return;
          function();
        },
        style: ButtonStyle(
          elevation: WidgetStatePropertyAll(0),
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.hovered)) {
              return isOutlined != null && isOutlined!
                  ? AppColors.white
                  : hoverColor;
            }
            return active == true
                ? isLoading
                    ? AppColors.grey
                    : null
                : null;
          }),
          shape: WidgetStatePropertyAll<OutlinedBorder>(
            isOutlined != null && isOutlined!
                ? RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    side: BorderSide(
                      width: 0.6,
                    ),
                  )
                : RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    side: BorderSide.none,
                  ),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: verticalPadding ?? 15,
            horizontal: horizontalPadding ?? 20,
          ),
          child: isLoading
              ? SizedBox(
                  width: 24,
                  height: 24,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
                  ),
                )
              : icon != null
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextWidget(
                          text: text,
                          size: textSize ?? 14,
                          fontWeight: FontWeight.bold,
                        ),
                        gapW4,
                        Icon(
                          icon,
                          color: iconColor,
                          size: 22,
                        ),
                      ],
                    )
                  : TextWidget(
                      text: text,
                      size: textSize ?? 14,
                      fontWeight: FontWeight.bold,
                    ),
        ),
      ),
    );
  }
}
