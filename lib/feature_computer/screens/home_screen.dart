import 'package:flutter/material.dart';
import 'package:notes/feature_mobile/screens/note_screen.dart';
import 'package:notes/feature_mobile/widgets/no_note_widget.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../common/models/note_model.dart';
import '../../common/widgets/text_widget.dart';
import '../../feature_mobile/providers/note_provider.dart';

class ComputerHomeScreen extends StatefulWidget {
  final Widget noteView;

  const ComputerHomeScreen({
    super.key,
    required this.noteView,
  });

  @override
  State<ComputerHomeScreen> createState() => _ComputerHomeScreenState();
}

class _ComputerHomeScreenState extends State<ComputerHomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _xOffsetAnimation;
  final double _drawerWidth = 250.0;
  bool _isDrawerOpen = true;
  final uuid = Uuid();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    _xOffsetAnimation = Tween<double>(
      begin: 0.0,
      end: _drawerWidth,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _animationController.dispose();
  }

  void toggleDrawer() {
    setState(() {
      _isDrawerOpen = !_isDrawerOpen;
      if (_isDrawerOpen) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  void createNewNote() async {
    final id = uuid.v4();
    final note = NoteModel(
      uuid: id,
      content: '',
      createdDate: DateTime.now(),
      updatedDate: DateTime.now(),
      isPinned: false,
    );
    await context.read<NoteProvider>().saveNote(note);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final noteProvider = context.watch<NoteProvider>();

    return Scaffold(
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Stack(
            children: [
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                width: _drawerWidth,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      right: BorderSide(color: theme.primary),
                    ),
                  ),
                  child: Scaffold(
                    floatingActionButton: FloatingActionButton(
                      onPressed: () => createNewNote(),
                      child: Icon(Icons.add),
                    ),
                    body: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: TextWidget(
                            text: 'Menu',
                            size: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        noteProvider.notes.isEmpty
                            ? NoNoteWidget()
                            : Expanded(
                                child: widget.noteView,
                              )
                      ],
                    ),
                  ),
                ),
              ),
              Transform.translate(
                offset: Offset(_xOffsetAnimation.value, 0),
                child: Scaffold(
                  appBar: AppBar(
                    title: const TextWidget(text: 'Note'),
                    leading: IconButton(
                      icon: Icon(
                        _isDrawerOpen ? Icons.arrow_back : Icons.menu,
                      ),
                      onPressed: toggleDrawer,
                    ),
                  ),
                  body: noteProvider.noteModel != null
                      ? Consumer<NoteProvider>(
                          builder: (context, noteProvider, child) {
                          return NoteScreen();
                        })
                      : NoNoteWidget(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
