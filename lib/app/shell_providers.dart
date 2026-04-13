import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Primary navigation index (notes, tasks, files, search, numbers, vehicle, settings).
final mainTabProvider = StateProvider<int>((ref) => 0);

/// Increment to ask the open note editor to flush-save (Cmd/Ctrl+S).
final saveCurrentNoteRequestProvider = StateProvider<int>((ref) => 0);

/// Increment to create a blank note in the current folder (Cmd/Ctrl+N).
final createBlankNoteRequestProvider = StateProvider<int>((ref) => 0);
