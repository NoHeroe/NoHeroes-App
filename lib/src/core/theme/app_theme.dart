import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get dark => ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF0B0B10),
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF8B5CF6),
      secondary: Color(0xFF14B8A6),
    ),
    useMaterial3: true,
    fontFamily: 'Roboto',
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontFamily: 'CinzelDecorative',
        fontWeight: FontWeight.bold,
        fontSize: 28,
        letterSpacing: 1.5,
      ),
      headlineMedium: TextStyle(
        fontFamily: 'CinzelDecorative',
        fontSize: 22,
        letterSpacing: 1.2,
      ),
    ),
  );
}