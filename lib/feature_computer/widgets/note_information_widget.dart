import 'package:flutter/material.dart';
import '../../common/widgets/text_widget.dart';

class NoteInformationWidget extends StatelessWidget {
  final String title;
  final String value;

  const NoteInformationWidget({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      minTileHeight: 10,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextWidget(
            text: title,
            fontWeight: FontWeight.bold,
            size: 14,
          ),
          TextWidget(
            text: value,
            size: 14,
          ),
        ],
      ),
    );
  }
}
