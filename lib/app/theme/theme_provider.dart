import 'package:flutter/material.dart';
import 'app_theme_enum.dart';

class ThemeProvider extends ChangeNotifier {
  AppTheme _temaAtual = AppTheme.classicoDark;

  AppTheme get temaAtual => _temaAtual;

  ThemeData get themeData {
    switch (_temaAtual) {
      case AppTheme.temaClaro:
        return ThemeData.light(useMaterial3: true).copyWith(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        );
      case AppTheme.classicoDark:
      default:
        return ThemeData.dark(useMaterial3: true).copyWith(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        );
    }
  }

  void mudarTema(AppTheme novoTema) {
    _temaAtual = novoTema;
    notifyListeners();
  }
}
