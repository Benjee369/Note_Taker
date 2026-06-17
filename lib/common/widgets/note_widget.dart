import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes/common/providers/platform_provider.dart';
import 'package:provider/provider.dart';
import 'text_widget.dart';
import '../../constants/app_sizes.dart';
import '../models/note_model.dart';
import '../providers/note_provider.dart';

class NoteWidget extends StatelessWidget {
  final NoteModel note;
  final bool isSelected;

  const NoteWidget({
    super.key,
    required this.note,
    required this.isSelected,
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
        margin: EdgeInsets.fromLTRB(10, 1, isOpen ? 0 : 10, 1),
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
                    size: isMobile ? null : 20,
                  ),
                ),
                gapW8,
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: size.width * 0.8,
                      child: TextWidget(
                        text: note.content,
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
