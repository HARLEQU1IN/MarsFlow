// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'MarsFlow';

  @override
  String get navNotes => 'Notes';

  @override
  String get navTasks => 'Tasks';

  @override
  String get navFiles => 'Files';

  @override
  String get navSearch => 'Search';

  @override
  String get navNumbers => 'Numbers';

  @override
  String get navVehicle => 'Vehicle';

  @override
  String get navSettings => 'Settings';

  @override
  String get inbox => 'Inbox';

  @override
  String get newFolder => 'New folder';

  @override
  String get dialogFolderTitle => 'Folder name';

  @override
  String get hintName => 'Name';

  @override
  String get cancel => 'Cancel';

  @override
  String get create => 'Create';

  @override
  String get ok => 'OK';

  @override
  String get save => 'Save';

  @override
  String get untitled => 'Untitled';

  @override
  String notesEmptyState(String shortcut) {
    return 'Select a note or press $shortcut for a new note';
  }

  @override
  String get notesEmptyStateMobile =>
      'No notes here yet. Tap the button to create one.';

  @override
  String get notesNewNote => 'New note';

  @override
  String get noteTitleHint => 'Title';

  @override
  String get noteBodyHint => 'Write here…';

  @override
  String get attachments => 'Attachments';

  @override
  String get addFileTooltip => 'Add file';

  @override
  String get addImageTooltip => 'Add image';

  @override
  String get deleteNoteTooltip => 'Delete note';

  @override
  String get deleteFolderTooltip => 'Delete folder';

  @override
  String get confirmDeleteNoteTitle => 'Delete note?';

  @override
  String get confirmDeleteNoteBody =>
      'The note and its attachments will be removed.';

  @override
  String get confirmDeleteFolderTitle => 'Delete folder?';

  @override
  String get confirmDeleteFolderBody =>
      'The folder will be removed. Notes inside will move to Inbox.';

  @override
  String get deleteAction => 'Delete';

  @override
  String get filesScreenDescription =>
      'All files attached to any note are listed here. Use it to find or remove attachments globally; adding files is easiest from a note (Attachments section).';

  @override
  String get tasksTitle => 'Tasks';

  @override
  String get add => 'Add';

  @override
  String get noOpenTasks => 'No open tasks';

  @override
  String get newTask => 'New task';

  @override
  String get hintTaskTitle => 'Title';

  @override
  String taskPriority(int n) {
    return 'Priority $n';
  }

  @override
  String taskDue(String when) {
    return ' · Due $when';
  }

  @override
  String get taskStatusTodo => 'todo';

  @override
  String get taskStatusDoing => 'doing';

  @override
  String get taskStatusDone => 'done';

  @override
  String get taskStatusCancelled => 'cancelled';

  @override
  String get taskEisenhowerTitle => 'Eisenhower priority';

  @override
  String get taskChangePriority => 'Change priority';

  @override
  String get taskEisenhowerIU => 'Important + urgent';

  @override
  String get taskEisenhowerInU => 'Important, not urgent';

  @override
  String get taskEisenhowerIUn => 'Not important, urgent';

  @override
  String get taskEisenhowerInUn => 'Not important, not urgent';

  @override
  String get taskEisenhowerDo => 'Do';

  @override
  String get taskEisenhowerSchedule => 'Schedule';

  @override
  String get taskEisenhowerDelegate => 'Delegate';

  @override
  String get taskEisenhowerEliminate => 'Eliminate';

  @override
  String get filesTitle => 'Files';

  @override
  String get noAttachmentsYet => 'No attachments yet';

  @override
  String fileSubtitle(String path, int bytes) {
    return '$path · $bytes B';
  }

  @override
  String get searchTitle => 'Search (FTS5)';

  @override
  String get searchHint => 'Search notes…';

  @override
  String get searchAction => 'Search';

  @override
  String get numbersTitle => 'Numbers';

  @override
  String get numbersFilterHint => 'Quick filter…';

  @override
  String get copyNumberTooltip => 'Copy number';

  @override
  String get copied => 'Copied';

  @override
  String get numbersNewEntry => 'New entry';

  @override
  String get fieldNumber => 'Number';

  @override
  String get fieldTitle => 'Title';

  @override
  String get fieldCategory => 'Category';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get languageTitle => 'Language';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageRussian => 'Russian';

  @override
  String get storageDirectory => 'Storage directory';

  @override
  String get changeStoragePathTitle => 'Change storage path (restart required)';

  @override
  String get changeStoragePathSubtitle =>
      'Writes bootstrap config; copy data manually or use export first.';

  @override
  String get pickFolder => 'Pick folder';

  @override
  String get restartMarsFlowTitle => 'Restart MarsFlow';

  @override
  String get restartMarsFlowBody =>
      'Close and reopen the app to use the new path.';

  @override
  String get encryptNotesTitle => 'Encrypt new note content';

  @override
  String get encryptNotesSubtitle =>
      'AES key in secure storage; best-effort decrypt on read.';

  @override
  String get exportSqliteTitle => 'Export SQLite file';

  @override
  String get exportedSnackbar => 'Exported';

  @override
  String get saveEllipsis => 'Save…';

  @override
  String get exportAttachmentsTitle => 'Export attachments folder';

  @override
  String get filesCopiedSnackbar => 'Files copied';

  @override
  String get chooseEllipsis => 'Choose…';

  @override
  String get exportZipTitle => 'Export ZIP (DB + attachments)';

  @override
  String get zipCreatedSnackbar => 'ZIP created';

  @override
  String get importZipTitle => 'Import ZIP (full restore)';

  @override
  String get importZipSubtitle =>
      'Replaces database and attachments. Restart recommended.';

  @override
  String get pickZipEllipsis => 'Pick ZIP…';

  @override
  String get importCompleteTitle => 'Import complete';

  @override
  String get importCompleteBody => 'Restart the app to reload the database.';

  @override
  String get dialogExportDatabase => 'Export database';

  @override
  String get dialogSelectExportFolder => 'Select export folder';

  @override
  String get dialogExportZip => 'Export zip';

  @override
  String get noteDeletedSnackbar => 'Note deleted';

  @override
  String get foldersSection => 'Folders';

  @override
  String get taskDueDateOptional => 'Due date (optional)';

  @override
  String get taskPickDate => 'Choose date';

  @override
  String get taskClearDate => 'No date';

  @override
  String get taskChangeDueDate => 'Change due date';

  @override
  String get searchTabNotes => 'Notes';

  @override
  String get searchTabServiceLog => 'Service log';

  @override
  String get serviceLogTitle => 'Maintenance registry';

  @override
  String get serviceLogSubtitle =>
      'Oil change, inspection (ТО), repairs — sort by type or date.';

  @override
  String get serviceSortDateNew => 'Date: newest';

  @override
  String get serviceSortDateOld => 'Date: oldest';

  @override
  String get serviceSortTypeAz => 'Type: A–Z';

  @override
  String get serviceSortTypeZa => 'Type: Z–A';

  @override
  String get serviceAddRecord => 'Add record';

  @override
  String get serviceFieldActionType => 'Action type (e.g. Oil, ТО)';

  @override
  String get serviceFieldTitle => 'Short title';

  @override
  String get serviceFieldDetails => 'Details';

  @override
  String get serviceFieldDate => 'Date';

  @override
  String get serviceFieldOdometer => 'Odometer (km, optional)';

  @override
  String get serviceNewRecord => 'New maintenance record';

  @override
  String get serviceDeleteRecord => 'Delete record?';

  @override
  String get serviceDeleteRecordBody =>
      'This entry will be removed from the log.';

  @override
  String get serviceLogEmpty => 'No maintenance records yet. Tap Add record.';

  @override
  String get sortLabel => 'Sort';

  @override
  String get vehicleTitle => 'Vehicle';

  @override
  String get vehicleSectionDetails => 'Vehicle details';

  @override
  String get vehicleSectionService => 'Latest by service type';

  @override
  String get vehicleFieldMake => 'Make / brand';

  @override
  String get vehicleFieldModel => 'Model';

  @override
  String get vehicleFieldYear => 'Year';

  @override
  String get vehicleFieldVin => 'VIN';

  @override
  String get vehicleFieldPlate => 'License plate';

  @override
  String get vehicleFieldColor => 'Color';

  @override
  String get vehicleFieldOdometer => 'Odometer (km)';

  @override
  String get vehicleFieldNotes => 'Notes';

  @override
  String get vehicleSave => 'Save';

  @override
  String get vehicleSavedSnackbar => 'Vehicle profile saved';

  @override
  String get vehicleServiceEmpty =>
      'No service log entries yet. Add records under Search → Service log.';

  @override
  String get vehicleOpenServiceLog => 'Open service log';

  @override
  String get aboutListTileTitle => 'About MarsFlow';

  @override
  String aboutListTileSubtitle(String version, String phase) {
    return 'Version $version · $phase';
  }

  @override
  String get aboutPhaseAlpha => 'alpha';

  @override
  String get aboutAppBlurb =>
      'Offline-first notes, tasks, files, search, numbers, vehicle profile, and a maintenance log — your data stays on device.';

  @override
  String get aboutDeveloperLabel => 'Developer';

  @override
  String get aboutDeveloperName => 'Marcel Mukhamedzhanov';

  @override
  String get aboutCopyright => '© MarsFlow';

  @override
  String get settingsWebDiskHint =>
      'In the browser, data stays in this profile. Full export/import and choosing a custom folder are available in the desktop or mobile app.';
}
