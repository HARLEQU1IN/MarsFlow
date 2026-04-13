import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/files/presentation/files_page.dart';
import '../features/notes/presentation/notes_workspace.dart';
import '../features/numbers/presentation/numbers_page.dart';
import '../features/search/presentation/search_page.dart';
import '../features/settings/presentation/settings_page.dart';
import '../features/tasks/presentation/tasks_page.dart';
import '../features/vehicle/presentation/vehicle_page.dart';
import '../l10n/app_localizations.dart';
import 'shell_providers.dart';

class _SaveIntent extends Intent {
  const _SaveIntent();
}

class _NewNoteIntent extends Intent {
  const _NewNoteIntent();
}

class _SearchIntent extends Intent {
  const _SearchIntent();
}

class MarsFlowShell extends ConsumerWidget {
  const MarsFlowShell({super.key});

  static bool get _desktop =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.macOS ||
          defaultTargetPlatform == TargetPlatform.windows ||
          defaultTargetPlatform == TargetPlatform.linux);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tab = ref.watch(mainTabProvider);

    Widget body;
    switch (tab) {
      case 0:
        body = const NotesWorkspace();
        break;
      case 1:
        body = const TasksPage();
        break;
      case 2:
        body = const FilesPage();
        break;
      case 3:
        body = const SearchPage();
        break;
      case 4:
        body = const NumbersPage();
        break;
      case 5:
        body = const VehiclePage();
        break;
      case 6:
        body = const SettingsPage();
        break;
      default:
        body = const NotesWorkspace();
    }

    return Shortcuts(
      shortcuts: {
        if (_desktop) ...{
          SingleActivator(LogicalKeyboardKey.keyS, meta: true): const _SaveIntent(),
          SingleActivator(LogicalKeyboardKey.keyS, control: true): const _SaveIntent(),
          SingleActivator(LogicalKeyboardKey.keyN, meta: true): const _NewNoteIntent(),
          SingleActivator(LogicalKeyboardKey.keyN, control: true): const _NewNoteIntent(),
          SingleActivator(LogicalKeyboardKey.keyK, meta: true): const _SearchIntent(),
          SingleActivator(LogicalKeyboardKey.keyK, control: true): const _SearchIntent(),
        },
      },
      child: Actions(
        actions: {
          _SaveIntent: CallbackAction<_SaveIntent>(
            onInvoke: (_) {
              final n = ref.read(saveCurrentNoteRequestProvider.notifier);
              n.state = n.state + 1;
              return null;
            },
          ),
          _NewNoteIntent: CallbackAction<_NewNoteIntent>(
            onInvoke: (_) {
              ref.read(mainTabProvider.notifier).state = 0;
              final c = ref.read(createBlankNoteRequestProvider.notifier);
              c.state = c.state + 1;
              return null;
            },
          ),
          _SearchIntent: CallbackAction<_SearchIntent>(
            onInvoke: (_) {
              ref.read(mainTabProvider.notifier).state = 3;
              return null;
            },
          ),
        },
        child: Focus(
          autofocus: true,
          child: LayoutBuilder(
            builder: (context, c) {
              final l10n = AppLocalizations.of(context);
              final narrow = c.maxWidth < 720;
              if (narrow) {
                return Scaffold(
                  body: SafeArea(
                    bottom: false,
                    child: body,
                  ),
                  bottomNavigationBar: NavigationBar(
                    selectedIndex: tab,
                    labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
                    onDestinationSelected: (i) => ref.read(mainTabProvider.notifier).state = i,
                    destinations: [
                      NavigationDestination(
                        icon: const Icon(Icons.note_outlined),
                        label: l10n.navNotes,
                        tooltip: l10n.navNotes,
                      ),
                      NavigationDestination(
                        icon: const Icon(Icons.checklist_outlined),
                        label: l10n.navTasks,
                        tooltip: l10n.navTasks,
                      ),
                      NavigationDestination(
                        icon: const Icon(Icons.folder_outlined),
                        label: l10n.navFiles,
                        tooltip: l10n.navFiles,
                      ),
                      NavigationDestination(
                        icon: const Icon(Icons.search),
                        label: l10n.navSearch,
                        tooltip: l10n.navSearch,
                      ),
                      NavigationDestination(
                        icon: const Icon(Icons.phone_android_outlined),
                        label: l10n.navNumbers,
                        tooltip: l10n.navNumbers,
                      ),
                      NavigationDestination(
                        icon: const Icon(Icons.directions_car_outlined),
                        label: l10n.navVehicle,
                        tooltip: l10n.navVehicle,
                      ),
                      NavigationDestination(
                        icon: const Icon(Icons.settings_outlined),
                        label: l10n.navSettings,
                        tooltip: l10n.navSettings,
                      ),
                    ],
                  ),
                );
              }
              return Scaffold(
                body: Row(
                  children: [
                    NavigationRail(
                      selectedIndex: tab,
                      onDestinationSelected: (i) => ref.read(mainTabProvider.notifier).state = i,
                      labelType: NavigationRailLabelType.all,
                      destinations: [
                        NavigationRailDestination(icon: const Icon(Icons.note_outlined), label: Text(l10n.navNotes)),
                        NavigationRailDestination(icon: const Icon(Icons.checklist_outlined), label: Text(l10n.navTasks)),
                        NavigationRailDestination(icon: const Icon(Icons.folder_outlined), label: Text(l10n.navFiles)),
                        NavigationRailDestination(icon: const Icon(Icons.search), label: Text(l10n.navSearch)),
                        NavigationRailDestination(icon: const Icon(Icons.phone_android_outlined), label: Text(l10n.navNumbers)),
                        NavigationRailDestination(icon: const Icon(Icons.directions_car_outlined), label: Text(l10n.navVehicle)),
                        NavigationRailDestination(icon: const Icon(Icons.settings_outlined), label: Text(l10n.navSettings)),
                      ],
                    ),
                    const VerticalDivider(width: 1),
                    Expanded(child: body),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
