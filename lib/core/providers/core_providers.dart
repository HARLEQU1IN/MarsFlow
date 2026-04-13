import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/mars_flow_database.dart';
import '../storage/attachment_storage.dart';
import '../backup/backup_service.dart';
import '../encryption/note_crypto.dart';

/// Resolved storage directory (`mars_flow.sqlite` lives here).
final storageRootProvider = Provider<String>((ref) {
  throw UnimplementedError('Override storageRootProvider in ProviderScope');
});

final databaseProvider = Provider<MarsFlowDatabase>((ref) {
  throw UnimplementedError('Override databaseProvider in ProviderScope');
});

final attachmentStorageProvider = Provider<AttachmentStorage>((ref) {
  return AttachmentStorage(storageRoot: ref.watch(storageRootProvider));
});

final backupServiceProvider = Provider<BackupService>((ref) {
  return BackupService(storageRoot: ref.watch(storageRootProvider));
});

final noteCryptoProvider = Provider<NoteCrypto>((ref) => NoteCrypto());
