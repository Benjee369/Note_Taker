import 'package:flutter/material.dart';
import 'package:notes/common/models/folder_model.dart';
import 'package:notes/common/providers/note_provider.dart';
import 'note_widget.dart';
import 'text_widget.dart';
import '../models/note_model.dart';

class NoteView extends StatelessWidget {
  final int index;
  final List<Universal> processedList;
  final Set<String> selectedNotes;
  final Function(LongPressStartDetails, NoteModel)? onLongPress;
  final Function(TapDownDetails, NoteModel)? onSecondaryTap;
  final Function(TapDownDetails, FolderModel)? onFolderSecondaryTap;
  final Function(NoteModel) onTap;

  const NoteView({
    super.key,
    required this.index,
    required this.processedList,
    required this.selectedNotes,
    this.onLongPress,
    this.onSecondaryTap,
    required this.onTap,
    this.onFolderSecondaryTap,
  });

  @override
  Widget build(context) {
    // void collapseFolder(){}
    final note = processedList[index];

    if (note is Folder) {
      final f = note.folderModel;

      return InkWell(
        onSecondaryTapDown: (details) {
          onFolderSecondaryTap?.call(
            details,
            f,
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextWidget(
                text: note.folderModel.name,
                size: 20,
                fontWeight: FontWeight.bold,
              ),
              Icon(Icons.keyboard_arrow_down_rounded)
            ],
          ),
        ),
      );
    }

    if (note is ActualNote) {
      final n = note.noteModel;
      final selected = selectedNotes.contains(n.uuid);
      final isInFolder = note.noteModel.folderUuid != null;
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onLongPressStart: (details) => onLongPress?.call(
          details,
          n,
        ),
        onSecondaryTapDown: (details) {
          onSecondaryTap?.call(
            details,
            n,
          );
        },
        onTap: () => onTap.call(n),
        child: NoteWidget(
          note: n,
          isSelected: selected,
          isInFolder: isInFolder,
        ),
      );
    }

    return SizedBox.shrink();
  }
}
