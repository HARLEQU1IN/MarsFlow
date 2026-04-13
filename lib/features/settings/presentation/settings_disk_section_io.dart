import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/core_providers.dart';
import '../../../core/storage/storage_bootstrap.dart';
import '../../../l10n/app_localizations.dart';

class SettingsDiskSection extends ConsumerWidget {
  const SettingsDiskSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final root = ref.watch(storageRootProvider);
    final theme = Theme.of(context);

    Widget titledAction({
      required String title,
      String? subtitle,
      required Widget action,
    }) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(title, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
            if (subtitle != null) ...[
              const SizedBox(height: 6),
              Text(subtitle, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
            ],
            const SizedBox(height: 10),
            action,
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ListTile(
          title: Text(l10n.storageDirectory),
          subtitle: SelectableText(root, style: theme.textTheme.bodySmall),
        ),
        const Divider(height: 1),
        titledAction(
          title: l10n.changeStoragePathTitle,
          subtitle: l10n.changeStoragePathSubtitle,
          action: Align(
            alignment: Alignment.centerLeft,
            child: FilledButton(
              onPressed: () async {
                final dir = await FilePicker.platform.getDirectoryPath();
                if (dir != null && context.mounted) {
                  await StorageBootstrap.writeStorageRoot(dir);
                  if (context.mounted) {
                    await showDialog<void>(
                      context: context,
                      builder: (ctx) {
                        final d = AppLocalizations.of(ctx);
                        return AlertDialog(
                          title: Text(d.restartMarsFlowTitle),
                          content: Text(d.restartMarsFlowBody),
                          actions: [
                            FilledButton(onPressed: () => Navigator.pop(ctx), child: Text(d.ok)),
                          ],
                        );
                      },
                    );
                  }
                }
              },
              child: Text(l10n.pickFolder),
            ),
          ),
        ),
        const Divider(height: 1),
        titledAction(
          title: l10n.exportSqliteTitle,
          action: Align(
            alignment: Alignment.centerLeft,
            child: FilledButton(
              onPressed: () async {
                final path = await FilePicker.platform.saveFile(
                  dialogTitle: l10n.dialogExportDatabase,
                  fileName: 'mars_flow.sqlite',
                );
                if (path != null && context.mounted) {
                  await ref.read(backupServiceProvider).exportDatabaseCopy(File(path));
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.exportedSnackbar)));
                  }
                }
              },
              child: Text(l10n.saveEllipsis),
            ),
          ),
        ),
        const Divider(height: 1),
        titledAction(
          title: l10n.exportAttachmentsTitle,
          action: Align(
            alignment: Alignment.centerLeft,
            child: FilledButton(
              onPressed: () async {
                final dir = await FilePicker.platform.getDirectoryPath(dialogTitle: l10n.dialogSelectExportFolder);
                if (dir != null && context.mounted) {
                  await ref.read(backupServiceProvider).exportFilesFolder(Directory(dir));
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.filesCopiedSnackbar)));
                  }
                }
              },
              child: Text(l10n.chooseEllipsis),
            ),
          ),
        ),
        const Divider(height: 1),
        titledAction(
          title: l10n.exportZipTitle,
          action: Align(
            alignment: Alignment.centerLeft,
            child: FilledButton(
              onPressed: () async {
                final path = await FilePicker.platform.saveFile(
                  dialogTitle: l10n.dialogExportZip,
                  fileName: 'marsflow_backup.zip',
                );
                if (path != null && context.mounted) {
                  await ref.read(backupServiceProvider).exportZip(File(path));
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.zipCreatedSnackbar)));
                  }
                }
              },
              child: Text(l10n.saveEllipsis),
            ),
          ),
        ),
        const Divider(height: 1),
        titledAction(
          title: l10n.importZipTitle,
          subtitle: l10n.importZipSubtitle,
          action: Align(
            alignment: Alignment.centerLeft,
            child: FilledButton(
              onPressed: () async {
                final pick = await FilePicker.platform.pickFiles();
                if (pick != null && pick.files.single.path != null && context.mounted) {
                  await ref.read(backupServiceProvider).importFromZip(File(pick.files.single.path!));
                  if (context.mounted) {
                    await showDialog<void>(
                      context: context,
                      builder: (ctx) {
                        final d = AppLocalizations.of(ctx);
                        return AlertDialog(
                          title: Text(d.importCompleteTitle),
                          content: Text(d.importCompleteBody),
                          actions: [
                            FilledButton(onPressed: () => Navigator.pop(ctx), child: Text(d.ok)),
                          ],
                        );
                      },
                    );
                  }
                }
              },
              child: Text(l10n.pickZipEllipsis),
            ),
          ),
        ),
        const Divider(height: 1),
      ],
    );
  }
}
