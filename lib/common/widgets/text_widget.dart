import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  final String text;
  final double? size;
  final FontWeight? fontWeight;
  final Color? textColor;
  final TextOverflow? overFlow;
  final int? maxLines;
  final TextAlign? align;

  const TextWidget({
    super.key,
    required this.text,
    this.size,
    this.fontWeight,
    this.textColor,
    this.overFlow,
    this.maxLines, this.align,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: align,
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
