import 'package:flutter/material.dart';
import 'app_theme_enum.dart';
import 'app_themes.dart';

class ThemeProvider extends ChangeNotifier {
  late AppTheme _temaAtual;

  // Construtor público, recebe tema inicial (default classicoDark)
  ThemeProvider({AppTheme temaInicial = AppTheme.classicoDark}) {
    _temaAtual = temaInicial;
  }

  AppTheme get temaAtual => _temaAtual;
  ThemeData get themeData => AppThemes.themes[_temaAtual]!;

  // Método para alterar o tema
  void setTema(AppTheme novoTema) {
    if (_temaAtual == novoTema) return;
    _temaAtual = novoTema;
    notifyListeners();
  }

  // Factory para criar a partir do nome da string
  factory ThemeProvider.fromName(String nomeTema) {
    final tema = AppTheme.values.firstWhere(
      (t) => t.name == nomeTema,
      orElse: () => AppTheme.classicoDark,
    );
    return ThemeProvider(temaInicial: tema);
  }
}
