// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'MarsFlow';

  @override
  String get navNotes => 'Заметки';

  @override
  String get navTasks => 'Задачи';

  @override
  String get navFiles => 'Файлы';

  @override
  String get navSearch => 'Поиск';

  @override
  String get navNumbers => 'Номера';

  @override
  String get navVehicle => 'Машина';

  @override
  String get navSettings => 'Настройки';

  @override
  String get inbox => 'Входящие';

  @override
  String get newFolder => 'Новая папка';

  @override
  String get dialogFolderTitle => 'Имя папки';

  @override
  String get hintName => 'Название';

  @override
  String get cancel => 'Отмена';

  @override
  String get create => 'Создать';

  @override
  String get ok => 'ОК';

  @override
  String get save => 'Сохранить';

  @override
  String get untitled => 'Без названия';

  @override
  String notesEmptyState(String shortcut) {
    return 'Выберите заметку или нажмите $shortcut, чтобы создать новую';
  }

  @override
  String get notesEmptyStateMobile =>
      'Здесь пока нет заметок. Нажмите кнопку, чтобы создать.';

  @override
  String get notesNewNote => 'Новая заметка';

  @override
  String get noteTitleHint => 'Заголовок';

  @override
  String get noteBodyHint => 'Текст заметки…';

  @override
  String get attachments => 'Вложения';

  @override
  String get addFileTooltip => 'Добавить файл';

  @override
  String get addImageTooltip => 'Добавить изображение';

  @override
  String get deleteNoteTooltip => 'Удалить заметку';

  @override
  String get deleteFolderTooltip => 'Удалить папку';

  @override
  String get confirmDeleteNoteTitle => 'Удалить заметку?';

  @override
  String get confirmDeleteNoteBody => 'Заметка и все вложения будут удалены.';

  @override
  String get confirmDeleteFolderTitle => 'Удалить папку?';

  @override
  String get confirmDeleteFolderBody =>
      'Папка будет удалена. Заметки из неё переедут во «Входящие».';

  @override
  String get deleteAction => 'Удалить';

  @override
  String get filesScreenDescription =>
      'Здесь показаны все файлы, прикреплённые к любым заметкам. Удобно искать и удалять вложения целиком; добавлять файлы проще из заметки (блок «Вложения»).';

  @override
  String get tasksTitle => 'Задачи';

  @override
  String get add => 'Добавить';

  @override
  String get noOpenTasks => 'Нет открытых задач';

  @override
  String get newTask => 'Новая задача';

  @override
  String get hintTaskTitle => 'Название';

  @override
  String taskPriority(int n) {
    return 'Приоритет $n';
  }

  @override
  String taskDue(String when) {
    return ' · срок $when';
  }

  @override
  String get taskStatusTodo => 'к выполнению';

  @override
  String get taskStatusDoing => 'в работе';

  @override
  String get taskStatusDone => 'выполнена';

  @override
  String get taskStatusCancelled => 'отменена';

  @override
  String get taskEisenhowerTitle => 'Приоритет (матрица Эйзенхауэра)';

  @override
  String get taskChangePriority => 'Изменить приоритет';

  @override
  String get taskEisenhowerIU => 'Важно + срочно';

  @override
  String get taskEisenhowerInU => 'Важно, не срочно';

  @override
  String get taskEisenhowerIUn => 'Не важно, срочно';

  @override
  String get taskEisenhowerInUn => 'Не важно, не срочно';

  @override
  String get taskEisenhowerDo => 'Сделать';

  @override
  String get taskEisenhowerSchedule => 'Приоритет';

  @override
  String get taskEisenhowerDelegate => 'Делегировать';

  @override
  String get taskEisenhowerEliminate => 'Убрать';

  @override
  String get filesTitle => 'Файлы';

  @override
  String get noAttachmentsYet => 'Пока нет вложений';

  @override
  String fileSubtitle(String path, int bytes) {
    return '$path · $bytes Б';
  }

  @override
  String get searchTitle => 'Поиск (FTS5)';

  @override
  String get searchHint => 'Поиск по заметкам…';

  @override
  String get searchAction => 'Найти';

  @override
  String get numbersTitle => 'Номера';

  @override
  String get numbersFilterHint => 'Быстрый фильтр…';

  @override
  String get copyNumberTooltip => 'Скопировать номер';

  @override
  String get copied => 'Скопировано';

  @override
  String get numbersNewEntry => 'Новая запись';

  @override
  String get fieldNumber => 'Номер';

  @override
  String get fieldTitle => 'Название';

  @override
  String get fieldCategory => 'Категория';

  @override
  String get settingsTitle => 'Настройки';

  @override
  String get languageTitle => 'Язык';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageRussian => 'Русский';

  @override
  String get storageDirectory => 'Каталог данных';

  @override
  String get changeStoragePathTitle =>
      'Сменить путь хранения (нужен перезапуск)';

  @override
  String get changeStoragePathSubtitle =>
      'Пишет конфиг bootstrap; данные лучше скопировать вручную или сначала сделать экспорт.';

  @override
  String get pickFolder => 'Выбрать папку';

  @override
  String get restartMarsFlowTitle => 'Перезапустите MarsFlow';

  @override
  String get restartMarsFlowBody =>
      'Закройте и снова откройте приложение, чтобы использовать новый путь.';

  @override
  String get encryptNotesTitle => 'Шифровать текст новых заметок';

  @override
  String get encryptNotesSubtitle =>
      'Ключ AES в защищённом хранилище; при чтении — расшифровка с запасным вариантом.';

  @override
  String get exportSqliteTitle => 'Экспорт файла SQLite';

  @override
  String get exportedSnackbar => 'Экспорт выполнен';

  @override
  String get saveEllipsis => 'Сохранить…';

  @override
  String get exportAttachmentsTitle => 'Экспорт папки вложений';

  @override
  String get filesCopiedSnackbar => 'Файлы скопированы';

  @override
  String get chooseEllipsis => 'Выбрать…';

  @override
  String get exportZipTitle => 'Экспорт ZIP (БД + вложения)';

  @override
  String get zipCreatedSnackbar => 'Архив создан';

  @override
  String get importZipTitle => 'Импорт ZIP (полное восстановление)';

  @override
  String get importZipSubtitle =>
      'Заменяет базу и вложения. Рекомендуется перезапуск.';

  @override
  String get pickZipEllipsis => 'Выбрать ZIP…';

  @override
  String get importCompleteTitle => 'Импорт завершён';

  @override
  String get importCompleteBody =>
      'Перезапустите приложение, чтобы перечитать базу.';

  @override
  String get dialogExportDatabase => 'Экспорт базы данных';

  @override
  String get dialogSelectExportFolder => 'Папка для экспорта файлов';

  @override
  String get dialogExportZip => 'Экспорт архива ZIP';

  @override
  String get noteDeletedSnackbar => 'Заметка удалена';

  @override
  String get foldersSection => 'Папки';

  @override
  String get taskDueDateOptional => 'Срок (необязательно)';

  @override
  String get taskPickDate => 'Выбрать дату';

  @override
  String get taskClearDate => 'Без даты';

  @override
  String get taskChangeDueDate => 'Изменить срок';

  @override
  String get searchTabNotes => 'Заметки';

  @override
  String get searchTabServiceLog => 'Журнал ТО';

  @override
  String get serviceLogTitle => 'Реестр обслуживания';

  @override
  String get serviceLogSubtitle =>
      'Замена масла, ТО, ремонт — сортировка по типу или дате.';

  @override
  String get serviceSortDateNew => 'Дата: сначала новые';

  @override
  String get serviceSortDateOld => 'Дата: сначала старые';

  @override
  String get serviceSortTypeAz => 'Тип: А–Я';

  @override
  String get serviceSortTypeZa => 'Тип: Я–А';

  @override
  String get serviceAddRecord => 'Добавить запись';

  @override
  String get serviceFieldActionType => 'Тип работ (масло, ТО…)';

  @override
  String get serviceFieldTitle => 'Кратко';

  @override
  String get serviceFieldDetails => 'Подробности';

  @override
  String get serviceFieldDate => 'Дата';

  @override
  String get serviceFieldOdometer => 'Пробег, км (необязательно)';

  @override
  String get serviceNewRecord => 'Новая запись обслуживания';

  @override
  String get serviceDeleteRecord => 'Удалить запись?';

  @override
  String get serviceDeleteRecordBody => 'Запись будет удалена из журнала.';

  @override
  String get serviceLogEmpty => 'Пока нет записей. Нажмите «Добавить запись».';

  @override
  String get sortLabel => 'Сортировка';

  @override
  String get vehicleTitle => 'Автомобиль';

  @override
  String get vehicleSectionDetails => 'Данные машины';

  @override
  String get vehicleSectionService => 'Последнее по типам работ';

  @override
  String get vehicleFieldMake => 'Марка';

  @override
  String get vehicleFieldModel => 'Модель';

  @override
  String get vehicleFieldYear => 'Год';

  @override
  String get vehicleFieldVin => 'VIN';

  @override
  String get vehicleFieldPlate => 'Госномер';

  @override
  String get vehicleFieldColor => 'Цвет';

  @override
  String get vehicleFieldOdometer => 'Пробег (км)';

  @override
  String get vehicleFieldNotes => 'Заметки';

  @override
  String get vehicleSave => 'Сохранить';

  @override
  String get vehicleSavedSnackbar => 'Данные сохранены';

  @override
  String get vehicleServiceEmpty =>
      'В журнале пока нет записей. Добавьте их в разделе «Поиск» → «Журнал ТО».';

  @override
  String get vehicleOpenServiceLog => 'Открыть журнал обслуживания';

  @override
  String get aboutListTileTitle => 'О MarsFlow';

  @override
  String aboutListTileSubtitle(String version, String phase) {
    return 'Версия $version · $phase';
  }

  @override
  String get aboutPhaseAlpha => 'альфа';

  @override
  String get aboutAppBlurb =>
      'Офлайн-заметки, задачи, файлы, поиск, номера, карточка машины и журнал обслуживания — данные остаются на устройстве.';

  @override
  String get aboutDeveloperLabel => 'Разработчик';

  @override
  String get aboutDeveloperName => 'Марсель Мухамеджанов';

  @override
  String get aboutCopyright => '© MarsFlow';

  @override
  String get settingsWebDiskHint =>
      'В браузере данные хранятся в этом профиле. Полный экспорт/импорт и выбор папки доступны в настольной или мобильной версии.';
}
