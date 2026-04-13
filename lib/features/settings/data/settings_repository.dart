import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/mars_flow_database.dart';
import '../../../core/providers/core_providers.dart';

class SettingsRepository {
  SettingsRepository(this._db);

  final MarsFlowDatabase _db;

  static const _encryptionKey = 'encryption_enabled';
  static const localeKey = 'app_locale';

  Future<String> getLocaleCode() async {
    final row = await (_db.select(_db.appPrefs)..where((t) => t.key.equals(localeKey))).getSingleOrNull();
    final v = row?.value ?? 'en';
    if (v == 'ru') return 'ru';
    return 'en';
  }

  Future<void> setLocaleCode(String code) async {
    final normalized = code.startsWith('ru') ? 'ru' : 'en';
    await _db.into(_db.appPrefs).insertOnConflictUpdate(
          AppPrefsCompanion(
            key: const Value(localeKey),
            value: Value(normalized),
          ),
        );
  }

  Future<bool> encryptionEnabled() async {
    final row = await (_db.select(_db.appPrefs)..where((t) => t.key.equals(_encryptionKey))).getSingleOrNull();
    return row?.value == 'true';
  }

  Future<void> setEncryptionEnabled(bool value) async {
    await _db.into(_db.appPrefs).insertOnConflictUpdate(
          AppPrefsCompanion(
            key: const Value(_encryptionKey),
            value: Value(value.toString()),
          ),
        );
  }
}

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepository(ref.watch(databaseProvider));
});
