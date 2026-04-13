import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/locale/app_locale_provider.dart';
import '../core/theme/app_theme.dart';
import '../l10n/app_localizations.dart';
import 'mars_flow_shell.dart';

class MarsFlowApp extends ConsumerWidget {
  const MarsFlowApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(appLocaleNotifierProvider);

    return MaterialApp(
      onGenerateTitle: (ctx) => AppLocalizations.of(ctx).appTitle,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark(),
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const MarsFlowShell(),
    );
  }
}
