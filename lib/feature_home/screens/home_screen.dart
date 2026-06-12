import 'package:flutter/material.dart';
import 'package:notes/common/widgets/custom_popup_menu.dart';
import 'package:notes/common/widgets/dialogs.dart';
import 'package:notes/common/widgets/text_widget.dart';
import 'package:notes/feature_home/models/note_model.dart';
import 'package:notes/feature_home/providers/note_provider.dart';
import 'package:notes/feature_home/screens/note_screen.dart';
import 'package:notes/feature_home/widgets/note_widget.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../common/navigation/navigation.dart';
import '../../common/providers/platform_provider.dart';
import '../../common/widgets/custom_app_bar.dart';
import '../../constants/strings.dart';
import '../widgets/no_note_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final uuid = Uuid();

  void createNewNote() {
    final id = uuid.v4();
    final note = NoteModel(
      uuid: id,
      content: '',
      createdDate: DateTime.now(),
      updatedDate: DateTime.now(),
      pinned: false,
    );

    Navigation.navigateTo(
        context,
        NoteScreen(
          note: note,
          isNewNote: true,
        ));
  }

  void openNote(NoteModel note) {
    Navigation.navigateTo(
      context,
      NoteScreen(note: note),
    );
  }

  void onLongPress(
    NoteModel note, {
    LongPressStartDetails? details,
    TapDownDetails? tapDownDetails,
  }) {
    CustomPopupMenu.show(
      context: context,
      position: isMobile == true
          ? details!.globalPosition
          : tapDownDetails!.globalPosition,
      items: [
        PopupMenuItemData(
          value: 1,
          icon: Icons.push_pin_rounded,
          label: note.pinned ? Strings.unpin : Strings.pin,
        ),
        PopupMenuItemData(
          value: 2,
          icon: Icons.folder_copy_rounded,
          label: Strings.duplicate,
        ),
        PopupMenuItemData(
          value: 3,
          icon: Icons.delete_rounded,
          label: Strings.delete,
        ),
      ],
      onSelected: (value) {
        switch (value) {
          case 1:
            pin(note);
            break;
          case 2:
            duplicateNote(note);
            break;
          case 3:
            deleteNote(note.uuid);
            break;
        }
      },
    );
  }

  void deleteNote(String uuid) {
    Dialogs.dialogWithOptions(
      context,
      Strings.areYouSure,
      () async {
        await context.read<NoteProvider>().deleteNote(uuid);
        if (mounted) {
          Navigator.pop(context);
        }
      },
      () => Navigator.pop(context),
      Strings.ok,
      Strings.cancel,
    );
  }

  void pin(NoteModel note) {
    if (note.pinned) {
      context.read<NoteProvider>().unpinNote(note);
    } else {
      context.read<NoteProvider>().pinNote(note);
    }
  }

  void duplicateNote(NoteModel originalNote) async {
    final duplicateUuid = Uuid().v4();

    final duplicateNote = NoteModel(
      uuid: duplicateUuid,
      content: originalNote.content,
      createdDate: originalNote.createdDate,
      updatedDate: originalNote.updatedDate,
      pinned: originalNote.pinned,
    );

    await context.read<NoteProvider>().saveNote(duplicateNote);
  }

  List<NoteItem> processNotes(List<NoteModel> notes) {
    List<NoteItem> processedList = [];

    final pinnedNotes = notes.where((note) => note.pinned).toList();
    final unpinnedNotes = notes.where((note) => !note.pinned).toList();

    if (pinnedNotes.isNotEmpty) {
      processedList.add(NoteHeader('Pinned'));
      processedList.addAll(pinnedNotes.map((n) => NoteListItem(n)));
    }

    if (unpinnedNotes.isNotEmpty) {
      processedList.add(NoteHeader('All'));
      processedList.addAll(unpinnedNotes.map((n) => NoteListItem(n)));
    }
    return processedList;
  }

  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.sizeOf(context);
    final notes = context.watch<NoteProvider>().notes;
    final processedList = processNotes(notes);

    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () => createNewNote(),
          child: Icon(Icons.add),
        ),
        appBar: CustomAppBar(
          buttonType: AppBarButtonType.menuButton,
          title: Strings.notes,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            notes.isEmpty
                ? NoNoteWidget()
                : Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.all(10),
                      itemCount: processedList.length,
                      itemBuilder: (BuildContext context, int index) {
                        final note = processedList[index];

                        if (note is NoteHeader) {
                          return TextWidget(
                            text: note.title,
                            size: 20,
                            fontWeight: FontWeight.bold,
                          );
                        }

                        if (note is NoteListItem) {
                          return GestureDetector(
                            onLongPressStart: (details) => onLongPress(
                              details: details,
                              note.note,
                            ),
                            onSecondaryTapDown: (details) => onLongPress(
                              tapDownDetails: details,
                              note.note,
                            ),
                            onTap: () => openNote(note.note),
                            child: NoteWidget(
                              note: note.note,
                            ),
                          );
                        }

                        return SizedBox.shrink();
                      },
                    ),
                  ),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [ListTile()],
          ),
        ),
      ),
    );
  }
}

abstract class NoteItem {}

class NoteHeader extends NoteItem {
  final String title;
  NoteHeader(this.title);
}

class NoteListItem extends NoteItem {
  final NoteModel note;
  NoteListItem(this.note);
}
