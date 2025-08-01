import 'package:flutter/material.dart';
import 'package:relogio_flutter/l10n/app_localizations.dart';
import 'package:relogio_flutter/app/theme/app_theme_enum.dart';

class ConfiguracoesScreen extends StatelessWidget {
  final void Function(Locale) onIdiomaSelecionado;
  final void Function(AppTheme) onTemaSelecionado;
  final AppTheme temaAtual;

  const ConfiguracoesScreen({
    super.key,
    required this.onIdiomaSelecionado,
    required this.onTemaSelecionado,
    required this.temaAtual,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final localeAtual = Localizations.localeOf(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.settings),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          Text(t.language, style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          _SelecaoTile(
            label: t.portuguese,
            selecionado: localeAtual.languageCode == 'pt',
            onTap: () {
              onIdiomaSelecionado(const Locale('pt'));
              Navigator.pop(context);
            },
          ),
          _SelecaoTile(
            label: t.english,
            selecionado: localeAtual.languageCode == 'en',
            onTap: () {
              onIdiomaSelecionado(const Locale('en'));
              Navigator.pop(context);
            },
          ),
          const SizedBox(height: 24),
          Text(t.theme, style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          _SelecaoTile(
            label: t.temaClassicoDark,
            selecionado: temaAtual == AppTheme.classicoDark,
            onTap: () {
              onTemaSelecionado(AppTheme.classicoDark);
              Navigator.pop(context);
            },
          ),
          _SelecaoTile(
            label: t.temaClaro,
            selecionado: temaAtual == AppTheme.temaClaro,
            onTap: () {
              onTemaSelecionado(AppTheme.temaClaro);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

class _SelecaoTile extends StatelessWidget {
  final String label;
  final bool selecionado;
  final VoidCallback onTap;

  const _SelecaoTile({
    required this.label,
    required this.selecionado,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      color: selecionado ? scheme.primaryContainer : null,
      child: ListTile(
        title: Text(
          label,
          style: TextStyle(
            color: selecionado ? scheme.onPrimaryContainer : null,
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: selecionado
            ? Icon(Icons.check, color: scheme.primary)
            : null,
        onTap: onTap,
      ),
    );
  }
}
