import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../l10n/app_localizations.dart';
import '../../notes/presentation/notes_providers.dart';
import '../data/tasks_repository.dart';

class TasksPage extends ConsumerWidget {
  const TasksPage({super.key});

  static String _priorityLabel(AppLocalizations l, int p) {
    switch (p) {
      case 4:
        return l.taskEisenhowerDo;
      case 3:
        return l.taskEisenhowerSchedule;
      case 2:
        return l.taskEisenhowerDelegate;
      default:
        return l.taskEisenhowerEliminate;
    }
  }

  static String _statusLabel(AppLocalizations l, String s) {
    switch (s) {
      case 'todo':
        return l.taskStatusTodo;
      case 'doing':
        return l.taskStatusDoing;
      case 'done':
        return l.taskStatusDone;
      case 'cancelled':
        return l.taskStatusCancelled;
      default:
        return s;
    }
  }

  static Future<void> _pickDueDate(BuildContext context, WidgetRef ref, int taskId, DateTime? current) async {
    final d = await showDatePicker(
      context: context,
      initialDate: current ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (d == null) return;
    if (!context.mounted) return;
    final t = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(current ?? DateTime.now()),
    );
    if (!context.mounted) return;
    final combined = DateTime(d.year, d.month, d.day, t?.hour ?? 9, t?.minute ?? 0);
    await ref.read(tasksRepositoryProvider).setDueAt(taskId, combined);
  }

