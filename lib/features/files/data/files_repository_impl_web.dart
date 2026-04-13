import 'package:cross_file/cross_file.dart';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/mars_flow_database.dart';
import '../../../core/providers/core_providers.dart';

class FilesRepository {
  FilesRepository(this._db);

  final MarsFlowDatabase _db;

  Stream<List<StoredFile>> watchForNote(int noteId) {
    return (_db.select(_db.storedFiles)
          ..where((f) => f.noteId.equals(noteId))
          ..orderBy([(f) => OrderingTerm.desc(f.createdAt)]))
        .watch();
  }

  Stream<List<StoredFile>> watchAll() {
    return (_db.select(_db.storedFiles)..orderBy([(f) => OrderingTerm.desc(f.createdAt)])).watch();
  }

  Future<void> attachXFileToNote(int noteId, XFile xf, {String? displayName}) async {
    final bytes = await xf.readAsBytes();
    final name = displayName ?? xf.name;
    await _db.into(_db.storedFiles).insert(
          StoredFilesCompanion.insert(
            noteId: Value(noteId),
            localRelativePath: '',
            originalName: name,
            mimeType: const Value(null),
            sizeBytes: Value(bytes.length),
            inlineBytes: Value(Uint8List.fromList(bytes)),
          ),
        );
  }

  Future<void> deleteAttachment(int id) async {
    await (_db.delete(_db.storedFiles)..where((f) => f.id.equals(id))).go();
  }

  Future<void> deleteAttachmentsForNote(int noteId) async {
    final rows = await (_db.select(_db.storedFiles)..where((f) => f.noteId.equals(noteId))).get();
    for (final r in rows) {
      await deleteAttachment(r.id);
    }
  }
}

final filesRepositoryProvider = Provider<FilesRepository>((ref) {
  return FilesRepository(ref.watch(databaseProvider));
});
