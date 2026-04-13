import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/shell_providers.dart';
import '../../../core/database/mars_flow_database.dart';
import '../../../core/format/note_date_format.dart';
import '../../../l10n/app_localizations.dart';
import '../../files/data/files_repository.dart';
import '../data/notes_repository.dart';
import 'note_editor.dart';
import 'notes_providers.dart';

/// Same breakpoint as [MarsFlowShell] for bottom nav vs rail.
const double kNotesNarrowBreakpoint = 720;

class NotesWorkspace extends ConsumerWidget {
  const NotesWorkspace({super.key});

  Future<void> _deleteNote(
    BuildContext context,
    WidgetRef ref,
    int noteId,
    int? selectedId,
  ) async {
    final l10n = AppLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.confirmDeleteNoteTitle),
        content: Text(l10n.confirmDeleteNoteBody),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.cancel)),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l10n.deleteAction)),
        ],
      ),
    );
    if (ok != true || !context.mounted) return;
    await ref.read(filesRepositoryProvider).deleteAttachmentsForNote(noteId);
    await ref.read(notesRepositoryProvider).deleteNote(noteId);
    if (selectedId == noteId) {
      ref.read(selectedNoteIdProvider.notifier).state = null;
    }
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.noteDeletedSnackbar)));
    }
  }

  Future<void> _deleteFolder(BuildContext context, WidgetRef ref, int folderId, int? selectedFolder) async {
    final l10n = AppLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.confirmDeleteFolderTitle),
        content: Text(l10n.confirmDeleteFolderBody),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.cancel)),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l10n.deleteAction)),
        ],
      ),
    );
    if (ok != true || !context.mounted) return;
    await ref.read(notesRepositoryProvider).deleteFolder(folderId);
    if (selectedFolder == folderId) {
      ref.read(selectedFolderIdProvider.notifier).state = null;
      ref.read(selectedNoteIdProvider.notifier).state = null;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    ref.listen<int>(createBlankNoteRequestProvider, (prev, next) async {
      if (prev == null || next <= prev) return;
      final folderId = ref.read(selectedFolderIdProvider);
      final id = await ref.read(notesRepositoryProvider).createNote(folderId: folderId);
      ref.read(selectedNoteIdProvider.notifier).state = id;
    });

    final folderId = ref.watch(selectedFolderIdProvider);
    final selectedId = ref.watch(selectedNoteIdProvider);
    final repo = ref.watch(notesRepositoryProvider);
    final folders = repo.watchFolders();
    final notes = repo.watchNotesInFolder(folderId);

    final shortcutHint = defaultTargetPlatform == TargetPlatform.macOS ? 'Cmd+N' : 'Ctrl+N';

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < kNotesNarrowBreakpoint) {
          return _NotesMobileScaffold(
            l10n: l10n,
            folderId: folderId,
            selectedId: selectedId,
            folders: folders,
            notes: notes,
            deleteNote: (ctx, id, sel) => _deleteNote(ctx, ref, id, sel),
            deleteFolder: (ctx, fid, sf) => _deleteFolder(ctx, ref, fid, sf),
          );
        }

        return Row(
          children: [
            SizedBox(
              width: 212,
              child: Material(
                color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
                child: StreamBuilder(
                  stream: folders,
                  builder: (context, snap) {
                    final list = snap.data ?? [];
                    return ListView(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      children: [
                        ExpansionTile(
                          initiallyExpanded: true,
                          maintainState: true,
                          tilePadding: const EdgeInsetsDirectional.only(start: 12, end: 4),
                          childrenPadding: EdgeInsets.zero,
                          leading: Icon(
                            Icons.folder_outlined,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          title: Text(
                            l10n.foldersSection,
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          shape: const Border(),
                          collapsedShape: const Border(),
                          children: _desktopFolderChildren(context, ref, l10n, folderId, list),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            const VerticalDivider(width: 1),
            SizedBox(
              width: 280,
              child: StreamBuilder(
                stream: notes,
                builder: (context, snap) {
                  final list = snap.data ?? [];
                  return ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (context, i) {
                      final n = list[i];
                      return ListTile(
                        title: Text(n.title.isEmpty ? l10n.untitled : n.title, maxLines: 1),
                        subtitle: Text(formatNoteListDate(context, n.updatedAt), maxLines: 1),
                        selected: selectedId == n.id,
                        onTap: () => ref.read(selectedNoteIdProvider.notifier).state = n.id,
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline, size: 20),
                          tooltip: l10n.deleteNoteTooltip,
                          onPressed: () => _deleteNote(context, ref, n.id, selectedId),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            const VerticalDivider(width: 1),
            Expanded(
              child: selectedId == null
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 48, right: 32, top: 24, bottom: 24),
                        child: Text(
                          l10n.notesEmptyState(shortcutHint),
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                    )
                  : NoteEditor(key: ValueKey(selectedId), noteId: selectedId),
            ),
          ],
        );
      },
    );
  }

  List<Widget> _desktopFolderChildren(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    int? folderId,
       List<Folder> list,
  ) {
    return [
      ListTile(
        dense: true,
        title: Text(l10n.inbox),
        selected: folderId == null,
        onTap: () {
          ref.read(selectedFolderIdProvider.notifier).state = null;
          ref.read(selectedNoteIdProvider.notifier).state = null;
        },
      ),
      for (final f in list)
        ListTile(
          dense: true,
          title: Text(f.name),
          selected: folderId == f.id,
          onTap: () {
            ref.read(selectedFolderIdProvider.notifier).state = f.id;
            ref.read(selectedNoteIdProvider.notifier).state = null;
          },
          trailing: IconButton(
            icon: const Icon(Icons.delete_outline, size: 20),
            tooltip: l10n.deleteFolderTooltip,
            onPressed: () => _deleteFolder(context, ref, f.id, folderId),
          ),
        ),
      ListTile(
        dense: true,
        leading: const Icon(Icons.create_new_folder_outlined, size: 20),
        title: Text(l10n.newFolder),
        onTap: () async {
          final name = await promptFolderName(context);
          if (name != null && name.isNotEmpty && context.mounted) {
            await ref.read(notesRepositoryProvider).createFolder(name);
          }
        },
      ),
    ];
  }
}

class _NotesMobileScaffold extends ConsumerWidget {
  const _NotesMobileScaffold({
    required this.l10n,
    required this.folderId,
    required this.selectedId,
    required this.folders,
    required this.notes,
    required this.deleteNote,
    required this.deleteFolder,
  });

  final AppLocalizations l10n;
  final int? folderId;
  final int? selectedId;
  final Stream<List<Folder>> folders;
  final Stream<List<Note>> notes;
  final Future<void> Function(BuildContext, int, int?) deleteNote;
  final Future<void> Function(BuildContext, int, int?) deleteFolder;

  void _requestNewNote(WidgetRef ref) {
    final c = ref.read(createBlankNoteRequestProvider.notifier);
    c.state = c.state + 1;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.navNotes),
        leading: selectedId != null
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => ref.read(selectedNoteIdProvider.notifier).state = null,
              )
            : Builder(
                builder: (ctx) => IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () => Scaffold.of(ctx).openDrawer(),
                ),
              ),
        actions: selectedId == null
            ? [
                IconButton(
                  icon: const Icon(Icons.add),
                  tooltip: l10n.notesNewNote,
                  onPressed: () => _requestNewNote(ref),
                ),
              ]
            : null,
      ),
      floatingActionButton: selectedId == null
          ? FloatingActionButton(
              onPressed: () => _requestNewNote(ref),
              tooltip: l10n.notesNewNote,
              child: const Icon(Icons.add),
            )
          : null,
      drawer: Drawer(
        child: SafeArea(
          child: StreamBuilder<List<Folder>>(
            stream: folders,
            builder: (context, snap) {
              final list = snap.data ?? [];
              return ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                    child: Text(
                      l10n.foldersSection,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.inbox_outlined),
                    title: Text(l10n.inbox),
                    selected: folderId == null,
                    onTap: () {
                      ref.read(selectedFolderIdProvider.notifier).state = null;
                      ref.read(selectedNoteIdProvider.notifier).state = null;
                      Navigator.pop(context);
                    },
                  ),
                  for (final f in list)
                    ListTile(
                      leading: const Icon(Icons.folder_outlined),
                      title: Text(f.name),
                      selected: folderId == f.id,
                      onTap: () {
                        ref.read(selectedFolderIdProvider.notifier).state = f.id;
                        ref.read(selectedNoteIdProvider.notifier).state = null;
                        Navigator.pop(context);
                      },
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline, size: 20),
                        tooltip: l10n.deleteFolderTooltip,
                        onPressed: () => deleteFolder(context, f.id, folderId),
                      ),
                    ),
                  ListTile(
                    leading: const Icon(Icons.create_new_folder_outlined),
                    title: Text(l10n.newFolder),
                    onTap: () async {
                      Navigator.pop(context);
                      final name = await promptFolderName(context);
                      if (name != null && name.isNotEmpty && context.mounted) {
                        await ref.read(notesRepositoryProvider).createFolder(name);
                      }
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
      body: selectedId == null
          ? StreamBuilder<List<Note>>(
              stream: notes,
              builder: (context, snap) {
                final list = snap.data ?? [];
                if (list.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            l10n.notesEmptyStateMobile,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const SizedBox(height: 20),
                          FilledButton.icon(
                            onPressed: () => _requestNewNote(ref),
                            icon: const Icon(Icons.note_add_outlined),
                            label: Text(l10n.notesNewNote),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, i) {
                    final n = list[i];
                    return ListTile(
                      title: Text(n.title.isEmpty ? l10n.untitled : n.title, maxLines: 1),
                      subtitle: Text(formatNoteListDate(context, n.updatedAt), maxLines: 1),
                      onTap: () => ref.read(selectedNoteIdProvider.notifier).state = n.id,
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline, size: 20),
                        tooltip: l10n.deleteNoteTooltip,
                        onPressed: () => deleteNote(context, n.id, selectedId),
                      ),
                    );
                  },
                );
              },
            )
          : NoteEditor(key: ValueKey(selectedId), noteId: selectedId!),
    );
  }
}

Future<String?> promptFolderName(BuildContext context) async {
  final l10n = AppLocalizations.of(context);
  final c = TextEditingController();
  return showDialog<String>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(l10n.dialogFolderTitle),
      content: TextField(controller: c, autofocus: true, decoration: InputDecoration(hintText: l10n.hintName)),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l10n.cancel)),
        FilledButton(onPressed: () => Navigator.pop(ctx, c.text.trim()), child: Text(l10n.create)),
      ],
    ),
  );
}
