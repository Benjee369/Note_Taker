import 'dart:async';

import 'package:flutter/material.dart';
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
  late TextEditingController _noteController;
  final _uuid = Uuid().v4();
  Timer? _debouncer;

  Future saveNote() async {
    final isNew = widget.isNewNote == true;
    final now = DateTime.now();

    final note = NoteModel(
      uuid: isNew ? _uuid : widget.note.uuid,
      // title: title,
      content: _noteController.text,
      createdDate: isNew ? now : widget.note.createdDate,
      updatedDate: DateTime.now(),
      pinned: false
    );
    await context.read<NoteProvider>().saveNote(note);
  }

  void onTypingChange(String text) {
    if (_debouncer?.isActive ?? false) _debouncer?.cancel();
    _debouncer = Timer(const Duration(milliseconds: 1000), () {
      saveNote();
    });
  }

  @override
  void initState() {
    super.initState();
    _noteController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.isNewNote != true) {
        _noteController.text = widget.note.content;
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _noteController.dispose();
    _debouncer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    // final theme = Theme.of(context).colorScheme;

    return SafeArea(
      child: Hero(
        tag: 'note',
        child: Scaffold(
          appBar: CustomAppBar(
            title: 'Note',
            buttonType: AppBarButtonType.backButton,
            actions: [
              IconButton(
                onPressed: () async {
                  _noteController.text.isNotEmpty ? saveNote() : null;
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
                  onChanged: (text) => onTypingChange(text),
                  controller: _noteController,
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
      ),
    );
  }
}
