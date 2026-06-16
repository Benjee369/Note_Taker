import 'package:flutter/material.dart';
import '../../common/widgets/text_widget.dart';
import '../../common/models/note_model.dart';
import 'note_widget.dart';

class NoteView extends StatelessWidget {
  final int index;
  final List<NoteItem> processedList;
  final Set<String> selectedNotes;
  final Function(LongPressStartDetails, NoteModel)? onLongPress;
  final Function(TapDownDetails, NoteModel)? onSecondaryTap;
  final Function(NoteModel) onTap;

  const NoteView({
    super.key,
    required this.index,
    required this.processedList,
    required this.selectedNotes,
    this.onLongPress,
    this.onSecondaryTap,
    required this.onTap,
  });

  @override
  Widget build(context) {
    final note = processedList[index];

    if (note is NoteHeader) {
      return Padding(
        padding: const EdgeInsets.only(left: 10),
        child: TextWidget(
          text: note.title,
          size: 20,
          fontWeight: FontWeight.bold,
        ),
      );
    }

    if (note is NoteListItem) {
      final selected = selectedNotes.contains(note.note.uuid);

      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onLongPressStart: (details) => onLongPress?.call(
          details,
          note.note,
        ),
        onSecondaryTapDown: (details) {
          onSecondaryTap?.call(
            details,
            note.note,
          );
        },
        onTap: () => onTap.call(note.note),
        child: NoteWidget(
          note: note.note,
          isSelected: selected,
        ),
      );
    }

    return SizedBox.shrink();
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
