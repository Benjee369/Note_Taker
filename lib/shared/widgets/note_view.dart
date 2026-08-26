import 'package:flutter/material.dart';
import 'package:notes/shared/models/folder_model.dart';
import 'package:notes/shared/models/note_preview_model.dart';
import 'package:notes/shared/constants/app_sizes.dart';
import 'package:notes/shared/widgets/note_widget.dart';
import 'package:notes/shared/widgets/text_widget.dart';
import 'package:notes/shared/providers/note_provider.dart';

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
        child: ColoredBox(
          color: Theme.of(context).colorScheme.secondary.withAlpha(40),
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Row(
              children: [
                Icon(
                  isCollapsed
                      ? Icons.keyboard_arrow_right_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  size: 14,
                ),
                gapW12,
                Icon(
                  Icons.folder_rounded,
                  size: 16,
                ),
                gapW8,
                TextWidget(
                  text: f.name,
                  size: 16,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),
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
