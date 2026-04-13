import 'package:drift/drift.dart';

part 'mars_flow_database.g.dart';

/// Application key-value preferences (storage paths, flags).
@DataClassName('AppPrefRow')
class AppPrefs extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column<Object>>? get primaryKey => {key};
}

class Folders extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  IntColumn get parentId => integer().nullable().references(Folders, #id, onDelete: KeyAction.setNull)();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
}

@TableIndex(name: 'idx_notes_folder', columns: {#folderId})
@TableIndex(name: 'idx_notes_updated', columns: {#updatedAt})
class Notes extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get folderId => integer().nullable().references(Folders, #id, onDelete: KeyAction.setNull)();
  TextColumn get title => text().withDefault(const Constant(''))();
  TextColumn get content => text().withDefault(const Constant(''))();
  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

class Tags extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().unique()();
  TextColumn get colorHex => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

@TableIndex(name: 'idx_note_tags_tag', columns: {#tagId})
class NoteTags extends Table {
  IntColumn get noteId => integer().references(Notes, #id, onDelete: KeyAction.cascade)();
  IntColumn get tagId => integer().references(Tags, #id, onDelete: KeyAction.cascade)();

  @override
  Set<Column<Object>>? get primaryKey => {noteId, tagId};
}

@TableIndex(name: 'idx_stored_files_note', columns: {#noteId})
class StoredFiles extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get noteId => integer().nullable().references(Notes, #id, onDelete: KeyAction.setNull)();
  TextColumn get localRelativePath => text()();
  TextColumn get originalName => text()();
  TextColumn get mimeType => text().nullable()();
  IntColumn get sizeBytes => integer().withDefault(const Constant(0))();
  /// Web / pick-without-path: file bytes; native attachments use [localRelativePath] on disk.
  BlobColumn get inlineBytes => blob().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

/// Task workflow: [todo], [doing], [done], [cancelled].
@TableIndex(name: 'idx_tasks_note', columns: {#linkedNoteId})
@TableIndex(name: 'idx_tasks_due', columns: {#dueAt})
class Tasks extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get description => text().withDefault(const Constant(''))();
  TextColumn get status => text().withDefault(const Constant('todo'))();
  IntColumn get priority => integer().withDefault(const Constant(1))();
  DateTimeColumn get dueAt => dateTime().nullable()();
  IntColumn get linkedNoteId => integer().nullable().references(Notes, #id, onDelete: KeyAction.setNull)();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
}

@TableIndex(name: 'idx_numbers_category', columns: {#category})
@TableIndex(name: 'idx_numbers_number', columns: {#number})
class NumbersDirectory extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get number => text()();
  TextColumn get title => text().withDefault(const Constant(''))();
  TextColumn get category => text().withDefault(const Constant(''))();
  TextColumn get notes => text().withDefault(const Constant(''))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

/// Registry of vehicle / machine maintenance (ТО, oil change, etc.).
@TableIndex(name: 'idx_service_performed', columns: {#performedAt})
@TableIndex(name: 'idx_service_action_type', columns: {#actionType})
class ServiceRecords extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get actionType => text().withDefault(const Constant(''))();
  TextColumn get title => text().withDefault(const Constant(''))();
  TextColumn get details => text().withDefault(const Constant(''))();
  DateTimeColumn get performedAt => dateTime().withDefault(currentDateAndTime)();
  IntColumn get odometerKm => integer().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

/// Single-row profile (id is always 1) for the vehicle / machine the app tracks.
class VehicleProfiles extends Table {
  IntColumn get id => integer()();
  TextColumn get make => text().withDefault(const Constant(''))();
  TextColumn get model => text().withDefault(const Constant(''))();
  TextColumn get year => text().withDefault(const Constant(''))();
  TextColumn get vin => text().withDefault(const Constant(''))();
  TextColumn get plate => text().withDefault(const Constant(''))();
  TextColumn get color => text().withDefault(const Constant(''))();
  IntColumn get odometerKm => integer().nullable()();
  TextColumn get notes => text().withDefault(const Constant(''))();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column<Object>>? get primaryKey => {id};
}

@DriftDatabase(
  tables: [
    AppPrefs,
    Folders,
    Notes,
    Tags,
    NoteTags,
    StoredFiles,
    Tasks,
    NumbersDirectory,
    ServiceRecords,
    VehicleProfiles,
  ],
)
class MarsFlowDatabase extends _$MarsFlowDatabase {
  MarsFlowDatabase(super.e);

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
          await customStatement('PRAGMA foreign_keys = ON;');
          await _createFts5();
        },
        onUpgrade: (Migrator m, int from, int to) async {
          if (from < 2) {
            await m.createTable(serviceRecords);
          }
          if (from < 3) {
            await m.createTable(vehicleProfiles);
            await into(vehicleProfiles).insert(
              VehicleProfilesCompanion.insert(id: const Value(1)),
            );
          }
          if (from < 4) {
            await m.addColumn(storedFiles, storedFiles.inlineBytes);
          }
        },
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON;');
        },
      );

  Future<void> _createFts5() async {
    await customStatement('''
CREATE VIRTUAL TABLE IF NOT EXISTS notes_fts USING fts5(
  title,
  content,
  content='notes',
  content_rowid='id'
);
''');
    await customStatement("INSERT INTO notes_fts(notes_fts) VALUES('rebuild');");
    await customStatement('''
CREATE TRIGGER IF NOT EXISTS notes_ai AFTER INSERT ON notes BEGIN
  INSERT INTO notes_fts(rowid, title, content) VALUES (new.id, new.title, new.content);
END;
''');
    await customStatement('''
CREATE TRIGGER IF NOT EXISTS notes_ad AFTER DELETE ON notes BEGIN
  INSERT INTO notes_fts(notes_fts, rowid, title, content) VALUES('delete', old.id, old.title, old.content);
END;
''');
    await customStatement('''
CREATE TRIGGER IF NOT EXISTS notes_au AFTER UPDATE ON notes BEGIN
  INSERT INTO notes_fts(notes_fts, rowid, title, content) VALUES('delete', old.id, old.title, old.content);
  INSERT INTO notes_fts(rowid, title, content) VALUES (new.id, new.title, new.content);
END;
''');
  }

  /// Raw FTS5 query; returns note ids ordered by rank.
  Future<List<int>> searchNotesFts(String query, {int limit = 200}) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return [];
    final rows = await customSelect(
      '''
SELECT rowid AS id FROM notes_fts
WHERE notes_fts MATCH ?
ORDER BY bm25(notes_fts)
LIMIT ?
''',
      variables: [Variable(trimmed), Variable(limit)],
      readsFrom: {notes},
    ).get();
    return rows.map((r) => r.read<int>('id')).toList();
  }
}
