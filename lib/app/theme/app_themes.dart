import 'package:flutter/material.dart';
import 'app_theme_enum.dart';

class AppThemes {
  static final themes = {
    AppTheme.classicoDark: ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: Colors.black,
      primaryColor: Colors.tealAccent,
      colorScheme: const ColorScheme.dark().copyWith(
        primary: Colors.tealAccent,
        secondary: Colors.teal,
      ),
      cardColor: Colors.grey[900],
      dividerColor: Colors.grey,
      iconTheme: const IconThemeData(color: Colors.white70),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.white),
        bodyMedium: TextStyle(color: Colors.white70),
        titleLarge: TextStyle(color: Colors.tealAccent, fontWeight: FontWeight.bold),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
      ),
    ),

    // Exemplo de tema claro (futuro)
    // AppTheme.light: ThemeData.light(),
  };
}
