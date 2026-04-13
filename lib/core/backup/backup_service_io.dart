import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:path/path.dart' as p;

/// Export / import the SQLite file and `attachments/` tree (offline, no cloud).
class BackupService {
  BackupService({required this.storageRoot});

  final String storageRoot;

  File get databaseFile => File(p.join(storageRoot, 'mars_flow.sqlite'));

  Directory get attachmentsDir => Directory(p.join(storageRoot, 'attachments'));

  Future<void> exportDatabaseCopy(File destination) async {
    if (!await databaseFile.exists()) {
      throw StateError('Database missing at ${databaseFile.path}');
    }
    await databaseFile.copy(destination.path);
  }

  Future<void> exportFilesFolder(Directory destination) async {
    if (!await attachmentsDir.exists()) {
      await destination.create(recursive: true);
      return;
    }
    await _copyTree(attachmentsDir, destination);
  }

  Future<void> exportZip(File zipFile) async {
    final encoder = ZipFileEncoder()..create(zipFile.path);
    if (await databaseFile.exists()) {
      await encoder.addFile(databaseFile, 'mars_flow.sqlite');
    }
    if (await attachmentsDir.exists()) {
      await encoder.addDirectory(attachmentsDir, includeDirName: true);
    }
    await encoder.close();
  }

  Future<void> importFullRestore({required File sqlite, Directory? files}) async {
    if (await databaseFile.exists()) {
      await databaseFile.delete();
    }
    await sqlite.copy(databaseFile.path);
    if (files != null && await files.exists()) {
      if (await attachmentsDir.exists()) {
        await attachmentsDir.delete(recursive: true);
      }
      await attachmentsDir.create(recursive: true);
      await _copyTree(files, attachmentsDir);
    }
  }

  Future<void> importFromZip(File zipFile) async {
    final bytes = await zipFile.readAsBytes();
    final archive = ZipDecoder().decodeBytes(bytes);
    var foundDb = false;
    final pendingFiles = <String, List<int>>{};
    for (final f in archive.files) {
      if (!f.isFile) continue;
      final name = f.name.replaceAll('\\', '/');
      if (name == 'mars_flow.sqlite' || name.endsWith('/mars_flow.sqlite')) {
        await databaseFile.parent.create(recursive: true);
        await databaseFile.writeAsBytes(f.content);
        foundDb = true;
      } else if (name.startsWith('attachments/')) {
        pendingFiles[name] = f.content;
      }
    }
    if (!foundDb) {
      throw StateError('Archive missing mars_flow.sqlite');
    }
    if (pendingFiles.isNotEmpty) {
      if (await attachmentsDir.exists()) {
        await attachmentsDir.delete(recursive: true);
      }
      await attachmentsDir.create(recursive: true);
      for (final e in pendingFiles.entries) {
        final rel = e.key.substring('attachments/'.length);
        final out = File(p.join(attachmentsDir.path, rel));
        await out.parent.create(recursive: true);
        await out.writeAsBytes(e.value);
      }
    }
  }

  Future<void> _copyTree(Directory from, Directory to) async {
    await for (final entity in from.list(recursive: true)) {
      if (entity is! File) continue;
      final rel = p.relative(entity.path, from: from.path);
      final dest = File(p.join(to.path, rel));
      await dest.parent.create(recursive: true);
      await dest.writeAsBytes(await entity.readAsBytes());
    }
  }
}
