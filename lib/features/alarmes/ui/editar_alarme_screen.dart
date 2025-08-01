import 'package:flutter/material.dart';
import 'package:relogio_flutter/data/models/alarme_model.dart';
import 'package:relogio_flutter/l10n/app_localizations.dart';
import 'widgets/dias_da_semana_seletor.dart';

class EditarAlarmeScreen extends StatefulWidget {
  final AlarmeModel alarme;

  const EditarAlarmeScreen({super.key, required this.alarme});

  @override
  State<EditarAlarmeScreen> createState() => _EditarAlarmeScreenState();
}

class _EditarAlarmeScreenState extends State<EditarAlarmeScreen> {
  late TimeOfDay _hora;
  late List<int> _diasSelecionados;

  @override
  void initState() {
    super.initState();
    _hora = widget.alarme.hora;
    _diasSelecionados = List<int>.from(widget.alarme.diasSelecionados);
  }

  Future<void> _selecionarHora() async {
    final t = AppLocalizations.of(context)!;
    final novaHora = await showTimePicker(
      context: context,
      initialTime: _hora,
      helpText: t.selecioneHora,
    );
    if (novaHora != null) {
      setState(() => _hora = novaHora);
    }
  }

  void _salvar() {
    final dias = List<int>.from(_diasSelecionados)..sort();
    final atualizado = widget.alarme.copyWith(
      hora: _hora,
      diasSelecionados: dias,
    );
    Navigator.pop(context, atualizado);
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.editarAlarme),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            tooltip: t.salvar,
            onPressed: _salvar,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              title: Text(t.horario, style: theme.textTheme.titleMedium),
              subtitle: Text(
                _hora.format(context),
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
              trailing: const Icon(Icons.access_time),
              onTap: _selecionarHora,
            ),
          ),
          const SizedBox(height: 16),
          Text(t.repetir, style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          DiasDaSemanaSeletor(
            diasSelecionados: _diasSelecionados,
            onSelecionado: (dias) => setState(() => _diasSelecionados = dias),
          ),
          if (_diasSelecionados.isEmpty) ...[
            const SizedBox(height: 12),
            Text(
              t.repeticaoVaziaUmaVez,
              style: theme.textTheme.bodySmall?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
