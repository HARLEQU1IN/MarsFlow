import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/mars_flow_database.dart';
import '../../../core/providers/core_providers.dart';

class NumbersRepository {
  NumbersRepository(this._db);

  final MarsFlowDatabase _db;

  Stream<List<NumbersDirectoryData>> watchAll() {
    return (_db.select(_db.numbersDirectory)..orderBy([(n) => OrderingTerm.asc(n.title)])).watch();
  }

  Future<List<NumbersDirectoryData>> searchLocal(String q) async {
    final trimmed = q.trim().toLowerCase();
    if (trimmed.isEmpty) {
      return _db.select(_db.numbersDirectory).get();
    }
    return (_db.select(_db.numbersDirectory)
          ..where(
            (n) =>
                n.number.lower().contains(trimmed) |
                n.title.lower().contains(trimmed) |
                n.category.lower().contains(trimmed),
          ))
        .get();
  }

  Future<int> add({required String number, String title = '', String category = ''}) {
    final now = DateTime.now();
    return _db.into(_db.numbersDirectory).insert(
          NumbersDirectoryCompanion.insert(
            number: number,
            title: Value(title),
            category: Value(category),
            createdAt: Value(now),
            updatedAt: Value(now),
          ),
        );
  }

  Future<void> remove(int id) async {
    await (_db.delete(_db.numbersDirectory)..where((n) => n.id.equals(id))).go();
  }
}

final numbersRepositoryProvider = Provider<NumbersRepository>((ref) {
  return NumbersRepository(ref.watch(databaseProvider));
});
