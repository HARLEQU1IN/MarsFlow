import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Web: optional override in SharedPreferences; default documents/MarsFlow path string.
class StorageBootstrap {
  static const _prefsKey = 'mf_storage_root_override';

  static Future<String> resolve() async {
    final prefs = await SharedPreferences.getInstance();
    final custom = prefs.getString(_prefsKey);
    if (custom != null && custom.trim().isNotEmpty) {
      return custom.trim();
    }
    final doc = await getApplicationDocumentsDirectory();
    return '${doc.path}/MarsFlow';
  }

  static Future<void> writeStorageRoot(String absolutePath) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, absolutePath);
  }
}
