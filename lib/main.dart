import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/theme/theme_provider.dart';
import 'app/theme/app_theme_enum.dart';
import 'l10n/app_localizations.dart';
import 'app/app_widget.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Carrega idioma e tema salvos (ou usa padrão se não houver)
  final prefs = await SharedPreferences.getInstance();
  final savedLanguageCode = prefs.getString('language_code') ?? 'pt';
  final savedThemeName = prefs.getString('theme') ?? AppTheme.classicoDark.name;

  // Valida se o tema salvo é válido, para evitar erro no fromName
  final savedTheme = AppTheme.values.firstWhere(
    (t) => t.name == savedThemeName,
    orElse: () => AppTheme.classicoDark,
  );

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider.fromName(savedTheme.name),
      child: AppRoot(
        initialLocale: Locale(savedLanguageCode),
      ),
    ),
  );
}

class AppRoot extends StatefulWidget {
  const AppRoot({super.key, required this.initialLocale});
  final Locale initialLocale;

  @override
  State<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  late Locale _locale;

  @override
  void initState() {
    super.initState();
    _locale = widget.initialLocale;
  }

  Future<void> _atualizarIdioma(Locale novoIdioma) async {
    setState(() => _locale = novoIdioma);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', novoIdioma.languageCode);
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
          localeResolutionCallback: (deviceLocale, supported) {
            if (deviceLocale == null) return const Locale('pt');
            for (final locale in supported) {
              if (locale.languageCode == deviceLocale.languageCode) {
                return locale;
              }
            }
            return const Locale('pt');
          },
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: AppWidget(
            locale: _locale,
            temaAtual: themeProvider.temaAtual,
            onIdiomaMudado: _atualizarIdioma,
            onTemaMudado: (novoTema) async {
              themeProvider.setTema(novoTema);

              final prefs = await SharedPreferences.getInstance();
              await prefs.setString('theme', novoTema.name);
            },
          ),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
