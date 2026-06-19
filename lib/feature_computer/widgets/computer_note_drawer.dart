import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes/common/providers/note_provider.dart';
import 'package:provider/provider.dart';
import '../../common/widgets/text_widget.dart';
import 'note_information_widget.dart';

class ComputerNoteDrawer extends StatelessWidget {
  const ComputerNoteDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final note = context.read<NoteProvider>().noteModel;
    String formattedDate(DateTime? date) {
      return date == null
          ? ''
          : DateFormat('EEE, yyyy-MM-dd HH:mm').format(date);
    }

    return Drawer(
      child: ListView(
        children: [
          ListTile(
            title: Row(
              children: [
                TextWidget(
                  text: 'Note Information',
                  size: 18,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),
          ),
          NoteInformationWidget(
            title: 'Birth date:',
            value: formattedDate(note?.createdDate),
          ),
          NoteInformationWidget(
            title: 'Updated date:',
            value: formattedDate(note?.updatedDate),
          ),
          NoteInformationWidget(
            title: 'Characters:',
            value: note?.content.length.toString() ?? '',
          ),
        ],
      ),
    );
  }
}
