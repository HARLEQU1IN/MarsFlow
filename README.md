# MarsFlow

Offline-first workspace: notes (folders, tags, attachments), FTS5 search, tasks, local files, numbers directory, export/import. **No servers** — SQLite + local filesystem only.

## Architecture (Clean)

| Layer | Responsibility |
|--------|----------------|
| **Presentation** | Flutter UI, Riverpod wiring, `lib/app/`, `lib/features/*/presentation/` |
| **Domain** | Use-cases live in repositories (MVP); extend with explicit entities/use-case classes as features grow |
| **Data** | Drift + SQLite, FTS5, file IO, `lib/features/*/data/`, `lib/core/database/`, `lib/core/storage/`, `lib/core/backup/` |

### Modules (`lib/features/`)

- **notes** — CRUD, folders, tags, attachments, autosave, desktop drag-and-drop
- **tasks** — status, priority, due date, optional link to a note
- **files** — global attachment list (binaries under `attachments/`)
- **search** — FTS5 (`notes_fts`) + filters (tags, date range, type placeholder)
- **settings** — storage path bootstrap, encryption toggle, backup export/import
- **numbers** — quick list, filter, copy-to-clipboard

### Database

- File: `<storageRoot>/mars_flow.sqlite`
- FTS5 external content table `notes_fts` + triggers on `notes` (`lib/core/database/mars_flow_database.dart`)
- Indices on hot columns (folders, notes, note_tags, stored_files, tasks, numbers)

### Storage layout

```
<storageRoot>/
  mars_flow.sqlite
  attachments/ # UUID-named files; paths in `stored_files.local_relative_path`
```

Bootstrap for **custom root** (before DB open): `ApplicationSupport/MarsFlow/storage_bootstrap.json` (`StorageBootstrap`).

## Run

```bash
cd MarsFlow
flutter pub get
dart run build_runner build --delete-conflicting-outputs   # after changing Drift schema
flutter gen-l10n                                         # after editing lib/l10n/*.arb
flutter run -d macos    # or windows / linux / chrome (not a target here) / android / ios
```

UI strings live in `lib/l10n/app_en.arb` and `lib/l10n/app_ru.arb`; the active language is stored in SQLite (`app_prefs.app_locale`) and can be switched in **Settings**.

## MVP vs roadmap

**In this repo (MVP)**

- Modular folders + notes editor with debounced autosave
- FTS5 search, tag/date filters in repository
- Tasks, numbers, file list, settings (encryption, path, export sqlite / folder / zip, import zip)
- Desktop: `Cmd/Ctrl+S`, `N`, `K`; drag-and-drop attachments

**Planned extensions**

- Rich domain layer (entities, explicit use-cases), tests per module
- UI polish: note tags picker, task/note deep links from search, in-app file preview (OpenDocument / image)
- Scheduled backups (Workmanager / background task per platform)
- Stronger crypto (SQLCipher or field-level with audited libs) and migration tooling
- Import merge (not only full replace)

## Tests

```bash
flutter test
```
