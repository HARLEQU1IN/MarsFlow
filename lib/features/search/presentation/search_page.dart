import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/shell_providers.dart';
import '../../../l10n/app_localizations.dart';
import '../../notes/presentation/notes_providers.dart';
import '../data/search_repository.dart';
import 'service_log_tab.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _q = TextEditingController();
  List<SearchHit> _hits = [];
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _q.dispose();
    super.dispose();
  }

  Future<void> _run() async {
    setState(() => _busy = true);
    final hits = await ref.read(searchRepositoryProvider).search(query: _q.text);
    if (mounted) {
      setState(() {
        _hits = hits;
        _busy = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
               TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          tabs: [
            Tab(text: l10n.searchTabNotes),
            Tab(text: l10n.searchTabServiceLog),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(l10n.searchTitle, style: Theme.of(context).textTheme.headlineSmall),
                    const SizedBox(height: 12),
                    LayoutBuilder(
                      builder: (context, c) {
                        final narrow = c.maxWidth < 400;
                        final field = TextField(
                          controller: _q,
                          decoration: InputDecoration(
                            hintText: l10n.searchHint,
                            prefixIcon: const Icon(Icons.search),
                          ),
                          onSubmitted: (_) => _run(),
                        );
                        final btn = FilledButton(onPressed: _busy ? null : _run, child: Text(l10n.searchAction));
                        if (narrow) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              field,
                              const SizedBox(height: 10),
                              btn,
                            ],
                          );
                        }
                        return Row(
                          children: [
                            Expanded(child: field),
                            const SizedBox(width: 12),
                            btn,
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    if (_busy) const LinearProgressIndicator(),
                    Expanded(
                      child: ListView.separated(
                        itemCount: _hits.length,
                        separatorBuilder: (context, index) => const Divider(height: 1),
                        itemBuilder: (context, i) {
                          final h = _hits[i];
                          return ListTile(
                            title: Text(h.title.isEmpty ? l10n.untitled : h.title),
                            subtitle: Text(h.subtitle ?? ''),
                            onTap: () {
                              ref.read(mainTabProvider.notifier).state = 0;
                              ref.read(selectedNoteIdProvider.notifier).state = h.id;
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(16),
                child: ServiceLogTab(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
