import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:notes/common/providers/platform_provider.dart';
import 'package:notes/common/providers/system_settings_provider.dart';
import 'package:notes/common/widgets/custom_popup_menu.dart';
import 'package:notes/common/widgets/dialogs.dart';
import 'package:notes/feature_computer/screens/computer_home_screen.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../common/navigation/navigation.dart';
import '../../common/widgets/custom_app_bar.dart';
import '../../common/widgets/no_note_widget.dart';
import '../../constants/strings.dart';
import '../../common/models/note_model.dart';
import '../../common/providers/note_provider.dart';
import '../widgets/home_drawer.dart';
import '../../common/widgets/note_view.dart';
import 'note_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final uuid = Uuid();
  final Set<String> selectedNotes = {};
  bool gridView = true;

  void createNewNote() async {
    final id = uuid.v4();
    final note = NoteModel(
      uuid: id,
      content: '',
      createdDate: DateTime.now(),
      updatedDate: DateTime.now(),
      isPinned: false,
    );
    await context.read<NoteProvider>().saveNote(note);
    if (!mounted) return;
    Navigation.navigateTo(
      context,
      NoteScreen(),
    );
  }

  void openNote(NoteModel note)  {
    if (selectedNotes.isNotEmpty) {
      selectNote(note);
    } else {
       context.read<NoteProvider>().setOpenNote(note.uuid);
      if (!mounted) return;
      isMobile
          ? Navigation.navigateTo(
              context,
              NoteScreen(),
            )
          : null;
    }
  }

  void checkOpenNote() async {
    final noteProvider = context.read<NoteProvider>();
    final isOpen = await noteProvider.checkOpenNote();
    if (isOpen && isMobile) {
      openNote(noteProvider.noteModel!);
    }
  }

  void onLongPress(
    NoteModel note, {
    LongPressStartDetails? details,
    TapDownDetails? tapDownDetails,
  }) {
    final position = details?.globalPosition ?? tapDownDetails?.globalPosition;
    if (position == null) return;

    CustomPopupMenu.show(
      context: context,
      position: position,
      items: [
        PopupMenuItemData(
          value: 1,
          icon: Icons.push_pin_rounded,
          label: note.isPinned ? Strings.unpin : Strings.pin,
        ),
        PopupMenuItemData(
          value: 2,
          icon: Icons.check_box_rounded,
          label: Strings.select,
        ),
        PopupMenuItemData(
          value: 3,
          icon: Icons.folder_copy_rounded,
          label: Strings.duplicate,
        ),
        PopupMenuItemData(
          value: 4,
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
            selectNote(note);
            break;
          case 3:
            duplicateNote(note);
            break;
          case 4:
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
        context.read<NoteProvider>().deleteNote(
              uuid,
              shouldRefresh: false,
            );
        selectedNotes.clear();
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
    if (note.isPinned) {
      context.read<NoteProvider>().unpinNote(note);
    } else {
      context.read<NoteProvider>().pinNote(note);
    }
  }

  void duplicateNote(NoteModel originalNote) {
    final duplicateUuid = Uuid().v4();

    final duplicateNote = NoteModel(
      uuid: duplicateUuid,
      content: originalNote.content,
      createdDate: originalNote.createdDate,
      updatedDate: originalNote.updatedDate,
      isPinned: originalNote.isPinned,
    );

    context.read<NoteProvider>().saveNote(duplicateNote);
  }

  List<NoteItem> processNotes(List<NoteModel> notes) {
    List<NoteItem> processedList = [];

    final pinnedNotes = notes.where((note) => note.isPinned).toList();
    final unpinnedNotes = notes.where((note) => !note.isPinned).toList();

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

  void selectNote(NoteModel note) {
    if (selectedNotes.contains(note.uuid)) {
      setState(() {
        selectedNotes.remove(note.uuid);
      });
      log(
        'removed note ${note.uuid} to selected list...',
        name: 'SelectedNotes',
      );
    } else {
      setState(() {
        selectedNotes.add(note.uuid);
      });
      log(
        'added note ${note.uuid} to selected list...',
        name: 'SelectedNotes',
      );
    }
  }

  void bulkDeleteNotes() async {
    Dialogs.dialogWithOptions(
      context,
      Strings.areYouSureMany(selectedNotes.length),
      () async {
        context.read<NoteProvider>().bulkDeleteNotes(selectedNotes);
        selectedNotes.clear();
        if (mounted) {
          Navigator.pop(context);
        }
      },
      () => Navigator.pop(context),
      Strings.ok,
      Strings.cancel,
    );
  }

  void selectAndUnselectAll() {
    final notes = context.read<NoteProvider>().notes;
    if (selectedNotes.length == notes.length) {
      setState(() {
        selectedNotes.clear();
      });
    } else {
      setState(() {
        selectedNotes.addAll(notes.map((n) => n.uuid).toSet());
      });
    }
  }

  void toggleViewMode() {
    setState(() {
      gridView = !gridView;
    });
  }

  @override
  void initState() {
    super.initState();
    checkOpenNote();
  }

  @override
  Widget build(BuildContext context) {
    final notes = context.watch<NoteProvider>().notes;
    final processedList = processNotes(notes);

    return SafeArea(
      child: isMobile
          ? Scaffold(
              floatingActionButton: FloatingActionButton(
                onPressed: () => createNewNote(),
                child: Icon(Icons.add),
              ),
              appBar: CustomAppBar(
                buttonType: AppBarButtonType.menuButton,
                title: Strings.notes,
                actions: [
                  if (selectedNotes.isNotEmpty) ...[
                    IconButton(
                      onPressed: () => selectAndUnselectAll(),
                      icon: Icon(Icons.select_all_rounded),
                    ),
                    IconButton(
                      onPressed: () => bulkDeleteNotes(),
                      icon: Icon(Icons.delete_rounded),
                    ),
                  ]
                ],
              ),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  notes.isEmpty
                      ? NoNoteWidget()
                      : context
                              .watch<SystemSettingsProvider>()
                              .systemSettingsModel
                              .viewMode
                          ? Expanded(
                              child: GridView.builder(
                                gridDelegate:
                                    SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 200,
                                  childAspectRatio: 1,
                                ),
                                itemCount: processedList.length,
                                itemBuilder: (context, index) {
                                  return NoteView(
                                    index: index,
                                    processedList: processedList,
                                    selectedNotes: selectedNotes,
                                    onTap: (note) => openNote(note),
                                    onLongPress: (details, note) => onLongPress(
                                      note,
                                      details: details,
                                    ),
                                    onSecondaryTap: (details, note) {
                                      onLongPress(
                                        note,
                                        tapDownDetails: details,
                                      );
                                    },
                                  );
                                },
                              ),
                            )
                          : Expanded(
                              child: ListView.builder(
                                padding: EdgeInsets.all(10),
                                itemCount: processedList.length,
                                itemBuilder: (context, index) {
                                  return NoteView(
                                    index: index,
                                    processedList: processedList,
                                    selectedNotes: selectedNotes,
                                    onTap: (note) => openNote(note),
                                    onLongPress: (details, note) => onLongPress(
                                      note,
                                      details: details,
                                    ),
                                    onSecondaryTap: (details, note) {
                                      onLongPress(
                                        note,
                                        tapDownDetails: details,
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                ],
              ),
              drawer: HomeDrawer(),
            )
          : ComputerHomeScreen(
              noteView: ListView.builder(
                itemCount: processedList.length,
                itemBuilder: (context, index) {
                  return NoteView(
                    index: index,
                    processedList: processedList,
                    selectedNotes: selectedNotes,
                    onTap: (note) => openNote(note),
                    onLongPress: (details, note) => onLongPress(
                      note,
                      details: details,
                    ),
                    onSecondaryTap: (details, note) {
                      onLongPress(
                        note,
                        tapDownDetails: details,
                      );
                    },
                  );
                },
              ),
            ),
    );
  }
}
