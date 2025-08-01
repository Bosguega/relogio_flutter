// cronometro_screen.dart
import 'package:flutter/material.dart';
import 'package:relogio_flutter/l10n/app_localizations.dart';

class CronometroScreen extends StatelessWidget {
  const CronometroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Center(
      child: Text(
        t.cronometro, // ✅ Texto traduzido!
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );
  }
}