import 'dart:io';

import 'package:cross_file/cross_file.dart';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/mars_flow_database.dart';
import '../../../core/providers/core_providers.dart';
import '../../../core/storage/attachment_storage.dart';

class FilesRepository {
  FilesRepository(this._db, this._storage);

  final MarsFlowDatabase _db;
  final AttachmentStorage _storage;

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
    final name = displayName ?? xf.name;
    if (xf.path.isNotEmpty) {
      final source = File(xf.path);
      final rel = await _storage.ingestFile(source, originalName: name);
      final stat = await source.stat();
      await _db.into(_db.storedFiles).insert(
            StoredFilesCompanion.insert(
              noteId: Value(noteId),
              localRelativePath: rel,
              originalName: name,
              mimeType: const Value(null),
              sizeBytes: Value(stat.size),
            ),
          );
      return;
    }
    final bytes = await xf.readAsBytes();
    await _insertInline(noteId, bytes, name);
  }

  Future<void> _insertInline(int noteId, List<int> bytes, String name) async {
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
    final row = await (_db.select(_db.storedFiles)..where((f) => f.id.equals(id))).getSingleOrNull();
    if (row == null) return;
    if (row.inlineBytes == null && row.localRelativePath.isNotEmpty) {
      await _storage.deleteRelative(row.localRelativePath);
    }
    await (_db.delete(_db.storedFiles)..where((f) => f.id.equals(id))).go();
  }

  Future<void> deleteAttachmentsForNote(int noteId) async {
    final rows = await (_db.select(_db.storedFiles)..where((f) => f.noteId.equals(noteId))).get();
    for (final r in rows) {
      await deleteAttachment(r.id);
    }
  }

  File? resolveFile(StoredFile row) {
    if (row.inlineBytes != null) return null;
    if (row.localRelativePath.isEmpty) return null;
    return _storage.resolveRelative(row.localRelativePath);
  }
}

final filesRepositoryProvider = Provider<FilesRepository>((ref) {
  return FilesRepository(
    ref.watch(databaseProvider),
    ref.watch(attachmentStorageProvider),
  );
});
