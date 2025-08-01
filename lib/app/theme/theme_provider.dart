// app/theme/theme_provider.dart
import 'package:flutter/material.dart';
import 'app_theme_enum.dart';

class ThemeProvider extends ChangeNotifier {
  AppTheme _temaAtual = AppTheme.classicoDark;

  AppTheme get temaAtual => _temaAtual;

  ThemeData get themeData {
    bool isDark = _temaAtual == AppTheme.classicoDark;

    final baseTheme = isDark
        ? ThemeData.dark(useMaterial3: true)
        : ThemeData.light(useMaterial3: true);

    return baseTheme.copyWith(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.teal,
        brightness: isDark ? Brightness.dark : Brightness.light,
      ),
      scaffoldBackgroundColor: isDark ? Colors.black : Colors.white,
      appBarTheme: AppBarTheme(
        backgroundColor: isDark ? Colors.black : Colors.teal,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: Colors.tealAccent,
        unselectedItemColor: Colors.grey,
        backgroundColor: isDark ? Colors.black : Colors.white,
      ),
    );
  }

  void mudarTema(AppTheme novoTema) {
    if (_temaAtual == novoTema) return; // Evita rebuilds desnecessários
    _temaAtual = novoTema;
    notifyListeners();
  }
}