import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  final String text;
  final double? size;
  final FontWeight? fontWeight;
  final Color? textColor;
  final TextOverflow? overFlow;
  final int? maxLines;

  const TextWidget({
    super.key,
    required this.text,
    this.size,
    this.fontWeight,
    this.textColor,
    this.overFlow,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLines,
      style: TextStyle(
        fontSize: size ?? 16,
        fontWeight: fontWeight,
        color: textColor,
        overflow: overFlow,
      ),
    );
  }
}
