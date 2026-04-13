import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';

/// Binary files live under `[storageRoot]/attachments/…`.
class AttachmentStorage {
  AttachmentStorage({required this.storageRoot, Uuid? uuid}) : _uuid = uuid ?? const Uuid();

  final String storageRoot;
  final Uuid _uuid;

  Directory get _root => Directory(p.join(storageRoot, 'attachments'));

  Future<Directory> ensureReady() async {
    if (!await _root.exists()) {
      await _root.create(recursive: true);
    }
    return _root;
  }

  /// Copies [source] into attachments; returns relative path from [storageRoot].
  Future<String> ingestFile(File source, {String? originalName}) async {
    await ensureReady();
    final ext = p.extension(originalName ?? source.path);
    final name = '${_uuid.v4()}$ext';
    final dest = File(p.join(_root.path, name));
    await source.copy(dest.path);
    return p.join('attachments', name);
  }

  File resolveRelative(String relativePath) => File(p.join(storageRoot, relativePath));

  Future<void> deleteRelative(String relativePath) async {
    final f = resolveRelative(relativePath);
    if (await f.exists()) {
      await f.delete();
    }
  }
}
