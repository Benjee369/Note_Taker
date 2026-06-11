import 'package:flutter/material.dart';
import 'package:notes/common/widgets/text_widget.dart';
import 'package:notes/feature_home/models/note_model.dart';
import 'package:notes/feature_home/providers/note_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../common/widgets/custom_app_bar.dart';

class NoteScreen extends StatefulWidget {
  final NoteModel note;
  final bool? isNewNote;

  const NoteScreen({super.key, required this.note, this.isNewNote = false});

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  late TextEditingController noteController;
  final uuid = Uuid().v4();

  Future saveNote() async {
    final isNew = widget.isNewNote == true;
    final now = DateTime.now();

    final note = NoteModel(
      uuid: isNew ? uuid : widget.note.uuid,
      // title: title,
      content: noteController.text,
      createdDate: isNew ? now : widget.note.createdDate,
      updatedDate: DateTime.now(),
    );
    await context.read<NoteProvider>().saveNote(note);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    noteController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.isNewNote != true) {
        noteController.text = widget.note.content;
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    noteController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'Note',
          buttonType: AppBarButtonType.backButton,
          actions: [
            IconButton(
              onPressed: () async {
                noteController.text.isNotEmpty ? saveNote() : null;
              },
              icon: Icon(
                Icons.check,
                size: 40,
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: TextField(
                controller: noteController,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 3.0,
                      horizontal: 10.0,
                    ),
                    border: InputBorder.none),
                maxLines: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