  static Future<int?> _pickPriorityMatrix(BuildContext context, AppLocalizations l10n, int current) {
    return showDialog<int>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.taskEisenhowerTitle),
        content: LayoutBuilder(
          builder: (context, c) {
            final compact = c.maxWidth < 420;
            final tiles = [
              _PriorityTile(
                selected: current == 4,
                title: l10n.taskEisenhowerIU,
                subtitle: l10n.taskEisenhowerDo,
                color: Colors.redAccent,
                onTap: () => Navigator.pop(ctx, 4),
              ),
              _PriorityTile(
                selected: current == 3,
                title: l10n.taskEisenhowerInU,
                subtitle: l10n.taskEisenhowerSchedule,
                color: Colors.orangeAccent,
                onTap: () => Navigator.pop(ctx, 3),
              ),
              _PriorityTile(
                selected: current == 2,
                title: l10n.taskEisenhowerIUn,
                subtitle: l10n.taskEisenhowerDelegate,
                color: Colors.blueAccent,
                onTap: () => Navigator.pop(ctx, 2),
              ),
              _PriorityTile(
                selected: current == 1,
                title: l10n.taskEisenhowerInUn,
                subtitle: l10n.taskEisenhowerEliminate,
                color: Colors.grey,
                onTap: () => Navigator.pop(ctx, 1),
              ),
            ];
            if (compact) {
              return SizedBox(
                width: c.maxWidth,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (var i = 0; i < tiles.length; i++) ...[
                        tiles[i],
                        if (i != tiles.length - 1) const SizedBox(height: 8),
                      ],
                    ],
                  ),
                ),
              );
            }
            return SizedBox(
              width: 520,
              child: GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 1.08,
                children: tiles,
              ),
            );
          },
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l10n.cancel)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final stream = ref.watch(tasksRepositoryProvider).watchOpenTasks();
    final locale = Localizations.localeOf(context).toString();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text(l10n.tasksTitle, style: Theme.of(context).textTheme.headlineSmall),
              const Spacer(),
              FilledButton.icon(
                onPressed: () => _addTask(context, ref, l10n),
                icon: const Icon(Icons.add),
                label: Text(l10n.add),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: LayoutBuilder(
              builder: (context, c) {
                final compact = c.maxWidth < 420;
                return StreamBuilder(
                  stream: stream,
                  builder: (context, snap) {
                    final list = snap.data ?? [];
                    if (list.isEmpty) {
                      return Center(child: Text(l10n.noOpenTasks));
                    }
                    return ListView.separated(
                      itemCount: list.length,
                      separatorBuilder: (context, index) => const Divider(height: 1),
                      itemBuilder: (context, i) {
                        final t = list[i];
                        final dueSuffix = t.dueAt != null
                            ? l10n.taskDue(DateFormat.yMd(locale).add_Hm().format(t.dueAt!.toLocal()))
                            : '';
                        final subtitle = '${_priorityLabel(l10n, t.priority)} · ${_statusLabel(l10n, t.status)}$dueSuffix';
                        return ListTile(
                          title: Text(t.title),
                          subtitle: Text(
                            subtitle,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: compact
                              ? PopupMenuButton<String>(
                                  tooltip: l10n.taskChangePriority,
                                  onSelected: (value) async {
                                    if (value == 'priority') {
                                      final next = await _pickPriorityMatrix(context, l10n, t.priority);
                                      if (next != null) {
                                        await ref.read(tasksRepositoryProvider).setPriority(t.id, next);
                                      }
                                      return;
                                    }
                                    if (value == 'due') {
                                      await _pickDueDate(context, ref, t.id, t.dueAt);
                                      return;
                                    }
                                    if (value == 'done') {
                                      await ref.read(tasksRepositoryProvider).setStatus(t.id, 'done');
                                      return;
                                    }
                                    if (value == 'delete') {
                                      await ref.read(tasksRepositoryProvider).deleteTask(t.id);
                                    }
                                  },
                                  itemBuilder: (ctx) => [
                                    PopupMenuItem(value: 'priority', child: Text(l10n.taskChangePriority)),
                                    PopupMenuItem(value: 'due', child: Text(l10n.taskChangeDueDate)),
                                    PopupMenuItem(value: 'done', child: Text(l10n.taskStatusDone)),
                                    PopupMenuItem(value: 'delete', child: Text(l10n.deleteAction)),
                                  ],
                                )
                              : Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      tooltip: l10n.taskChangePriority,
                                      icon: const Icon(Icons.flag_outlined),
                                      onPressed: () async {
                                        final next = await _pickPriorityMatrix(context, l10n, t.priority);
                                        if (next != null) {
                                          await ref.read(tasksRepositoryProvider).setPriority(t.id, next);
                                        }
                                      },
                                    ),
                                    IconButton(
                                      tooltip: l10n.taskChangeDueDate,
                                      icon: const Icon(Icons.event_outlined),
                                      onPressed: () => _pickDueDate(context, ref, t.id, t.dueAt),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.check),
                                      onPressed: () => ref.read(tasksRepositoryProvider).setStatus(t.id, 'done'),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete_outline),
                                      onPressed: () => ref.read(tasksRepositoryProvider).deleteTask(t.id),
                                    ),
                                  ],
                                ),
                        );
                      },
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

  Future<void> _addTask(BuildContext context, WidgetRef ref, AppLocalizations l10n) async {
    final title = TextEditingController();
    DateTime? due;
    var priority = 3;
    final noteId = ref.read(selectedNoteIdProvider);

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSt) {
          return AlertDialog(
            title: Text(l10n.newTask),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: title,
                    autofocus: true,
                    decoration: InputDecoration(hintText: l10n.hintTaskTitle),
                  ),
                  const SizedBox(height: 16),
                  Text(l10n.taskEisenhowerTitle, style: Theme.of(ctx).textTheme.labelLarge),
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: () async {
                      final next = await _pickPriorityMatrix(ctx, l10n, priority);
                      if (next != null) setSt(() => priority = next);
                    },
                    icon: const Icon(Icons.flag_outlined, size: 18),
                    label: Text(_priorityLabel(l10n, priority)),
                  ),
                  const SizedBox(height: 16),
                  Text(l10n.taskDueDateOptional, style: Theme.of(ctx).textTheme.labelLarge),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            final d = await showDatePicker(
                              context: ctx,
                              initialDate: due ?? DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            );
                            if (d == null) return;
                            if (!ctx.mounted) return;
                            final time = await showTimePicker(
                              context: ctx,
                              initialTime: TimeOfDay.fromDateTime(due ?? DateTime.now()),
                            );
                            setSt(() {
                              due = DateTime(d.year, d.month, d.day, time?.hour ?? 9, time?.minute ?? 0);
                            });
                          },
                          icon: const Icon(Icons.calendar_today_outlined, size: 18),
                          label: Text(due == null ? l10n.taskPickDate : DateFormat.yMd().add_Hm().format(due!.toLocal())),
                        ),
                      ),
                      if (due != null)
                        IconButton(
                          tooltip: l10n.taskClearDate,
                          onPressed: () => setSt(() => due = null),
                          icon: const Icon(Icons.clear),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.cancel)),
              FilledButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l10n.create)),
            ],
          );
        },
      ),
    );

    if (ok == true && title.text.trim().isNotEmpty && context.mounted) {
      await ref.read(tasksRepositoryProvider).createTask(
            title: title.text.trim(),
            linkedNoteId: noteId,
            dueAt: due,
            priority: priority,
          );
    }
  }
}

class _PriorityTile extends StatelessWidget {
  const _PriorityTile({
    required this.selected,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  final bool selected;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final border = selected ? BorderSide(color: cs.primary, width: 2) : BorderSide(color: cs.outlineVariant);
    return Material(
      color: cs.surfaceContainerHighest.withValues(alpha: selected ? 0.65 : 0.35),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: border),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 9,
                    height: 9,
                    decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      title,
                      maxLines: 3,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                maxLines: 2,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
