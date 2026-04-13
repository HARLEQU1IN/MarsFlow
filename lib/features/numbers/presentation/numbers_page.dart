import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/format/ru_phone_format.dart';
import '../../../l10n/app_localizations.dart';
import '../data/numbers_repository.dart';

class NumbersPage extends ConsumerStatefulWidget {
  const NumbersPage({super.key});

  @override
  ConsumerState<NumbersPage> createState() => _NumbersPageState();
}

class _NumbersPageState extends ConsumerState<NumbersPage> {
  final _search = TextEditingController();

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final repo = ref.watch(numbersRepositoryProvider);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text(l10n.numbersTitle, style: Theme.of(context).textTheme.headlineSmall),
              const Spacer(),
              FilledButton.icon(
                onPressed: () => _add(context, repo, l10n),
                icon: const Icon(Icons.add),
                label: Text(l10n.add),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _search,
            decoration: InputDecoration(
              hintText: l10n.numbersFilterHint,
              prefixIcon: const Icon(Icons.filter_list),
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: StreamBuilder(
              stream: repo.watchAll(),
              builder: (context, snap) {
                final all = snap.data ?? [];
                final q = _search.text.trim().toLowerCase();
                final list = q.isEmpty
                    ? all
                    : all
                        .where(
                          (e) =>
                              e.number.toLowerCase().contains(q) ||
                              e.title.toLowerCase().contains(q) ||
                              e.category.toLowerCase().contains(q),
                        )
                        .toList();
                return ListView.separated(
                  itemCount: list.length,
                  separatorBuilder: (context, index) => const Divider(height: 1),
                  itemBuilder: (context, i) {
                    final e = list[i];
                    final pretty = formatPhonePretty(normalizePhoneDigits(e.number));
                    final numberLine = pretty.isNotEmpty ? pretty : e.number;
                    return ListTile(
                      title: Text(e.title.isEmpty ? numberLine : e.title),
                      subtitle: Text(
                        e.title.isEmpty ? e.category : '$numberLine · ${e.category}',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.copy_outlined),
                            tooltip: l10n.copyNumberTooltip,
                            onPressed: () async {
                              await Clipboard.setData(ClipboardData(text: e.number));
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(l10n.copied)),
                                );
                              }
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () => repo.remove(e.id),
                          ),
                        ],
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

  Future<void> _add(BuildContext context, NumbersRepository repo, AppLocalizations l10n) async {
    final number = TextEditingController();
    final title = TextEditingController();
    final category = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.numbersNewEntry),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: number,
                keyboardType: TextInputType.phone,
                inputFormatters: [RuPhoneTextInputFormatter()],
                decoration: InputDecoration(
                  labelText: l10n.fieldNumber,
                  hintText: '+7 (9XX) XXX-XX-XX',
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: title,
                decoration: InputDecoration(
                  labelText: l10n.fieldTitle,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: category,
                decoration: InputDecoration(
                  labelText: l10n.fieldCategory,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.cancel)),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l10n.save)),
        ],
      ),
    );
    if (ok == true && context.mounted) {
      final raw = normalizePhoneDigits(number.text);
      if (raw.isEmpty) return;
      await repo.add(
        number: raw,
        title: title.text.trim(),
        category: category.text.trim(),
      );
    }
  }
}
