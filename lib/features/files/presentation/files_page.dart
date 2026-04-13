import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_localizations.dart';
import '../data/files_repository.dart';

class FilesPage extends ConsumerWidget {
  const FilesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final stream = ref.watch(filesRepositoryProvider).watchAll();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.filesTitle, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text(
            l10n.filesScreenDescription,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: StreamBuilder(
              stream: stream,
              builder: (context, snap) {
                final list = snap.data ?? [];
                if (list.isEmpty) return Center(child: Text(l10n.noAttachmentsYet));
                return ListView.separated(
                  itemCount: list.length,
                  separatorBuilder: (context, index) => const Divider(height: 1),
                  itemBuilder: (context, i) {
                    final f = list[i];
                    return ListTile(
                      title: Text(f.originalName),
                      subtitle: Text(
                        l10n.fileSubtitle(
                          f.localRelativePath.isEmpty ? '—' : f.localRelativePath,
                          f.sizeBytes,
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () => ref.read(filesRepositoryProvider).deleteAttachment(f.id),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
