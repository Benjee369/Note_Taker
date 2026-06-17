import 'package:flutter/material.dart';
import 'package:notes/common/widgets/text_widget.dart';

class ComputerSettingsScreen extends StatefulWidget {
  const ComputerSettingsScreen({super.key});

  @override
  State<ComputerSettingsScreen> createState() => _ComputerSettingsScreenState();
}

class _ComputerSettingsScreenState extends State<ComputerSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 200,
          child: Column(
            children: [
              TextWidget(
                text: 'Settings',
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: [],
          ),
        )
      ],
    );
  }
}
