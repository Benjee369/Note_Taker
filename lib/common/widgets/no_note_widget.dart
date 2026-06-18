import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'text_widget.dart';
import '../../constants/app_sizes.dart';

class NoNoteWidget extends StatelessWidget {
  final String message;
  final String image;

  const NoNoteWidget({
    super.key, required this.message, required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            image,
            width: 150,
            height: 150,
          ),
          gapH12,
          TextWidget(
            text: message,
            fontWeight: FontWeight.bold,
            // size: 20,
          ),
        ],
      ),
    );
  }
}
