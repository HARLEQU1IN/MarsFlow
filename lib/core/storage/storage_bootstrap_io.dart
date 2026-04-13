import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Persisted **before** SQLite opens so the storage root can be user-configurable.
class StorageBootstrap {
  static const _fileName = 'storage_bootstrap.json';

  static Future<File> _bootstrapFile() async {
    final support = await getApplicationSupportDirectory();
    final dir = Directory(p.join(support.path, 'MarsFlow'));
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return File(p.join(dir.path, _fileName));
  }

  /// Effective directory that will contain `mars_flow.sqlite` and `attachments/`.
  static Future<String> resolve() async {
    final file = await _bootstrapFile();
    if (await file.exists()) {
      try {
        final map = jsonDecode(await file.readAsString()) as Map<String, dynamic>;
        final root = map['storageRoot'] as String?;
        if (root != null && root.trim().isNotEmpty) {
          final d = Directory(root.trim());
          if (!await d.exists()) {
            await d.create(recursive: true);
          }
          return d.path;
        }
      } catch (_) {
        // fall through to default
      }
    }
    final doc = await getApplicationDocumentsDirectory();
    final root = Directory(p.join(doc.path, 'MarsFlow'));
    if (!await root.exists()) {
      await root.create(recursive: true);
    }
    return root.path;
  }

  static Future<void> writeStorageRoot(String absolutePath) async {
    final file = await _bootstrapFile();
    await file.writeAsString(jsonEncode({'storageRoot': absolutePath}));
  }
}
