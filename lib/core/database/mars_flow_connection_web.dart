import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

/// WebAssembly SQLite (see `web/sqlite3.wasm` and `web/drift_worker.js`).
QueryExecutor openMarsFlowConnection({String? explicitDirectory}) {
  return driftDatabase(
    name: 'mars_flow',
    web: DriftWebOptions(
      sqlite3Wasm: Uri.parse('sqlite3.wasm'),
      driftWorker: Uri.parse('drift_worker.js'),
    ),
  );
}
