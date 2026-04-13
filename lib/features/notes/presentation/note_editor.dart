import 'dart:async';
import 'package:cross_file/cross_file.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/shell_providers.dart';
import '../../../l10n/app_localizations.dart';
import '../../files/data/files_repository.dart';
import '../data/notes_repository.dart';
import 'notes_providers.dart';

class NoteEditor extends ConsumerStatefulWidget {
  const NoteEditor({super.key, required this.noteId});

  final int noteId;

  @override
  ConsumerState<NoteEditor> createState() => _NoteEditorState();
}

class _NoteEditorState extends ConsumerState<NoteEditor> {
  late final TextEditingController _title;
  late final TextEditingController _body;
  Timer? _debounce;
  ProviderSubscription<int>? _saveSub;

  static bool get _dropEnabled =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.macOS ||
          defaultTargetPlatform == TargetPlatform.windows ||
          defaultTargetPlatform == TargetPlatform.linux);

  @override
  void initState() {
    super.initState();
    _title = TextEditingController();
    _body = TextEditingController();
    _saveSub = ref.listenManual<int>(saveCurrentNoteRequestProvider, (prev, next) {
      if (prev != null && next > prev) {
        unawaited(_save());
      }
    });
    _title.addListener(_scheduleSave);
    _body.addListener(_scheduleSave);
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    final row = await ref.read(notesRepositoryProvider).getById(widget.noteId);
    if (!mounted || row == null) return;
    final plain = await ref.read(notesRepositoryProvider).readDecryptedContent(row);
    _title.text = row.title;
    _body.text = plain;
  }

  void _scheduleSave() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 600), () {
      unawaited(_save());
    });
  }

  Future<void> _save() async {
    await ref.read(notesRepositoryProvider).saveNoteContent(widget.noteId, _title.text, _body.text);
  }

  Future<void> _attachPaths(List<XFile> files) async {
    for (final xf in files) {
      await ref.read(filesRepositoryProvider).attachXFileToNote(widget.noteId, xf);
    }
    if (mounted) setState(() {});
  }

  Future<void> _pickFiles({required FileType type}) async {
    final r = await FilePicker.platform.pickFiles(type: type, allowMultiple: true);
    if (r == null || !mounted) return;
    final files = <XFile>[];
    for (final f in r.files) {
      final p = f.path;
      if (p != null && p.isNotEmpty) {
        files.add(XFile(p));
      } else if (f.bytes != null) {
        files.add(XFile.fromData(f.bytes!, name: f.name));
      }
    }
    if (files.isNotEmpty) await _attachPaths(files);
  }

  Future<void> _confirmDelete() async {
    final l10n = AppLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.confirmDeleteNoteTitle),
        content: Text(l10n.confirmDeleteNoteBody),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.cancel)),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.deleteAction),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    await ref.read(filesRepositoryProvider).deleteAttachmentsForNote(widget.noteId);
    await ref.read(notesRepositoryProvider).deleteNote(widget.noteId);
    ref.read(selectedNoteIdProvider.notifier).state = null;
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.noteDeletedSnackbar)));
    }
  }

  @override
  void dispose() {
    _saveSub?.close();
    _debounce?.cancel();
    _title.dispose();
    _body.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final attachments = ref.watch(filesRepositoryProvider).watchForNote(widget.noteId);

    Widget editor = Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _title,
                  style: Theme.of(context).textTheme.headlineSmall,
                  decoration: InputDecoration(
                    hintText: l10n.noteTitleHint,
                    border: InputBorder.none,
                  ),
                ),
              ),
              IconButton(
                tooltip: l10n.deleteNoteTooltip,
                icon: const Icon(Icons.delete_outline),
                onPressed: _confirmDelete,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: TextField(
              controller: _body,
              maxLines: null,
              expands: true,
              textAlignVertical: TextAlignVertical.top,
              decoration: InputDecoration(
                hintText: l10n.noteBodyHint,
                border: const OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(l10n.attachments, style: Theme.of(context).textTheme.titleSmall),
              const Spacer(),
              IconButton(
                tooltip: l10n.addFileTooltip,
                icon: const Icon(Icons.attach_file_outlined),
                onPressed: () => _pickFiles(type: FileType.any),
              ),
              IconButton(
                tooltip: l10n.addImageTooltip,
                icon: const Icon(Icons.image_outlined),
                onPressed: () => _pickFiles(type: FileType.image),
              ),
            ],
          ),
          SizedBox(
            height: 72,
            child: StreamBuilder(
              stream: attachments,
              builder: (context, snap) {
                final list = snap.data ?? [];
                return ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: list.length,
                  separatorBuilder: (context, index) => const SizedBox(width: 8),
                  itemBuilder: (context, i) {
                    final f = list[i];
                    return Chip(
                      label: Text(f.originalName, overflow: TextOverflow.ellipsis),
                      onDeleted: () => ref.read(filesRepositoryProvider).deleteAttachment(f.id),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );

    if (_dropEnabled) {
      editor = DropTarget(
        onDragDone: (d) => _attachPaths(d.files),
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.5)),
          ),
          child: editor,
        ),
      );
    }

    return editor;
  }
}
