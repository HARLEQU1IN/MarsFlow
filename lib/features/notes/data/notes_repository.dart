import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/mars_flow_database.dart';
import '../../../core/providers/core_providers.dart';
import '../../settings/data/settings_repository.dart';
import '../../../core/encryption/note_crypto.dart';

class NotesRepository {
  NotesRepository(this._db, this._crypto, this._settings);

  final MarsFlowDatabase _db;
  final NoteCrypto _crypto;
  final SettingsRepository _settings;

  Stream<List<Note>> watchNotesInFolder(int? folderId) {
    final q = _db.select(_db.notes)
      ..where((n) {
        if (folderId == null) {
          return n.folderId.isNull() & n.isArchived.equals(false);
        }
        return n.folderId.equals(folderId) & n.isArchived.equals(false);
      })
      ..orderBy([(n) => OrderingTerm.desc(n.updatedAt)]);
    return q.watch();
  }

  Stream<List<Folder>> watchFolders() {
    return (_db.select(_db.folders)..orderBy([(f) => OrderingTerm(expression: f.sortOrder)])).watch();
  }

  Future<int> createNote({int? folderId, String title = ''}) async {
    final now = DateTime.now();
    final enc = await _crypto.encryptIfEnabled('', enabled: await _settings.encryptionEnabled());
    return _db.into(_db.notes).insert(
          NotesCompanion.insert(
            title: Value(title),
            content: Value(enc),
            folderId: Value(folderId),
            createdAt: Value(now),
            updatedAt: Value(now),
          ),
        );
  }

  Future<void> saveNoteContent(int id, String title, String plainContent) async {
    final enc = await _crypto.encryptIfEnabled(plainContent, enabled: await _settings.encryptionEnabled());
    await (_db.update(_db.notes)..where((n) => n.id.equals(id))).write(
          NotesCompanion(
            title: Value(title),
            content: Value(enc),
            updatedAt: Value(DateTime.now()),
          ),
        );
  }

  Future<String> readDecryptedContent(Note row) async {
    return _crypto.decryptIfNeeded(row.content);
  }

  Future<void> deleteNote(int id) async {
    await (_db.delete(_db.notes)..where((n) => n.id.equals(id))).go();
  }

  Future<Note?> getById(int id) {
    return (_db.select(_db.notes)..where((n) => n.id.equals(id))).getSingleOrNull();
  }

  Future<int> createFolder(String name, {int? parentId}) {
    final now = DateTime.now();
    return _db.into(_db.folders).insert(
          FoldersCompanion.insert(
            name: name,
            parentId: Value(parentId),
            createdAt: Value(now),
            updatedAt: Value(now),
          ),
        );
  }

  Future<void> attachTag(int noteId, int tagId) async {
    await _db.into(_db.noteTags).insert(
          NoteTagsCompanion.insert(noteId: noteId, tagId: tagId),
          mode: InsertMode.insertOrIgnore,
        );
  }

  Future<void> detachTag(int noteId, int tagId) async {
    await (_db.delete(_db.noteTags)
          ..where((t) => t.noteId.equals(noteId) & t.tagId.equals(tagId)))
        .go();
  }

  Stream<List<Tag>> watchTagsForNote(int noteId) {
    final query = _db.select(_db.tags).join([
      innerJoin(_db.noteTags, _db.noteTags.tagId.equalsExp(_db.tags.id)),
    ])..where(_db.noteTags.noteId.equals(noteId));
    return query.map((row) => row.readTable(_db.tags)).watch();
  }

  Future<List<Tag>> allTags() => _db.select(_db.tags).get();

  Future<int> ensureTag(String name) async {
    final existing = await (_db.select(_db.tags)..where((t) => t.name.equals(name))).getSingleOrNull();
    if (existing != null) return existing.id;
    return _db.into(_db.tags).insert(TagsCompanion.insert(name: name));
  }

  /// Notes in this folder move to inbox (`folder_id` NULL) via FK `ON DELETE SET NULL`.
  Future<void> deleteFolder(int id) async {
    await (_db.delete(_db.folders)..where((f) => f.id.equals(id))).go();
  }
}

final notesRepositoryProvider = Provider<NotesRepository>((ref) {
  return NotesRepository(
    ref.watch(databaseProvider),
    ref.watch(noteCryptoProvider),
    ref.watch(settingsRepositoryProvider),
  );
});
