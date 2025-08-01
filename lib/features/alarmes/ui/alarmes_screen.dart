import 'package:flutter/material.dart';
import 'package:relogio_flutter/data/models/alarme_model.dart';
import 'editar_alarme_screen.dart'; // Importe a tela de edição (criada à parte)

class AlarmesScreen extends StatefulWidget {
  const AlarmesScreen({super.key});

  @override
  State<AlarmesScreen> createState() => _AlarmesScreenState();
}

class _AlarmesScreenState extends State<AlarmesScreen> {
  List<AlarmeModel> alarmes = [];

  @override
  Widget build(BuildContext context) {
    // Ordena os alarmes pela hora (minutos desde meia-noite)
    alarmes.sort((a, b) {
      final aMin = a.hora.hour * 60 + a.hora.minute;
      final bMin = b.hora.hour * 60 + b.hora.minute;
      return aMin.compareTo(bMin);
    });

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Alarmes'),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.add, size: 28),
            onPressed: _adicionarAlarme,
          ),
        ],
      ),
      body: alarmes.isEmpty
          ? const Center(
              child: Text(
                'Nenhum alarme configurado',
                style: TextStyle(color: Colors.white70, fontSize: 18),
              ),
            )
          : ListView.separated(
              itemCount: alarmes.length,
              separatorBuilder: (_, __) =>
                  const Divider(color: Colors.grey, height: 1),
              itemBuilder: (context, index) {
                final alarme = alarmes[index];
                final horaFormatada = _formatarHora(alarme.hora);

                return Card(
                  color: Colors.grey[900],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    title: Text(
                      horaFormatada,
                      style:
                          const TextStyle(fontSize: 28, color: Colors.white),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Switch(
                          value: alarme.ativo,
                          activeColor: Colors.tealAccent.shade400,
                          onChanged: (valor) {
                            setState(() {
                              alarme.ativo = valor;
                            });
                          },
                        ),
                        PopupMenuButton<String>(
                          icon: const Icon(Icons.more_vert, color: Colors.white),
                          onSelected: (value) async {
                            if (value == 'editar') {
                              final alarmeEditado = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => EditarAlarmeScreen(
                                    alarme: alarme,
                                  ),
                                ),
                              );
                              if (alarmeEditado != null) {
                                setState(() {
                                  alarmes[index] = alarmeEditado;
                                });
                              }
                            }
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'editar',
                              child: Text('Editar'),
                            ),
                          ],
                        ),
                      ],
                    ),
                    onTap: () {
                      // Pode abrir edição também se quiser
                    },
                  ),
                );
              },
            ),
    );
  }

  String _formatarHora(TimeOfDay hora) {
    final hour = hora.hour.toString().padLeft(2, '0');
    final minute = hora.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  Future<void> _adicionarAlarme() async {
    final novaHora = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.dark(
            primary: Colors.tealAccent.shade400,
            onSurface: Colors.white,
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(foregroundColor: Colors.tealAccent),
          ),
        ),
        child: child!,
      ),
    );

    if (novaHora != null) {
      setState(() {
        alarmes.add(AlarmeModel(hora: novaHora));
      });
    }
  }
}
