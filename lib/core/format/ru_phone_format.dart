import 'package:flutter/services.dart';

/// Keeps only digits, normalizes leading 8 → 7, caps at 11 digits (RU mobile).
String normalizePhoneDigits(String input) {
  var d = input.replaceAll(RegExp(r'\D'), '');
  if (d.isEmpty) return '';
  if (d.startsWith('8')) d = '7${d.substring(1)}';
  if (!d.startsWith('7')) d = '7$d';
  if (d.length > 11) d = d.substring(0, 11);
  return d;
}

/// Pretty display: +7 (9XX) XXX-XX-XX
String formatPhonePretty(String raw) {
  final d = normalizePhoneDigits(raw);
  if (d.isEmpty) return '';
  if (d.length == 1) return '+7';
  final r = d.substring(1);
  final b = StringBuffer('+7 (');
  if (r.length <= 3) {
    b.write(r);
    b.write(')');
    return b.toString();
  }
  b.write(r.substring(0, 3));
  b.write(') ');
  final x = r.substring(3);
  if (x.length <= 3) {
    b.write(x);
    return b.toString();
  }
  b.write(x.substring(0, 3));
  b.write('-');
  final y = x.substring(3);
  if (y.length <= 2) {
    b.write(y);
    return b.toString();
  }
  b.write(y.substring(0, 2));
  b.write('-');
  b.write(y.substring(2));
  return b.toString();
}

class RuPhoneTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final n = normalizePhoneDigits(newValue.text);
    final pretty = formatPhonePretty(n);
    return TextEditingValue(
      text: pretty,
      selection: TextSelection.collapsed(offset: pretty.length),
    );
  }
}
