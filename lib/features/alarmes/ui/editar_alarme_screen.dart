import 'package:flutter/material.dart';
import '../../../data/models/alarme_model.dart';
import 'widgets/dias_da_semana_seletor.dart';
import 'package:relogio_flutter/l10n/app_localizations.dart';

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
    _diasSelecionados = List.from(widget.alarme.diasSelecionados);
  }

  void _selecionarHora() async {
    final novaHora = await showTimePicker(
      context: context,
      initialTime: _hora,
    );
    if (novaHora != null) {
      setState(() => _hora = novaHora);
    }
  }

  void _salvar() {
    _diasSelecionados.sort();
    final novoAlarme = AlarmeModel(
      hora: _hora,
      ativo: widget.alarme.ativo,
      diasSelecionados: _diasSelecionados,
    );
    Navigator.pop(context, novoAlarme);
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.editarAlarme),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _salvar,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ListTile(
              title: Text(t.horario),
              subtitle: Text(_hora.format(context)),
              trailing: const Icon(Icons.access_time),
              onTap: _selecionarHora,
            ),
            const SizedBox(height: 24),
            DiasDaSemanaSeletor(
              diasSelecionados: _diasSelecionados,
              onSelecionado: (dias) {
                setState(() {
                  _diasSelecionados = dias;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
