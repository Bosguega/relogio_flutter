import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'app/theme/theme_provider.dart';
import 'app/theme/app_theme_enum.dart';
import 'l10n/app_localizations.dart';
import 'app/app_widget.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const AppRoot(),
    ),
  );
}

class AppRoot extends StatefulWidget {
  const AppRoot({super.key});

  @override
  State<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  Locale _locale = const Locale('pt'); // Idioma padrão

  void _atualizarIdioma(Locale novoIdioma) {
    setState(() {
      _locale = novoIdioma;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        return MaterialApp(
          title: 'Relógio Flutter',
          theme: themeProvider.themeData,
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
          home: AppWidget(),
         
          
        );
      },
    );
  }
}
