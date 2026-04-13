import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/mars_flow_app.dart';
import 'core/database/mars_flow_connection.dart';
import 'core/database/mars_flow_database.dart';
import 'core/locale/app_locale_provider.dart';
import 'core/providers/core_providers.dart';
import 'core/storage/storage_bootstrap.dart';
import 'features/settings/data/settings_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final root = await StorageBootstrap.resolve();
  final db = MarsFlowDatabase(openMarsFlowConnection(explicitDirectory: root));
  final settings = SettingsRepository(db);
  final localeCode = await settings.getLocaleCode();
  final initialLocale = localeCode == 'ru' ? const Locale('ru') : const Locale('en');

  runApp(
    ProviderScope(
      overrides: [
        storageRootProvider.overrideWithValue(root),
        databaseProvider.overrideWithValue(db),
        appLocaleNotifierProvider.overrideWith((ref) => AppLocaleNotifier(initialLocale)),
      ],
      child: const MarsFlowApp(),
    ),
  );
}
