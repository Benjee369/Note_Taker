import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../common/widgets/text_widget.dart';
import '../../constants/app_images.dart';
import '../../constants/app_sizes.dart';
import '../../constants/strings.dart';

class NoNoteWidget extends StatelessWidget {
  const NoNoteWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            AppImages.noNotes,
            width: 200,
            height: 200,
          ),
          gapH12,
          TextWidget(
            text: Strings.addYourFirst,
            fontWeight: FontWeight.bold,
            size: 20,
          ),
        ],
      ),
    );
  }
}
