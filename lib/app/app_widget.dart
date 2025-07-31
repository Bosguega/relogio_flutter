import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:relogio_flutter/l10n/app_localizations.dart';
import 'package:relogio_flutter/features/alarmes/ui/alarmes_screen.dart';
import 'package:relogio_flutter/features/cronometro/ui/cronometro_screen.dart';
import 'package:relogio_flutter/features/relogio_mundial/ui/relogio_mundial_screen.dart';
import 'package:relogio_flutter/features/timer/ui/timer_screen.dart';
import 'package:relogio_flutter/features/configuracoes/ui/configuracoes_screen.dart';
import 'package:relogio_flutter/app/theme/app_theme_enum.dart';  // IMPORTA AQUI O ENUM ÚNICO

class AppWidget extends StatefulWidget {
  const AppWidget({super.key});

  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  int _paginaAtual = 0;
  Locale _locale = const Locale('pt');
  AppTheme _temaAtual = AppTheme.classicoDark;

  final _telas = const [
    RelogioMundialScreen(),
    AlarmesScreen(),
    TimerScreen(),
    CronometroScreen(),
  ];

  void _mudarIdioma(Locale novoLocale) {
    setState(() => _locale = novoLocale);
  }

  void _mudarTema(AppTheme novoTema) {
    setState(() => _temaAtual = novoTema);
  }

  ThemeData _obterTema() {
    switch (_temaAtual) {
      case AppTheme.classicoDark:
        return ThemeData.dark(useMaterial3: true).copyWith(
          scaffoldBackgroundColor: Colors.black,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.teal,
            brightness: Brightness.dark,
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            elevation: 0,
          ),
        );

      case AppTheme.temaClaro:
        return ThemeData.light(useMaterial3: true).copyWith(
          scaffoldBackgroundColor: Colors.white,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.teal,
            brightness: Brightness.light,
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
            elevation: 0,
          ),
        );

      // Se quiser pode colocar um default, mas não obrigatório pois cobriu todos os casos
      // default:
      //   return ThemeData.dark(useMaterial3: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: _locale,
      supportedLocales: const [
        Locale('pt'),
        Locale('en'),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: _obterTema(),
      home: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
             
              actions: [
                IconButton(
                  icon: const Icon(Icons.settings, color: Colors.white),
                  tooltip: AppLocalizations.of(context)!.settings,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ConfiguracoesScreen(
                          onIdiomaSelecionado: _mudarIdioma,
                          onTemaSelecionado: _mudarTema,
                          temaAtual: _temaAtual,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            body: _telas[_paginaAtual],
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: _paginaAtual,
              onTap: (index) {
                setState(() => _paginaAtual = index);
              },
              selectedItemColor: Colors.tealAccent,
              unselectedItemColor: Colors.grey,
              items: [
                BottomNavigationBarItem(
                  icon: const Icon(Icons.public),
                  label: AppLocalizations.of(context)!.relMundial,
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.alarm),
                  label: AppLocalizations.of(context)!.alarmes,
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.timer),
                  label: AppLocalizations.of(context)!.timer,
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.av_timer),
                  label: AppLocalizations.of(context)!.cronometro,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
