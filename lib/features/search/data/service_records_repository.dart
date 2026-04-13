import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/mars_flow_database.dart';
import '../../../core/providers/core_providers.dart';

enum ServiceSortMode {
  dateDesc,
  dateAsc,
  typeAsc,
  typeDesc,
}

class ServiceRecordsRepository {
  ServiceRecordsRepository(this._db);

  final MarsFlowDatabase _db;

  Stream<List<ServiceRecord>> watch(ServiceSortMode mode) {
    final q = _db.select(_db.serviceRecords);
    switch (mode) {
      case ServiceSortMode.dateDesc:
        q.orderBy([(r) => OrderingTerm.desc(r.performedAt)]);
      case ServiceSortMode.dateAsc:
        q.orderBy([(r) => OrderingTerm.asc(r.performedAt)]);
      case ServiceSortMode.typeAsc:
        q.orderBy([
          (r) => OrderingTerm.asc(r.actionType),
          (r) => OrderingTerm.desc(r.performedAt),
        ]);
      case ServiceSortMode.typeDesc:
        q.orderBy([
          (r) => OrderingTerm.desc(r.actionType),
          (r) => OrderingTerm.desc(r.performedAt),
        ]);
    }
    return q.watch();
  }

  Future<int> add({
    required String actionType,
    required String title,
    String details = '',
    required DateTime performedAt,
    int? odometerKm,
  }) {
    final now = DateTime.now();
    return _db.into(_db.serviceRecords).insert(
          ServiceRecordsCompanion.insert(
            actionType: Value(actionType),
            title: Value(title),
            details: Value(details),
            performedAt: Value(performedAt),
            odometerKm: Value(odometerKm),
            createdAt: Value(now),
            updatedAt: Value(now),
          ),
        );
  }

  Future<void> delete(int id) async {
    await (_db.delete(_db.serviceRecords)..where((r) => r.id.equals(id))).go();
  }

  /// Latest [performedAt] per distinct [actionType] (e.g. last ТО, last oil change).
  Stream<List<ServiceTypeLast>> watchLastByActionType() {
    return _db
        .customSelect(
          '''
SELECT action_type AS atype, MAX(performed_at) AS last_at
FROM service_records
GROUP BY action_type
ORDER BY last_at DESC
''',
          readsFrom: {_db.serviceRecords},
        )
        .watch()
        .map(
          (rows) => rows
              .map(
                (r) => ServiceTypeLast(
                  actionType: r.read<String>('atype'),
                  lastPerformedAt: r.read<DateTime>('last_at'),
                ),
              )
              .toList(),
        );
  }
}

class ServiceTypeLast {
  const ServiceTypeLast({required this.actionType, required this.lastPerformedAt});

  final String actionType;
  final DateTime lastPerformedAt;
}

final serviceRecordsRepositoryProvider = Provider<ServiceRecordsRepository>((ref) {
  return ServiceRecordsRepository(ref.watch(databaseProvider));
});
