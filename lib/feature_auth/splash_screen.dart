import 'package:flutter/material.dart';
import 'package:notes/feature_home/screens/home_screen.dart';
import 'package:notes/feature_home/providers/note_provider.dart';
import 'package:provider/provider.dart';

import '../common/navigation/navigation.dart';

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
    Navigation.navigateTo(context, HomeScreen());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(body: Column(children: [Text('Note Taker')])),
    );
  }
}
