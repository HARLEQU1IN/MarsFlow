import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/mars_flow_database.dart';
import '../../../core/providers/core_providers.dart';

class TasksRepository {
  TasksRepository(this._db);

  final MarsFlowDatabase _db;

  Stream<List<Task>> watchOpenTasks() {
    final q = _db.select(_db.tasks)
      ..where((t) => t.status.isNotIn(['done', 'cancelled']))
      ..orderBy([
        (t) => OrderingTerm(expression: t.dueAt, mode: OrderingMode.asc, nulls: NullsOrder.last),
        (t) => OrderingTerm.desc(t.priority),
      ]);
    return q.watch();
  }

  Future<int> createTask({
    required String title,
    int? linkedNoteId,
    DateTime? dueAt,
    int priority = 1,
  }) {
    final now = DateTime.now();
    return _db.into(_db.tasks).insert(
          TasksCompanion.insert(
            title: title,
            linkedNoteId: Value(linkedNoteId),
            dueAt: Value(dueAt),
            priority: Value(priority),
            createdAt: Value(now),
            updatedAt: Value(now),
          ),
        );
  }

  Future<void> setStatus(int id, String status) async {
    await (_db.update(_db.tasks)..where((t) => t.id.equals(id))).write(
          TasksCompanion(status: Value(status), updatedAt: Value(DateTime.now())),
        );
  }

  Future<void> deleteTask(int id) async {
    await (_db.delete(_db.tasks)..where((t) => t.id.equals(id))).go();
  }

  Future<void> setDueAt(int id, DateTime? dueAt) async {
    await (_db.update(_db.tasks)..where((t) => t.id.equals(id))).write(
          TasksCompanion(dueAt: Value(dueAt), updatedAt: Value(DateTime.now())),
        );
  }

  Future<void> setPriority(int id, int priority) async {
    await (_db.update(_db.tasks)..where((t) => t.id.equals(id))).write(
          TasksCompanion(priority: Value(priority), updatedAt: Value(DateTime.now())),
        );
  }
}

final tasksRepositoryProvider = Provider<TasksRepository>((ref) {
  return TasksRepository(ref.watch(databaseProvider));
});
