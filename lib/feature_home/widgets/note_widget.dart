import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../common/widgets/text_widget.dart';
import '../../constants/app_colors.dart';
import '../models/note_model.dart';

class NoteWidget extends StatelessWidget {
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final NoteModel note;

  const NoteWidget({
    super.key,
    required this.onTap,
    required this.note,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final theme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    String formattedDate(DateTime date) {
      return DateFormat('dd-MM-yyyy').format(date);
    }

    return GestureDetector(
      onTap: onTap,
      onLongPress: () {},
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: theme.primary,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: size.width * 0.8,
              child: TextWidget(
                text: note.content,
                fontWeight: FontWeight.bold,
                size: 20,
                maxLines: 1,
                overFlow: TextOverflow.ellipsis,
              ),
            ),
            TextWidget(text: formattedDate(note.createdDate)),
          ],
        ),
      ),
    );
  }
}
