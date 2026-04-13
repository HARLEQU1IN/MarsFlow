import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/native.dart';
import 'package:mars_flow/app/mars_flow_app.dart';
import 'package:mars_flow/core/database/mars_flow_database.dart';
import 'package:mars_flow/core/locale/app_locale_provider.dart';
import 'package:mars_flow/core/providers/core_providers.dart';

void main() {
  testWidgets('MarsFlow shell renders navigation', (tester) async {
    final db = MarsFlowDatabase(NativeDatabase.memory());

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          storageRootProvider.overrideWithValue('/tmp/marsflow-test'),
          databaseProvider.overrideWithValue(db),
          appLocaleNotifierProvider.overrideWith((ref) => AppLocaleNotifier(const Locale('en'))),
        ],
        child: const MarsFlowApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('Notes'), findsWidgets);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 100));
    await db.close();
  });
}
