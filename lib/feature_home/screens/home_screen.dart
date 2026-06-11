import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes/common/widgets/text_widget.dart';
import 'package:notes/constants/app_colors.dart';
import 'package:notes/constants/app_sizes.dart';
import 'package:notes/feature_home/models/note_model.dart';
import 'package:notes/feature_home/providers/note_provider.dart';
import 'package:notes/feature_home/screens/note_screen.dart';
import 'package:notes/feature_home/widgets/note_widget.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../common/navigation/navigation.dart';
import '../../common/widgets/custom_popup_menu.dart';

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

  void onLongPress(){
    // CustomPopupMenu();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final notes = context.watch<NoteProvider>().notes;

    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () => createNewNote(),
          child: Icon(Icons.add),
        ),
        body: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 15, top: 5),
              child: InkWell(
                onTap: () => context.read<NoteProvider>().getNotes(),
                child: TextWidget(
                  text: 'Notes',
                  size: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            notes.isEmpty
                ? Expanded(
                    child: Column(
                      children: [
                        Icon(Icons.eighteen_mp),
                        Text('Add your first note'),
                      ],
                    ),
                  )
                : Expanded(
                    child: ListView.separated(
                      padding: EdgeInsets.all(10),
                      itemCount: notes.length,
                      itemBuilder: (BuildContext context, int index) {
                        final note = notes[index];

                        return NoteWidget(
                          onTap: () => openNote(note),
                          note: note,
                          onLongPress: () {},
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return gapH4;
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
