import 'package:flutter/material.dart';
import 'package:relogio_flutter/l10n/app_localizations.dart';

import 'package:relogio_flutter/features/alarmes/ui/alarmes_screen.dart';
import 'package:relogio_flutter/features/cronometro/ui/cronometro_screen.dart';
import 'package:relogio_flutter/features/relogio_mundial/ui/relogio_mundial_screen.dart';
import 'package:relogio_flutter/features/timer/ui/timer_screen.dart';
import 'package:relogio_flutter/features/configuracoes/ui/configuracoes_screen.dart';

import 'package:relogio_flutter/app/theme/app_theme_enum.dart';

class AppWidget extends StatefulWidget {
  final Locale locale;
  final AppTheme temaAtual;
  final ValueChanged<Locale> onIdiomaMudado;
  final ValueChanged<AppTheme> onTemaMudado;

  const AppWidget({
    super.key,
    required this.locale,
    required this.temaAtual,
    required this.onIdiomaMudado,
    required this.onTemaMudado,
  });

  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  int _paginaAtual = 0;

  late final List<Widget> _telas = const [
    RelogioMundialScreen(),
    AlarmesScreen(),
    TimerScreen(),
    CronometroScreen(),
  ];

  void _mudarIdioma(Locale novoLocale) => widget.onIdiomaMudado(novoLocale);
  void _mudarTema(AppTheme novoTema) => widget.onTemaMudado(novoTema);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.appTitulo),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: AppLocalizations.of(context)!.settings,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ConfiguracoesScreen(
                    onIdiomaSelecionado: _mudarIdioma,
                    onTemaSelecionado: _mudarTema,
                    temaAtual: widget.temaAtual,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: _paginaAtual,
        children: _telas,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _paginaAtual,
        onTap: (index) => setState(() => _paginaAtual = index),
        selectedItemColor: scheme.primary,
        unselectedItemColor: scheme.onSurfaceVariant,
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
  }
}
