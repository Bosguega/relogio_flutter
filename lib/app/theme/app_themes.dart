import 'package:flutter/material.dart';
import 'app_theme_enum.dart';

class AppThemes {
  static ThemeData _buildTheme({
    required Brightness brightness,
    required Color seed,
    bool pureBlack = false,
  }) {
    final scheme = ColorScheme.fromSeed(
      seedColor: seed,
      brightness: brightness,
    );

    final base = ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
    );

    return base.copyWith(
      scaffoldBackgroundColor:
          pureBlack && brightness == Brightness.dark ? Colors.black : scheme.surface,
      appBarTheme: AppBarTheme(
        backgroundColor:
            pureBlack && brightness == Brightness.dark ? Colors.black : scheme.surface,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        surfaceTintColor: scheme.surfaceTint,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor:
            pureBlack && brightness == Brightness.dark ? Colors.black : scheme.surface,
        selectedItemColor: scheme.primary,
        unselectedItemColor: scheme.onSurfaceVariant,
        showUnselectedLabels: true,
      ),
      textTheme: base.textTheme.apply(
        bodyColor: scheme.onSurface,
        displayColor: scheme.onSurface,
      ),
      iconTheme: IconThemeData(color: scheme.onSurface),
      cardColor: scheme.surfaceContainerHighest,
      dividerColor: scheme.outlineVariant,
    );
  }

  static final themes = {
    AppTheme.classicoDark: _buildTheme(
      brightness: Brightness.dark,
      seed: Colors.teal,
      pureBlack: true,
    ),
    AppTheme.temaClaro: _buildTheme(
      brightness: Brightness.light,
      seed: Colors.teal,
    ),
  };
}
