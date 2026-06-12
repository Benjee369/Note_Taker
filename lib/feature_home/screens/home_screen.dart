import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:notes/common/widgets/custom_popup_menu.dart';
import 'package:notes/common/widgets/dialogs.dart';
import 'package:notes/common/widgets/text_widget.dart';
import 'package:notes/constants/app_images.dart';
import 'package:notes/constants/app_sizes.dart';
import 'package:notes/feature_home/models/note_model.dart';
import 'package:notes/feature_home/providers/note_provider.dart';
import 'package:notes/feature_home/screens/note_screen.dart';
import 'package:notes/feature_home/widgets/note_widget.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../common/navigation/navigation.dart';
import '../../common/widgets/custom_app_bar.dart';
import '../../constants/strings.dart';

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
    );

    Navigation.navigateTo(context, NoteScreen(note: note, isNewNote: true));
  }

  void openNote(NoteModel note) {
    Navigation.navigateTo(context, NoteScreen(note: note));
  }

  void onLongPress(
    LongPressStartDetails details,
    NoteModel note,
  ) {
    CustomPopupMenu.show(
      context: context,
      position: details.globalPosition,
      items: [
        PopupMenuItemData(
          value: 1,
          icon: Icons.push_pin_rounded,
          label: "Pin",
        ),
        PopupMenuItemData(
          value: 2,
          icon: Icons.delete_rounded,
          label: "Delete",
        ),
      ],
      onSelected: (value) {
        switch (value) {
          case 1:
            pinNote();
            break;
          case 2:
            deleteNote(note.uuid);
            break;
        }
      },
    );
  }

  void deleteNote(String uuid) {
    Dialogs.dialogWithOptions(
      context,
      'Are you sure you want to delete this note.',
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

  void pinNote() {}

  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.sizeOf(context);
    final notes = context.watch<NoteProvider>().notes;

    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () => createNewNote(),
          child: Icon(Icons.add),
        ),
        appBar: CustomAppBar(
          buttonType: AppBarButtonType.menuButton,
          title: 'Notes',
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            notes.isEmpty
                ? Expanded(
                    child: Center(
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
                            text: 'Add your first note',
                            fontWeight: FontWeight.bold,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  )
                : Expanded(
                    child: ListView.separated(
                      padding: EdgeInsets.all(10),
                      itemCount: notes.length,
                      itemBuilder: (BuildContext context, int index) {
                        final note = notes[index];

                        return GestureDetector(
                          onLongPressStart: (details) => onLongPress(
                            details,
                            note,
                          ),
                          onTap: () => openNote(note),
                          child: NoteWidget(
                            // onTap: () => openNote(note),
                            note: note,
                            // onLongPress: (details) {},
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return gapH4;
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
