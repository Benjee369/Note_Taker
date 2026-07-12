import 'package:flutter/material.dart';
import 'package:notes/common/models/folder_model.dart';
import 'package:notes/common/models/note_preview_model.dart';
import 'note_widget.dart';
import 'text_widget.dart';
import '../providers/note_provider.dart';

class NoteView extends StatelessWidget {
  final int index;
  final List<Universal> processedList;
  final Set<String> selectedNotes;
  final Set<String> collapsedFolderUuids;
  final Function(LongPressStartDetails, NotePreviewModel)? onLongPress;
  final Function(TapDownDetails, NotePreviewModel)? onSecondaryTap;
  final Function(TapDownDetails, FolderModel)? onFolderSecondaryTap;
  final Function(NotePreviewModel) onTap;
  final Function(FolderModel)? onFolderTap;

  const NoteView({
    super.key,
    required this.index,
    required this.processedList,
    required this.selectedNotes,
    required this.collapsedFolderUuids,
    this.onLongPress,
    this.onSecondaryTap,
    required this.onTap,
    this.onFolderSecondaryTap,
    this.onFolderTap,
  });

  @override
  Widget build(BuildContext context) {
    final note = processedList[index];

    if (note is Folder) {
      final f = note.folderModel;
      final isCollapsed = collapsedFolderUuids.contains(f.uuid);

      return InkWell(
        onSecondaryTapDown: (details) {
          onFolderSecondaryTap?.call(
            details,
            f,
          );
        },
        onTap: () => onFolderTap?.call(f),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextWidget(
                text: f.name,
                size: 20,
                fontWeight: FontWeight.bold,
              ),
              Icon(
                isCollapsed
                    ? Icons.keyboard_arrow_down_rounded
                    : Icons.keyboard_arrow_up_rounded,
              )
            ],
          ),
        ),
      );
    }
    if (note is PreviewNote) {
      final n = note.previewModel;
      final selected = selectedNotes.contains(n.uuid);
      final isInFolder = n.folderUuid != null;

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
