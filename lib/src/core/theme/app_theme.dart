```dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData get dark {
    final base = ThemeData.dark(useMaterial3: true);
    return base.copyWith(
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFFEA4335), // red glow
        secondary: Color(0xFF9E9E9E),
        surface: Color(0xFF0E0E12),
        background: Color(0xFF0A0A0D),
      ),
      scaffoldBackgroundColor: const Color(0xFF0A0A0D),
      textTheme: GoogleFonts.jetBrainsMonoTextTheme(base.textTheme).apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF0E0E12),
        elevation: 0,
      ),
      cardTheme: CardTheme(
        color: const Color(0xFF111116),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
```
