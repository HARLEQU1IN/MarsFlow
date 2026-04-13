import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'MarsFlow'**
  String get appTitle;

  /// No description provided for @navNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get navNotes;

  /// No description provided for @navTasks.
  ///
  /// In en, this message translates to:
  /// **'Tasks'**
  String get navTasks;

  /// No description provided for @navFiles.
  ///
  /// In en, this message translates to:
  /// **'Files'**
  String get navFiles;

  /// No description provided for @navSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get navSearch;

  /// No description provided for @navNumbers.
  ///
  /// In en, this message translates to:
  /// **'Numbers'**
  String get navNumbers;

  /// No description provided for @navVehicle.
  ///
  /// In en, this message translates to:
  /// **'Vehicle'**
  String get navVehicle;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @inbox.
  ///
  /// In en, this message translates to:
  /// **'Inbox'**
  String get inbox;

  /// No description provided for @newFolder.
  ///
  /// In en, this message translates to:
  /// **'New folder'**
  String get newFolder;

  /// No description provided for @dialogFolderTitle.
  ///
  /// In en, this message translates to:
  /// **'Folder name'**
  String get dialogFolderTitle;

  /// No description provided for @hintName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get hintName;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @untitled.
  ///
  /// In en, this message translates to:
  /// **'Untitled'**
  String get untitled;

  /// No description provided for @notesEmptyState.
  ///
  /// In en, this message translates to:
  /// **'Select a note or press {shortcut} for a new note'**
  String notesEmptyState(String shortcut);

  /// No description provided for @notesEmptyStateMobile.
  ///
  /// In en, this message translates to:
  /// **'No notes here yet. Tap the button to create one.'**
  String get notesEmptyStateMobile;

  /// No description provided for @notesNewNote.
  ///
  /// In en, this message translates to:
  /// **'New note'**
  String get notesNewNote;

  /// No description provided for @noteTitleHint.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get noteTitleHint;

  /// No description provided for @noteBodyHint.
  ///
  /// In en, this message translates to:
  /// **'Write here…'**
  String get noteBodyHint;

  /// No description provided for @attachments.
  ///
  /// In en, this message translates to:
  /// **'Attachments'**
  String get attachments;

  /// No description provided for @addFileTooltip.
  ///
  /// In en, this message translates to:
  /// **'Add file'**
  String get addFileTooltip;

  /// No description provided for @addImageTooltip.
  ///
  /// In en, this message translates to:
  /// **'Add image'**
  String get addImageTooltip;

  /// No description provided for @deleteNoteTooltip.
  ///
  /// In en, this message translates to:
  /// **'Delete note'**
  String get deleteNoteTooltip;

  /// No description provided for @deleteFolderTooltip.
  ///
  /// In en, this message translates to:
  /// **'Delete folder'**
  String get deleteFolderTooltip;

  /// No description provided for @confirmDeleteNoteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete note?'**
  String get confirmDeleteNoteTitle;

  /// No description provided for @confirmDeleteNoteBody.
  ///
  /// In en, this message translates to:
  /// **'The note and its attachments will be removed.'**
  String get confirmDeleteNoteBody;

  /// No description provided for @confirmDeleteFolderTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete folder?'**
  String get confirmDeleteFolderTitle;

  /// No description provided for @confirmDeleteFolderBody.
  ///
  /// In en, this message translates to:
  /// **'The folder will be removed. Notes inside will move to Inbox.'**
  String get confirmDeleteFolderBody;

  /// No description provided for @deleteAction.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteAction;

  /// No description provided for @filesScreenDescription.
  ///
  /// In en, this message translates to:
  /// **'All files attached to any note are listed here. Use it to find or remove attachments globally; adding files is easiest from a note (Attachments section).'**
  String get filesScreenDescription;

  /// No description provided for @tasksTitle.
  ///
  /// In en, this message translates to:
  /// **'Tasks'**
  String get tasksTitle;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @noOpenTasks.
  ///
  /// In en, this message translates to:
  /// **'No open tasks'**
  String get noOpenTasks;

  /// No description provided for @newTask.
  ///
  /// In en, this message translates to:
  /// **'New task'**
  String get newTask;

  /// No description provided for @hintTaskTitle.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get hintTaskTitle;

  /// No description provided for @taskPriority.
  ///
  /// In en, this message translates to:
  /// **'Priority {n}'**
  String taskPriority(int n);

  /// No description provided for @taskDue.
  ///
  /// In en, this message translates to:
  /// **' · Due {when}'**
  String taskDue(String when);

  /// No description provided for @taskStatusTodo.
  ///
  /// In en, this message translates to:
  /// **'todo'**
  String get taskStatusTodo;

  /// No description provided for @taskStatusDoing.
  ///
  /// In en, this message translates to:
  /// **'doing'**
  String get taskStatusDoing;

  /// No description provided for @taskStatusDone.
  ///
  /// In en, this message translates to:
  /// **'done'**
  String get taskStatusDone;

  /// No description provided for @taskStatusCancelled.
  ///
  /// In en, this message translates to:
  /// **'cancelled'**
  String get taskStatusCancelled;

  /// No description provided for @taskEisenhowerTitle.
  ///
  /// In en, this message translates to:
  /// **'Eisenhower priority'**
  String get taskEisenhowerTitle;

  /// No description provided for @taskChangePriority.
  ///
  /// In en, this message translates to:
  /// **'Change priority'**
  String get taskChangePriority;

  /// No description provided for @taskEisenhowerIU.
  ///
  /// In en, this message translates to:
  /// **'Important + urgent'**
  String get taskEisenhowerIU;

  /// No description provided for @taskEisenhowerInU.
  ///
  /// In en, this message translates to:
  /// **'Important, not urgent'**
  String get taskEisenhowerInU;

  /// No description provided for @taskEisenhowerIUn.
  ///
  /// In en, this message translates to:
  /// **'Not important, urgent'**
  String get taskEisenhowerIUn;

  /// No description provided for @taskEisenhowerInUn.
  ///
  /// In en, this message translates to:
  /// **'Not important, not urgent'**
  String get taskEisenhowerInUn;

  /// No description provided for @taskEisenhowerDo.
  ///
  /// In en, this message translates to:
  /// **'Do'**
  String get taskEisenhowerDo;

  /// No description provided for @taskEisenhowerSchedule.
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get taskEisenhowerSchedule;

  /// No description provided for @taskEisenhowerDelegate.
  ///
  /// In en, this message translates to:
  /// **'Delegate'**
  String get taskEisenhowerDelegate;

  /// No description provided for @taskEisenhowerEliminate.
  ///
  /// In en, this message translates to:
  /// **'Eliminate'**
  String get taskEisenhowerEliminate;

  /// No description provided for @filesTitle.
  ///
  /// In en, this message translates to:
  /// **'Files'**
  String get filesTitle;

  /// No description provided for @noAttachmentsYet.
  ///
  /// In en, this message translates to:
  /// **'No attachments yet'**
  String get noAttachmentsYet;

  /// No description provided for @fileSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{path} · {bytes} B'**
  String fileSubtitle(String path, int bytes);

  /// No description provided for @searchTitle.
  ///
  /// In en, this message translates to:
  /// **'Search (FTS5)'**
  String get searchTitle;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search notes…'**
  String get searchHint;

  /// No description provided for @searchAction.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get searchAction;

  /// No description provided for @numbersTitle.
  ///
  /// In en, this message translates to:
  /// **'Numbers'**
  String get numbersTitle;

  /// No description provided for @numbersFilterHint.
  ///
  /// In en, this message translates to:
  /// **'Quick filter…'**
  String get numbersFilterHint;

  /// No description provided for @copyNumberTooltip.
  ///
  /// In en, this message translates to:
  /// **'Copy number'**
  String get copyNumberTooltip;

  /// No description provided for @copied.
  ///
  /// In en, this message translates to:
  /// **'Copied'**
  String get copied;

  /// No description provided for @numbersNewEntry.
  ///
  /// In en, this message translates to:
  /// **'New entry'**
  String get numbersNewEntry;

  /// No description provided for @fieldNumber.
  ///
  /// In en, this message translates to:
  /// **'Number'**
  String get fieldNumber;

  /// No description provided for @fieldTitle.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get fieldTitle;

  /// No description provided for @fieldCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get fieldCategory;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @languageTitle.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageTitle;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageRussian.
  ///
  /// In en, this message translates to:
  /// **'Russian'**
  String get languageRussian;

  /// No description provided for @storageDirectory.
  ///
  /// In en, this message translates to:
  /// **'Storage directory'**
  String get storageDirectory;

  /// No description provided for @changeStoragePathTitle.
  ///
  /// In en, this message translates to:
  /// **'Change storage path (restart required)'**
  String get changeStoragePathTitle;

  /// No description provided for @changeStoragePathSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Writes bootstrap config; copy data manually or use export first.'**
  String get changeStoragePathSubtitle;

  /// No description provided for @pickFolder.
  ///
  /// In en, this message translates to:
  /// **'Pick folder'**
  String get pickFolder;

  /// No description provided for @restartMarsFlowTitle.
  ///
  /// In en, this message translates to:
  /// **'Restart MarsFlow'**
  String get restartMarsFlowTitle;

  /// No description provided for @restartMarsFlowBody.
  ///
  /// In en, this message translates to:
  /// **'Close and reopen the app to use the new path.'**
  String get restartMarsFlowBody;

  /// No description provided for @encryptNotesTitle.
  ///
  /// In en, this message translates to:
  /// **'Encrypt new note content'**
  String get encryptNotesTitle;

  /// No description provided for @encryptNotesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'AES key in secure storage; best-effort decrypt on read.'**
  String get encryptNotesSubtitle;

  /// No description provided for @exportSqliteTitle.
  ///
  /// In en, this message translates to:
  /// **'Export SQLite file'**
  String get exportSqliteTitle;

  /// No description provided for @exportedSnackbar.
  ///
  /// In en, this message translates to:
  /// **'Exported'**
  String get exportedSnackbar;

  /// No description provided for @saveEllipsis.
  ///
  /// In en, this message translates to:
  /// **'Save…'**
  String get saveEllipsis;

  /// No description provided for @exportAttachmentsTitle.
  ///
  /// In en, this message translates to:
  /// **'Export attachments folder'**
  String get exportAttachmentsTitle;

  /// No description provided for @filesCopiedSnackbar.
  ///
  /// In en, this message translates to:
  /// **'Files copied'**
  String get filesCopiedSnackbar;

  /// No description provided for @chooseEllipsis.
  ///
  /// In en, this message translates to:
  /// **'Choose…'**
  String get chooseEllipsis;

  /// No description provided for @exportZipTitle.
  ///
  /// In en, this message translates to:
  /// **'Export ZIP (DB + attachments)'**
  String get exportZipTitle;

  /// No description provided for @zipCreatedSnackbar.
  ///
  /// In en, this message translates to:
  /// **'ZIP created'**
  String get zipCreatedSnackbar;

  /// No description provided for @importZipTitle.
  ///
  /// In en, this message translates to:
  /// **'Import ZIP (full restore)'**
  String get importZipTitle;

  /// No description provided for @importZipSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Replaces database and attachments. Restart recommended.'**
  String get importZipSubtitle;

  /// No description provided for @pickZipEllipsis.
  ///
  /// In en, this message translates to:
  /// **'Pick ZIP…'**
  String get pickZipEllipsis;

  /// No description provided for @importCompleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Import complete'**
  String get importCompleteTitle;

  /// No description provided for @importCompleteBody.
  ///
  /// In en, this message translates to:
  /// **'Restart the app to reload the database.'**
  String get importCompleteBody;

  /// No description provided for @dialogExportDatabase.
  ///
  /// In en, this message translates to:
  /// **'Export database'**
  String get dialogExportDatabase;

  /// No description provided for @dialogSelectExportFolder.
  ///
  /// In en, this message translates to:
  /// **'Select export folder'**
  String get dialogSelectExportFolder;

  /// No description provided for @dialogExportZip.
  ///
  /// In en, this message translates to:
  /// **'Export zip'**
  String get dialogExportZip;

  /// No description provided for @noteDeletedSnackbar.
  ///
  /// In en, this message translates to:
  /// **'Note deleted'**
  String get noteDeletedSnackbar;

  /// No description provided for @foldersSection.
  ///
  /// In en, this message translates to:
  /// **'Folders'**
  String get foldersSection;

  /// No description provided for @taskDueDateOptional.
  ///
  /// In en, this message translates to:
  /// **'Due date (optional)'**
  String get taskDueDateOptional;

  /// No description provided for @taskPickDate.
  ///
  /// In en, this message translates to:
  /// **'Choose date'**
  String get taskPickDate;

  /// No description provided for @taskClearDate.
  ///
  /// In en, this message translates to:
  /// **'No date'**
  String get taskClearDate;

  /// No description provided for @taskChangeDueDate.
  ///
  /// In en, this message translates to:
  /// **'Change due date'**
  String get taskChangeDueDate;

  /// No description provided for @searchTabNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get searchTabNotes;

  /// No description provided for @searchTabServiceLog.
  ///
  /// In en, this message translates to:
  /// **'Service log'**
  String get searchTabServiceLog;

  /// No description provided for @serviceLogTitle.
  ///
  /// In en, this message translates to:
  /// **'Maintenance registry'**
  String get serviceLogTitle;

  /// No description provided for @serviceLogSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Oil change, inspection (ТО), repairs — sort by type or date.'**
  String get serviceLogSubtitle;

  /// No description provided for @serviceSortDateNew.
  ///
  /// In en, this message translates to:
  /// **'Date: newest'**
  String get serviceSortDateNew;

  /// No description provided for @serviceSortDateOld.
  ///
  /// In en, this message translates to:
  /// **'Date: oldest'**
  String get serviceSortDateOld;

  /// No description provided for @serviceSortTypeAz.
  ///
  /// In en, this message translates to:
  /// **'Type: A–Z'**
  String get serviceSortTypeAz;

  /// No description provided for @serviceSortTypeZa.
  ///
  /// In en, this message translates to:
  /// **'Type: Z–A'**
  String get serviceSortTypeZa;

  /// No description provided for @serviceAddRecord.
  ///
  /// In en, this message translates to:
  /// **'Add record'**
  String get serviceAddRecord;

  /// No description provided for @serviceFieldActionType.
  ///
  /// In en, this message translates to:
  /// **'Action type (e.g. Oil, ТО)'**
  String get serviceFieldActionType;

  /// No description provided for @serviceFieldTitle.
  ///
  /// In en, this message translates to:
  /// **'Short title'**
  String get serviceFieldTitle;

  /// No description provided for @serviceFieldDetails.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get serviceFieldDetails;

  /// No description provided for @serviceFieldDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get serviceFieldDate;

  /// No description provided for @serviceFieldOdometer.
  ///
  /// In en, this message translates to:
  /// **'Odometer (km, optional)'**
  String get serviceFieldOdometer;

  /// No description provided for @serviceNewRecord.
  ///
  /// In en, this message translates to:
  /// **'New maintenance record'**
  String get serviceNewRecord;

  /// No description provided for @serviceDeleteRecord.
  ///
  /// In en, this message translates to:
  /// **'Delete record?'**
  String get serviceDeleteRecord;

  /// No description provided for @serviceDeleteRecordBody.
  ///
  /// In en, this message translates to:
  /// **'This entry will be removed from the log.'**
  String get serviceDeleteRecordBody;

  /// No description provided for @serviceLogEmpty.
  ///
  /// In en, this message translates to:
  /// **'No maintenance records yet. Tap Add record.'**
  String get serviceLogEmpty;

  /// No description provided for @sortLabel.
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get sortLabel;

  /// No description provided for @vehicleTitle.
  ///
  /// In en, this message translates to:
  /// **'Vehicle'**
  String get vehicleTitle;

  /// No description provided for @vehicleSectionDetails.
  ///
  /// In en, this message translates to:
  /// **'Vehicle details'**
  String get vehicleSectionDetails;

  /// No description provided for @vehicleSectionService.
  ///
  /// In en, this message translates to:
  /// **'Latest by service type'**
  String get vehicleSectionService;

  /// No description provided for @vehicleFieldMake.
  ///
  /// In en, this message translates to:
  /// **'Make / brand'**
  String get vehicleFieldMake;

  /// No description provided for @vehicleFieldModel.
  ///
  /// In en, this message translates to:
  /// **'Model'**
  String get vehicleFieldModel;

  /// No description provided for @vehicleFieldYear.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get vehicleFieldYear;

  /// No description provided for @vehicleFieldVin.
  ///
  /// In en, this message translates to:
  /// **'VIN'**
  String get vehicleFieldVin;

  /// No description provided for @vehicleFieldPlate.
  ///
  /// In en, this message translates to:
  /// **'License plate'**
  String get vehicleFieldPlate;

  /// No description provided for @vehicleFieldColor.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get vehicleFieldColor;

  /// No description provided for @vehicleFieldOdometer.
  ///
  /// In en, this message translates to:
  /// **'Odometer (km)'**
  String get vehicleFieldOdometer;

  /// No description provided for @vehicleFieldNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get vehicleFieldNotes;

  /// No description provided for @vehicleSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get vehicleSave;

  /// No description provided for @vehicleSavedSnackbar.
  ///
  /// In en, this message translates to:
  /// **'Vehicle profile saved'**
  String get vehicleSavedSnackbar;

  /// No description provided for @vehicleServiceEmpty.
  ///
  /// In en, this message translates to:
  /// **'No service log entries yet. Add records under Search → Service log.'**
  String get vehicleServiceEmpty;

  /// No description provided for @vehicleOpenServiceLog.
  ///
  /// In en, this message translates to:
  /// **'Open service log'**
  String get vehicleOpenServiceLog;

  /// No description provided for @aboutListTileTitle.
  ///
  /// In en, this message translates to:
  /// **'About MarsFlow'**
  String get aboutListTileTitle;

  /// No description provided for @aboutListTileSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Version {version} · {phase}'**
  String aboutListTileSubtitle(String version, String phase);

  /// No description provided for @aboutPhaseAlpha.
  ///
  /// In en, this message translates to:
  /// **'alpha'**
  String get aboutPhaseAlpha;

  /// No description provided for @aboutAppBlurb.
  ///
  /// In en, this message translates to:
  /// **'Offline-first notes, tasks, files, search, numbers, vehicle profile, and a maintenance log — your data stays on device.'**
  String get aboutAppBlurb;

  /// No description provided for @aboutDeveloperLabel.
  ///
  /// In en, this message translates to:
  /// **'Developer'**
  String get aboutDeveloperLabel;

  /// No description provided for @aboutDeveloperName.
  ///
  /// In en, this message translates to:
  /// **'Marcel Mukhamedzhanov'**
  String get aboutDeveloperName;

  /// No description provided for @aboutCopyright.
  ///
  /// In en, this message translates to:
  /// **'© MarsFlow'**
  String get aboutCopyright;

  /// No description provided for @settingsWebDiskHint.
  ///
  /// In en, this message translates to:
  /// **'In the browser, data stays in this profile. Full export/import and choosing a custom folder are available in the desktop or mobile app.'**
  String get settingsWebDiskHint;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
