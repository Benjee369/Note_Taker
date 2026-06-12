import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../common/widgets/text_widget.dart';
import '../models/note_model.dart';

class NoteWidget extends StatelessWidget {
  final NoteModel note;

  const NoteWidget({
    super.key,
    required this.note,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final theme = Theme.of(context).colorScheme;
    // final textTheme = Theme.of(context).textTheme;

    String formattedDate(DateTime date) {
      return DateFormat('yyyy-MM-dd').format(date);
    }

    return Hero(
      tag: 'note',
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 1),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          // borderRadius: BorderRadius.circular(20),
          color: theme.primary,
        ),
        child: Material(
          color: theme.primary,
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
                ),
              ),
              TextWidget(
                text: formattedDate(note.createdDate),
                size: 14,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
