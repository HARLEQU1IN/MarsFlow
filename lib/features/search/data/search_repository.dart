import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/mars_flow_database.dart';
import '../../../core/providers/core_providers.dart';

enum SearchItemType { note, task, file, number }

class SearchHit {
  const SearchHit({required this.type, required this.id, required this.title, this.subtitle});

  final SearchItemType type;
  final int id;
  final String title;
  final String? subtitle;
}

class SearchRepository {
  SearchRepository(this._db);

  final MarsFlowDatabase _db;

  Future<List<SearchHit>> search({
    required String query,
    List<int>? tagIds,
    DateTime? from,
    DateTime? to,
    SearchItemType? type,
  }) async {
    final q = query.trim();
    if (q.isEmpty) return [];

    final noteIds = await _db.searchNotesFts(q);
    if (noteIds.isEmpty) return [];

    if (type != null && type != SearchItemType.note) {
      return [];
    }

    final rows = await (_db.select(_db.notes)..where((n) => n.id.isIn(noteIds))).get();
    final byId = {for (final n in rows) n.id: n};

    Set<int>? tagFilter;
    if (tagIds != null && tagIds.isNotEmpty) {
      for (final tid in tagIds) {
        final tagged = await (_db.select(_db.noteTags)..where((t) => t.tagId.equals(tid))).get();
        final s = tagged.map((e) => e.noteId).toSet();
        tagFilter = tagFilter == null ? s : tagFilter.intersection(s);
      }
    }

    final hits = <SearchHit>[];
    for (final id in noteIds) {
      final n = byId[id];
      if (n == null) continue;
      if (tagFilter != null && !tagFilter.contains(id)) continue;
      if (from != null && n.updatedAt.isBefore(from)) continue;
      if (to != null && n.updatedAt.isAfter(to)) continue;
      hits.add(
        SearchHit(
          type: SearchItemType.note,
          id: id,
          title: n.title,
          subtitle: n.updatedAt.toIso8601String(),
        ),
      );
    }
    return hits;
  }
}

final searchRepositoryProvider = Provider<SearchRepository>((ref) {
  return SearchRepository(ref.watch(databaseProvider));
});
