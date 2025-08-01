import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:relogio_flutter/data/models/alarme_model.dart';
import 'package:relogio_flutter/features/alarmes/logic/alarmes_provider.dart';
import 'package:relogio_flutter/l10n/app_localizations.dart';
import 'editar_alarme_screen.dart';

class AlarmesScreen extends StatelessWidget {
  const AlarmesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final alarmesProvider = context.watch<AlarmesProvider>();
    final alarmes = alarmesProvider.alarmes;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.alarmes),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: t.adicionar,
            onPressed: () => _adicionarAlarme(context),
          ),
        ],
      ),
      body: alarmes.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  t.nenhumAlarme,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          : ListView.separated(
              itemCount: alarmes.length,
              separatorBuilder: (_, __) => Divider(
                color: scheme.outlineVariant,
                height: 1,
              ),
              itemBuilder: (context, index) {
                final alarme = alarmes[index];
                final horaFormatada = alarme.hora.format(context);

                return Dismissible(
                  key: ValueKey(alarme.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    color: scheme.errorContainer,
                    child: Icon(Icons.delete, color: scheme.onErrorContainer),
                  ),
                  onDismissed: (_) => _excluirAlarme(context, alarme),
                  child: Card(
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: ListTile(
                      title: Text(
                        horaFormatada,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Switch(
                            value: alarme.ativo,
                            onChanged: (valor) {
                              final atualizado = alarme.copyWith(ativo: valor);
                              context.read<AlarmesProvider>().editar(atualizado);
                            },
                          ),
                          PopupMenuButton<String>(
                            onSelected: (value) {
                              if (value == 'editar') {
                                _editarAlarme(context, alarme);
                              } else if (value == 'excluir') {
                                _excluirAlarme(context, alarme);
                              }
                            },
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                value: 'editar',
                                child: Text(t.editar),
                              ),
                              PopupMenuItem(
                                value: 'excluir',
                                child: Text(t.excluir),
                              ),
                            ],
                          ),
                        ],
                      ),
                      onTap: () => _editarAlarme(context, alarme),
                    ),
                  ),
                );
              },
            ),
    );
  }

  Future<void> _adicionarAlarme(BuildContext context) async {
    final t = AppLocalizations.of(context)!;
    final novaHora = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      helpText: t.selecioneHora,
    );

    if (novaHora != null) {
      final novo = AlarmeModel.novo(hora: novaHora);
      await context.read<AlarmesProvider>().adicionar(novo);
    }
  }

  Future<void> _editarAlarme(BuildContext context, AlarmeModel alarme) async {
    final editado = await Navigator.push<AlarmeModel?>(
      context,
      MaterialPageRoute(
        builder: (context) => EditarAlarmeScreen(alarme: alarme),
      ),
    );

    if (editado != null) {
      await context.read<AlarmesProvider>().editar(editado);
    }
  }

  Future<void> _excluirAlarme(BuildContext context, AlarmeModel alarme) async {
    final t = AppLocalizations.of(context)!;
    await context.read<AlarmesProvider>().remover(alarme.id);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(t.alarmExcluido),
        action: SnackBarAction(
          label: t.desfazer ?? 'Desfazer',
          onPressed: () async {
            await context.read<AlarmesProvider>().adicionar(alarme);
          },
        ),
      ),
    );
  }
}
