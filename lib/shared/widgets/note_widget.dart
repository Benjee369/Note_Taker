import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes/shared/providers/platform_provider.dart';
import 'package:provider/provider.dart';
import 'package:notes/shared/models/note_preview_model.dart';
import 'package:notes/shared/widgets/text_widget.dart';
import 'package:notes/shared/constants/app_sizes.dart';
import 'package:notes/shared/providers/note_provider.dart';

class NoteWidget extends StatelessWidget {
  final NotePreviewModel note;
  final bool isSelected;
  final bool isInFolder;

  const NoteWidget({
    super.key,
    required this.note,
    required this.isSelected,
    required this.isInFolder,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final theme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final noteProvider = context.read<NoteProvider>().noteModel;

    bool isOpen = false;
    if (noteProvider?.uuid != null) {
      isOpen = !isMobile && noteProvider!.uuid == note.uuid;
    }
    String formattedDate(DateTime date) {
      return DateFormat('yyyy-MM-dd').format(date);
    }

    return AnimatedScale(
      scale: isSelected ? 0.99 : 1,
      duration: Duration(milliseconds: 200),
      child: Container(
        margin: EdgeInsets.fromLTRB(
          isInFolder ? 30 : 15,
          1,
          isOpen ? 0 : 15,
          1,
        ),
        padding: EdgeInsets.symmetric(
          vertical: 4,
          horizontal: 8,
        ),
        decoration: BoxDecoration(
          color: isOpen ? theme.secondary : theme.primary,
          border: isSelected
              ? Border.all(
                  color: textTheme.bodyLarge!.color!,
                  width: 1,
                )
              : null,
        ),
        child: Material(
          color: isOpen ? theme.secondary : theme.primary,
          child: Row(
            children: [
              // SizedBox(
              //   height: 20,
              //   width: 20,
              //   child: Column(
              //     mainAxisAlignment: MainAxisAlignment.start,
              //     children: [
              //       Expanded(child: VerticalDivider()),
              //       Expanded(
              //         child: Row(
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           children: [
              //             Expanded(child: SizedBox()),
              //             Expanded(
              //               child: Align(
              //                 alignment: Alignment.topCenter,
              //                 child: Divider(),
              //               ),
              //             ),
              //           ],
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              if (isSelected) ...[
                AnimatedContainer(
                  duration: Duration(milliseconds: 100),
                  height: isMobile ? 35 : 20,
                  width: isMobile ? 35 : 20,
                  decoration: BoxDecoration(
                    color: textTheme.bodyLarge?.color,
                  ),
                  child: Icon(
                    Icons.check,
                    color: theme.surface,
                    size: isMobile ? null : 15,
                  ),
                ),
                gapW8,
              ],
              Icon(
                Icons.insert_drive_file_rounded,
                size: 16,
                color: theme.surface,
              ),
              gapW8,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: size.width * 0.8,
                      child: TextWidget(
                        text: note.contentPreview,
                        fontWeight: FontWeight.bold,
                        maxLines: 1,
                        overFlow: TextOverflow.ellipsis,
                        textColor: theme.surface,
                      ),
                    ),
                    if (isMobile)
                      TextWidget(
                        text: formattedDate(note.createdDate),
                        size: 14,
                        textColor: theme.surface,
                      ),
                  ],
                ),
              ),
              if (note.isPinned)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Icon(
                    Icons.push_pin_rounded,
                    color: theme.surface,
                    size: 14,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
