import 'package:flutter/material.dart';

abstract final class AppTheme {
  static ThemeData dark() {
    const seed = Color(0xFF1E3A5F);
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: seed,
        brightness: Brightness.dark,
        surface: const Color(0xFF121418),
      ),
      scaffoldBackgroundColor: const Color(0xFF0E1013),
      cardTheme: CardThemeData(
        color: const Color(0xFF181B21),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF1A1D24),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      dividerTheme: const DividerThemeData(color: Color(0xFF2A2F38), thickness: 1),
    );
  }
}
