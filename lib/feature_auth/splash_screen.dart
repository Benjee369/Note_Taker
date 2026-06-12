import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:notes/common/widgets/text_widget.dart';
import 'package:notes/feature_home/screens/home_screen.dart';
import 'package:notes/feature_home/providers/note_provider.dart';
import 'package:provider/provider.dart';

import '../common/navigation/navigation.dart';
import '../constants/app_images.dart';
import '../constants/app_sizes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getNotes();
    });
  }

  Future getNotes() async {
    context.read<NoteProvider>().getNotes();
    Navigation.navigateAndReplace(context, HomeScreen());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                    SvgPicture.asset(
            AppImages.splashImage,
            height: 200,
            width: 200,
                    ),
                    gapH12,
                    TextWidget(text: 'Note Taker')
                  ]),
          )),
    );
  }
}
