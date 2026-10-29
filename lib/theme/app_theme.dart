import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get light => ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: const Color(0xFFF6F5F3),
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF0A8C8F),
      secondary: Color(0xFF0F6C6D),
      surface: Colors.white,
      onSurface: Color(0xFF171414),
    ),
    textTheme: const TextTheme(
      headlineMedium: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: Color(0xFF171414),
        letterSpacing: 0.048,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Color(0xFF171414),
        letterSpacing: 0.032,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: Color(0xFF171414),
        letterSpacing: 0.028,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: Color(0xFF756F6F),
        letterSpacing: 0.024,
      ),
    ),
  );
}
