import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Opens the SQLite file under the app documents directory by default.
QueryExecutor openMarsFlowConnection({String? explicitDirectory}) {
  return driftDatabase(
    name: 'mars_flow',
    native: DriftNativeOptions(
      databaseDirectory: () async {
        if (explicitDirectory != null && explicitDirectory.isNotEmpty) {
          return Directory(explicitDirectory);
        }
        final dir = await getApplicationDocumentsDirectory();
        final root = Directory(p.join(dir.path, 'MarsFlow'));
        if (!await root.exists()) {
          await root.create(recursive: true);
        }
        return root;
      },
    ),
  );
}
