import 'package:flutter/material.dart';
import 'package:relogio_flutter/l10n/app_localizations.dart';
import 'package:relogio_flutter/app/theme/app_theme_enum.dart';  // Enum com os temas (criaremos em breve)

class ConfiguracoesScreen extends StatelessWidget {
  final void Function(Locale) onIdiomaSelecionado;
  final void Function(AppTheme) onTemaSelecionado;  // novo callback

  final AppTheme temaAtual; // tema atual para marcar selecionado

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

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Setinha pra voltar
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              const SizedBox(height: 8),
              Text(
                t.settings,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),

              // Seção de Idioma
              ExpansionTile(
                tilePadding: EdgeInsets.zero,
                collapsedIconColor: Colors.white,
                iconColor: Colors.white,
                title: Text(
                  t.language,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                childrenPadding: const EdgeInsets.only(left: 12),
                backgroundColor: Colors.transparent,
                collapsedBackgroundColor: Colors.transparent,
                children: [
                  _buildIdiomaBotao(
                    context,
                    label: 'Português',
                    locale: const Locale('pt'),
                    selecionado: localeAtual.languageCode == 'pt',
                  ),
                  const SizedBox(height: 8),
                  _buildIdiomaBotao(
                    context,
                    label: 'English',
                    locale: const Locale('en'),
                    selecionado: localeAtual.languageCode == 'en',
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Seção de Tema
              ExpansionTile(
                tilePadding: EdgeInsets.zero,
                collapsedIconColor: Colors.white,
                iconColor: Colors.white,
                title: Text(
                  t.theme,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                childrenPadding: const EdgeInsets.only(left: 12),
                backgroundColor: Colors.transparent,
                collapsedBackgroundColor: Colors.transparent,
                children: [
                  _buildTemaBotao(
                    context,
                    label: 'Clássico Dark',
                    tema: AppTheme.classicoDark,
                    selecionado: temaAtual == AppTheme.classicoDark,
                  ),
                  const SizedBox(height: 8),
                  _buildTemaBotao(
                    context,
                    label: 'Tema Claro',
                    tema: AppTheme.temaClaro,
                    selecionado: temaAtual == AppTheme.temaClaro,
                  ),
                  // Adicione mais temas aqui quando quiser
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIdiomaBotao(
    BuildContext context, {
    required String label,
    required Locale locale,
    required bool selecionado,
  }) {
    return GestureDetector(
      onTap: () {
        onIdiomaSelecionado(locale);
        Navigator.pop(context);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8, right: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: selecionado ? Colors.teal : Colors.grey[900],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selecionado ? Colors.tealAccent : Colors.white24,
            width: 1.2,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selecionado ? Colors.black : Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildTemaBotao(
    BuildContext context, {
    required String label,
    required AppTheme tema,
    required bool selecionado,
  }) {
    return GestureDetector(
      onTap: () {
        onTemaSelecionado(tema);
        Navigator.pop(context);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8, right: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: selecionado ? Colors.teal : Colors.grey[900],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selecionado ? Colors.tealAccent : Colors.white24,
            width: 1.2,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selecionado ? Colors.black : Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
