import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Short date+time for note lists (no milliseconds).
String formatNoteListDate(BuildContext context, DateTime utc) {
  final lang = Localizations.localeOf(context).languageCode;
  final loc = lang == 'ru' ? 'ru' : 'en';
  return DateFormat.yMMMd(loc).add_Hm().format(utc.toLocal());
}
