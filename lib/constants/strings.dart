class Strings {
  static const String noteTaker = 'Note Taker';
  static const String addYourFirst = 'Add your first note';
  static const String openUpNote = 'Open up a note';
  static const String notes = 'Notes';
  static const String note = 'Note';

  static const String ok = 'Ok';
  static const String no = 'No';
  static const String cancel = 'Cancel';
  static const String menu = 'Menu';

  //!Note actions
  static const String pin = 'Pin';
  static const String unpin = 'Unpin';
  static const String delete = 'Delete';
  static const String duplicate = 'Duplicate';
  static const String select = 'Select';
  static const String addToFolder = 'Add to folder';


  //!Folder Actions
  static const String deleteFolder = "Delete folder";
  static const String changeName = "Change name";
  static const String changeFolderName = "Change folder name";
  static const String folderName = "Folder name";

  //!Dialogs
  static const String areYouSure = 'Are you sure you want to delete this note?';
  static String areYouSureMany(int count) =>
      'Are you sure you want to delete $count notes';
  static String areYouSureManyFolder(int count) =>
      'Are you sure you want to delete this folder with $count notes';

  //!Drawer
  static const String settings = "Settings";
  static const String darkMode = "Dark mode";
  static const String gridView = "Grid view";
  static const String listView = "List view";

  //!Computer Settings
  static const String appearance = "Appearance";
  static const String account = "Account";
  static const String updates = "Updates";
}
