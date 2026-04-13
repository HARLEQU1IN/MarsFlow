import 'package:encrypt/encrypt.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// AES-CBC with random IV per encryption; key stored in secure storage.
class NoteCrypto {
  static const _keyName = 'marsflow_note_key';

  final FlutterSecureStorage _secure = const FlutterSecureStorage();

  Future<Key> _key() async {
    var raw = await _secure.read(key: _keyName);
    if (raw == null || raw.isEmpty) {
      raw = Key.fromSecureRandom(32).base64;
      await _secure.write(key: _keyName, value: raw);
    }
    return Key.fromBase64(raw);
  }

  /// Returns `enc:<base64 iv+cipher>` or plain text if encryption disabled.
  Future<String> encryptIfEnabled(String plain, {required bool enabled}) async {
    if (!enabled || plain.isEmpty) return plain;
    final key = await _key();
    final iv = IV.fromSecureRandom(16);
    final encrypter = Encrypter(AES(key));
    final cipher = encrypter.encrypt(plain, iv: iv);
    return 'enc:${iv.base64}:${cipher.base64}';
  }

  Future<String> decryptIfNeeded(String stored) async {
    if (!stored.startsWith('enc:')) return stored;
    final parts = stored.substring(4).split(':');
    if (parts.length != 2) return stored;
    final key = await _key();
    final iv = IV.fromBase64(parts[0]);
    final enc = Encrypted.fromBase64(parts[1]);
    final encrypter = Encrypter(AES(key));
    try {
      return encrypter.decrypt(enc, iv: iv);
    } catch (_) {
      return stored;
    }
  }

  static bool looksEncrypted(String? s) => s != null && s.startsWith('enc:');
}
