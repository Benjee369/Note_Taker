import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../common/providers/platform_provider.dart';
import '../../common/widgets/custom_app_bar.dart';
import '../../constants/strings.dart';
import '../../common/models/note_model.dart';
import '../../common/providers/note_provider.dart';

class NoteScreen extends StatefulWidget {
  final bool? isNewNote;
  final bool? isDrawerOpen;
  final VoidCallback? toggleDrawer;

  const NoteScreen({
    super.key,
    this.isNewNote = false,
    this.isDrawerOpen = true,
    this.toggleDrawer,
  });

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
    final noteProvider = context.read<NoteProvider>().noteModel;

    final note = NoteModel(
      uuid: isNew ? _uuid : noteProvider!.uuid,
      content: _noteController.text,
      createdDate: isNew ? now : noteProvider!.createdDate,
      updatedDate: now,
      isPinned: noteProvider?.isPinned ?? false,
    );
    await context.read<NoteProvider>().saveNote(note);
  }

  //basically, if I select a note and then I delete it, the selected note list is not cleared

  void onTypingChange(String text) {
    if (_debouncer?.isActive ?? false) _debouncer?.cancel();
    _debouncer = Timer(const Duration(milliseconds: 1000), () {
      saveNote();
    });
  }

  void closeNote() {
    context.read<NoteProvider>().clearOpenNote();
    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    log('init state ran again');
    _noteController = TextEditingController();
    final noteProvider = context.read<NoteProvider>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.isNewNote != true) {
        _noteController.text = noteProvider.noteModel!.content;
      }
    });

    noteProvider.addListener(_onNoteChanged);
  }

  void _onNoteChanged() {
    final content = context.read<NoteProvider>().noteModel?.content ?? '';

    if (_noteController.text != content) {
      _noteController.value = TextEditingValue(
        text: content,
        selection: TextSelection.collapsed(offset: content.length),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    _noteController.dispose();
    context.read<NoteProvider>().removeListener(_onNoteChanged);
    _debouncer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NoteProvider>(
      builder: (context, noteProvider, child) {
        return SafeArea(
          child: Scaffold(
            appBar: isMobile
                ? CustomAppBar(
                    title: Strings.note,
                    buttonType: AppBarButtonType.backButton,
                    onBackPress: () => closeNote(),
                  )
                : CustomAppBar(
                    buttonType: AppBarButtonType.custom,
                    title: Strings.note,
                    customIcon: widget.isDrawerOpen == true
                        ? Icons.chevron_left_rounded
                        : Icons.menu,
                    onBackPress:()=> widget.toggleDrawer?.call(),
                    actions: [
                      Builder(
                        builder: (context) {
                          return IconButton(
                            onPressed: () {
                              log('end drawer button clicked');
                              Scaffold.of(context).openEndDrawer();
                            },
                            icon: Icon(Icons.info),
                          );
                        },
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
                      border: InputBorder.none,
                    ),
                    maxLines: 1000,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
