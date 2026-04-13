import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/settings/data/settings_repository.dart';

class AppLocaleNotifier extends StateNotifier<Locale> {
  AppLocaleNotifier(super.initial);

  Future<void> setLocale(Locale locale, SettingsRepository settings) async {
    state = locale;
    await settings.setLocaleCode(locale.languageCode);
  }
}

/// Initial value is set via [ProviderScope] override in `main.dart`.
final appLocaleNotifierProvider = StateNotifierProvider<AppLocaleNotifier, Locale>((ref) {
  throw UnimplementedError('appLocaleNotifierProvider must be overridden in ProviderScope');
});
