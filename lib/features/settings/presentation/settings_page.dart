import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/app_meta.dart';
import '../../../core/locale/app_locale_provider.dart';
import '../../../l10n/app_localizations.dart';
import '../data/settings_repository.dart';
import 'settings_disk_section.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final enc = ref.watch(_encryptionEnabledProvider);
    final locale = ref.watch(appLocaleNotifierProvider);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          Text(l10n.settingsTitle, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 24),
          Text(l10n.languageTitle, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: SegmentedButton<Locale>(
              segments: [
                ButtonSegment(value: const Locale('en'), label: Text(l10n.languageEnglish)),
                ButtonSegment(value: const Locale('ru'), label: Text(l10n.languageRussian)),
              ],
              selected: {locale},
              onSelectionChanged: (s) async {
                final loc = s.first;
                await ref.read(appLocaleNotifierProvider.notifier).setLocale(
                      loc,
                      ref.read(settingsRepositoryProvider),
                    );
              },
            ),
          ),
          const SizedBox(height: 24),
          const Divider(),
          const SettingsDiskSection(),
          SwitchListTile(
            title: Text(l10n.encryptNotesTitle),
            subtitle: Text(l10n.encryptNotesSubtitle),
            value: enc.asData?.value ?? false,
            onChanged: (v) async {
              await ref.read(settingsRepositoryProvider).setEncryptionEnabled(v);
              ref.invalidate(_encryptionEnabledProvider);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(l10n.aboutListTileTitle),
            subtitle: Text(
              l10n.aboutListTileSubtitle(kAppDisplayVersion, l10n.aboutPhaseAlpha),
            ),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: l10n.appTitle,
                applicationVersion: '$kAppDisplayVersion · ${l10n.aboutPhaseAlpha}',
                applicationLegalese: l10n.aboutCopyright,
                children: [
                  const SizedBox(height: 16),
                  Text(l10n.aboutAppBlurb),
                  const SizedBox(height: 20),
                  Text('${l10n.aboutDeveloperLabel}: ${l10n.aboutDeveloperName}'),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

final _encryptionEnabledProvider = FutureProvider<bool>((ref) {
  return ref.watch(settingsRepositoryProvider).encryptionEnabled();
});
