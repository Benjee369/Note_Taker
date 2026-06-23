import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:notes/common/providers/system_settings_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../common/providers/platform_provider.dart';
import '../../common/widgets/custom_app_bar.dart';
import '../../constants/strings.dart';
import '../../common/models/note_model.dart';
import '../../common/providers/note_provider.dart';

class NoteScreen extends StatefulWidget {
  final bool? isNewNote;
  final bool? isDrawerOpen;
  final VoidCallback? toggleDrawer;

  const NoteScreen({
    super.key,
    this.isNewNote = false,
    this.isDrawerOpen = true,
    this.toggleDrawer,
  });

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen>
    with SingleTickerProviderStateMixin {
  late TextEditingController _noteController;
  late AnimationController _animationController;
  late Animation<double> _drawerAnimation;
  final _uuid = Uuid().v4();
  Timer? _debouncer;
  final double _collapsedWidth = 0.0;
  bool _isHovered = false;

  Future saveNote() async {
    final isNew = widget.isNewNote == true;
    final now = DateTime.now();
    final noteProvider = context.read<NoteProvider>().noteModel;

    final note = NoteModel(
      uuid: isNew ? _uuid : noteProvider!.uuid,
      content: _noteController.text,
      createdDate: isNew ? now : noteProvider!.createdDate,
      updatedDate: now,
      isPinned: noteProvider?.isPinned ?? false,
    );
    await context.read<NoteProvider>().saveNote(note);
  }

  void onTypingChange(String text) {
    final isNew = widget.isNewNote == true;
    final now = DateTime.now();
    final noteProvider = context.read<NoteProvider>().noteModel;

    final note = NoteModel(
      uuid: isNew ? _uuid : noteProvider!.uuid,
      content: _noteController.text,
      createdDate: isNew ? now : noteProvider!.createdDate,
      updatedDate: now,
      isPinned: noteProvider?.isPinned ?? false,
    );
    context.read<NoteProvider>().quickSaveNote(
          note,
          _noteController.text,
        );

    if (_debouncer?.isActive ?? false) _debouncer?.cancel();
    _debouncer = Timer(const Duration(milliseconds: 1000), () {
      saveNote();
    });
  }

  void closeNote() {
    context.read<NoteProvider>().clearOpenNote();
    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    _drawerAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _animationController.value = 1.0;

    _noteController = TextEditingController();
    final noteProvider = context.read<NoteProvider>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.isNewNote != true) {
        _noteController.text = noteProvider.noteModel!.content;
      }
    });

    noteProvider.addListener(_onNoteChanged);
  }

  void _onNoteChanged() {
    final note = context.read<NoteProvider>();
    final content = note.noteModel?.content ?? '';
    if (note.noteModel == null) {
      Scaffold.of(context).closeEndDrawer();
    }

    if (_noteController.text != content) {
      _noteController.value = TextEditingValue(
        text: content,
        selection: TextSelection.collapsed(offset: content.length),
      );
    }
  }

  void onSideBarWidthChange(DragUpdateDetails details) {
    final settingsProvider = context.read<SystemSettingsProvider>();
    final width =
        (settingsProvider.systemSettingsModel.markDownWidth - details.delta.dx)
            .clamp(150, 500)
            .toDouble();
    settingsProvider.setMarkDownWidth(width, shouldSave: false);
    if (_debouncer?.isActive ?? false) _debouncer?.cancel();
    _debouncer = Timer(const Duration(milliseconds: 300), () {
      settingsProvider.setMarkDownWidth(width);
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _noteController.dispose();
    _debouncer?.cancel();
    context.read<NoteProvider>().removeListener(_onNoteChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Consumer2<NoteProvider, SystemSettingsProvider>(
      builder: (
        context,
        noteProvider,
        systemSettingProvider,
        child,
      ) {
        final fontSettings =
            systemSettingProvider.systemSettingsModel.noteFontSettings;
        return SafeArea(
          child: Scaffold(
            appBar: isMobile
                ? CustomAppBar(
                    title: Strings.note,
                    buttonType: AppBarButtonType.backButton,
                    onBackPress: () => closeNote(),
                  )
                : CustomAppBar(
                    buttonType: AppBarButtonType.custom,
                    title: Strings.note,
                    customIcon: widget.isDrawerOpen == true
                        ? Icons.chevron_left_rounded
                        : Icons.menu,
                    onBackPress: () => widget.toggleDrawer?.call(),
                    actions: [
                      IconButton(
                        onPressed: () {
                          Scaffold.of(context).openEndDrawer();
                        },
                        icon: Icon(Icons.info),
                      ),
                    ],
                  ),
            body: AnimatedBuilder(
                animation: _drawerAnimation,
                builder: (context, child) {
                  final currentDrawerWidth = Tween<double>(
                    begin: _collapsedWidth,
                    end:
                        systemSettingProvider.systemSettingsModel.markDownWidth,
                  ).evaluate(_drawerAnimation);

                  return Stack(
                    children: [
                      //!Text area
                      Positioned(
                        right: currentDrawerWidth,
                        left: 0,
                        top: 0,
                        bottom: 0,
                        child: TextField(
                          onChanged: (text) => onTypingChange(text),
                          controller: _noteController,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 3.0,
                              horizontal: 10.0,
                            ),
                            border: InputBorder.none,
                          ),
                          style: TextStyle(
                            color: theme.primary,
                            fontWeight: fontSettings.isFontWeighted
                                ? FontWeight.bold
                                : null,
                            fontSize: fontSettings.fontSize,
                            height: fontSettings.fontHeight,
                          ),
                          maxLines: 1000,
                        ),
                      ),

                      //!Markdown side
                      Positioned(
                        right: 0,
                        top: 0,
                        bottom: 0,
                        width: currentDrawerWidth,
                        child: Markdown(
                          data: noteProvider.noteModel?.content ?? '',
                          selectable: true,
                          styleSheet: MarkdownStyleSheet(
                            p: TextStyle(
                              color: textTheme.bodyLarge?.color ?? Colors.black,
                            ),
                            textScaler:
                                TextScaler.linear(fontSettings.fontSize * 0.07),
                          ),
                        ),
                      ),

                      //!Divider
                      Positioned(
                        right: currentDrawerWidth - 15,
                        top: 0,
                        bottom: 0,
                        width: 30,
                        child: MouseRegion(
                          onEnter: (_) => setState(() => _isHovered = true),
                          onExit: (_) => setState(() => _isHovered = false),
                          cursor: SystemMouseCursors.resizeLeftRight,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              VerticalDivider(
                                thickness: 1,
                                color: theme.primary,
                              ),
                              GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onHorizontalDragUpdate: (details) {
                                  onSideBarWidthChange(details);
                                },
                                child: _isHovered
                                    ? Container(
                                        padding: const EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: theme.primary,
                                        ),
                                        child: const Icon(
                                          Icons.drag_handle,
                                          size: 16,
                                          color: Colors.white,
                                        ),
                                      )
                                    : null,
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                }),
          ),
        );
      },
    );
  }
}
