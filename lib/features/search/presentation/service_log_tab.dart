import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/format/note_date_format.dart';
import '../../../l10n/app_localizations.dart';
import '../data/service_records_repository.dart';

class ServiceLogTab extends ConsumerStatefulWidget {
  const ServiceLogTab({super.key});

  @override
  ConsumerState<ServiceLogTab> createState() => _ServiceLogTabState();
}

class _ServiceLogTabState extends ConsumerState<ServiceLogTab> {
  ServiceSortMode _sort = ServiceSortMode.dateDesc;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final repo = ref.watch(serviceRecordsRepositoryProvider);
    final stream = repo.watch(_sort);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l10n.serviceLogTitle, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 6),
        Text(
          l10n.serviceLogSubtitle,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, c) {
            final narrow = c.maxWidth < 420;
            final sortField = InputDecorator(
              decoration: InputDecoration(
                labelText: l10n.sortLabel,
                border: const OutlineInputBorder(),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<ServiceSortMode>(
                  value: _sort,
                  isExpanded: true,
                  items: [
                    DropdownMenuItem(value: ServiceSortMode.dateDesc, child: Text(l10n.serviceSortDateNew)),
                    DropdownMenuItem(value: ServiceSortMode.dateAsc, child: Text(l10n.serviceSortDateOld)),
                    DropdownMenuItem(value: ServiceSortMode.typeAsc, child: Text(l10n.serviceSortTypeAz)),
                    DropdownMenuItem(value: ServiceSortMode.typeDesc, child: Text(l10n.serviceSortTypeZa)),
                  ],
                  onChanged: (v) {
                    if (v != null) setState(() => _sort = v);
                  },
                ),
              ),
            );
            final addBtn = FilledButton.icon(
              onPressed: () => _addRecord(context, repo, l10n),
              icon: const Icon(Icons.add),
              label: Text(l10n.serviceAddRecord),
            );
            if (narrow) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  sortField,
                  const SizedBox(height: 10),
                  addBtn,
                ],
              );
            }
            return Row(
              children: [
                Expanded(child: sortField),
                const SizedBox(width: 12),
                addBtn,
              ],
            );
          },
        ),
        const SizedBox(height: 12),
        Expanded(
          child: StreamBuilder(
            stream: stream,
            builder: (context, snap) {
              final list = snap.data ?? [];
              if (list.isEmpty) {
                return Center(child: Text(l10n.serviceLogEmpty));
              }
              return ListView.separated(
                itemCount: list.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, i) {
                  final r = list[i];
                  final dateStr = formatNoteListDate(context, r.performedAt);
                  final odo = r.odometerKm != null ? ' · ${r.odometerKm} km' : '';
                  final line1 = '${r.actionType.isEmpty ? '—' : r.actionType} · $dateStr$odo';
                  final sub = r.details.trim().isEmpty ? line1 : '$line1\n${r.details}';
                  return ListTile(
                    title: Text(r.title.isEmpty ? r.actionType : r.title),
                    subtitle: Text(sub, maxLines: 4),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () => _confirmDelete(context, repo, l10n, r.id),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    ServiceRecordsRepository repo,
    AppLocalizations l10n,
    int id,
  ) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.serviceDeleteRecord),
        content: Text(l10n.serviceDeleteRecordBody),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.cancel)),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l10n.deleteAction)),
        ],
      ),
    );
    if (ok == true) await repo.delete(id);
  }

  Future<void> _addRecord(
    BuildContext context,
    ServiceRecordsRepository repo,
    AppLocalizations l10n,
  ) async {
    final actionType = TextEditingController();
    final title = TextEditingController();
    final details = TextEditingController();
    final odo = TextEditingController();
    var performed = DateTime.now();

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSt) {
          return AlertDialog(
            title: Text(l10n.serviceNewRecord),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: actionType,
                    decoration: InputDecoration(labelText: l10n.serviceFieldActionType),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: title,
                    decoration: InputDecoration(labelText: l10n.serviceFieldTitle),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: details,
                    maxLines: 3,
                    decoration: InputDecoration(labelText: l10n.serviceFieldDetails),
                  ),
                  const SizedBox(height: 20),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(l10n.serviceFieldDate),
                    subtitle: Text(DateFormat.yMMMd(Localizations.localeOf(ctx).languageCode == 'ru' ? 'ru' : 'en')
                        .add_Hm()
                        .format(performed.toLocal())),
                    trailing: IconButton(
                      icon: const Icon(Icons.calendar_today_outlined),
                      onPressed: () async {
                        final d = await showDatePicker(
                          context: ctx,
                          initialDate: performed,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (d == null) return;
                        if (!ctx.mounted) return;
                        final t = await showTimePicker(
                          context: ctx,
                          initialTime: TimeOfDay.fromDateTime(performed),
                        );
                        setSt(() {
                          performed = DateTime(d.year, d.month, d.day, t?.hour ?? performed.hour, t?.minute ?? performed.minute);
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: odo,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: l10n.serviceFieldOdometer),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.cancel)),
              FilledButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l10n.save)),
            ],
          );
        },
      ),
    );

    if (ok != true || !context.mounted) return;
    final odoVal = int.tryParse(odo.text.trim());
    await repo.add(
      actionType: actionType.text.trim(),
      title: title.text.trim(),
      details: details.text.trim(),
      performedAt: performed,
      odometerKm: odoVal,
    );
  }
}
