import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:relogio_flutter/data/models/relogio_model.dart';
import 'package:relogio_flutter/data/providers/relogio_selecionado.dart';
import 'package:relogio_flutter/features/relogio_mundial/data/relogios_disponiveis.dart';
import 'package:relogio_flutter/features/relogio_mundial/ui/relogio_fullscreen.dart';

class RelogioMundialScreen extends StatefulWidget {
  const RelogioMundialScreen({super.key});

  @override
  State<RelogioMundialScreen> createState() => _RelogioMundialScreenState();
}

class _RelogioMundialScreenState extends State<RelogioMundialScreen> {
  @override
  void initState() {
    super.initState();
    // Atualiza a tela a cada segundo para atualizar os relógios
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) setState(() {});
      return mounted;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 40),
        ValueListenableBuilder<RelogioModel>(
          valueListenable: relogioSelecionado,
          builder: (context, relogio, _) {
            final horaFormatada = DateFormat.Hms().format(relogio.horaLocal);

            final locale = Localizations.localeOf(context).toLanguageTag();
            final formatador = locale.startsWith('pt')
                ? DateFormat("EEEE, d 'de' MMMM", locale)
                : DateFormat("EEEE, MMMM d", locale);
            String dataFormatada = formatador.format(relogio.horaLocal);

            // Coloca a primeira letra de cada palavra em maiúscula
            dataFormatada = dataFormatada
                .split(' ')
                .map((palavra) => palavra.isNotEmpty
                    ? '${palavra[0].toUpperCase()}${palavra.substring(1)}'
                    : '')
                .join(' ');

            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => RelogioFullscreen(hora: horaFormatada),
                  ),
                );
              },
              child: Column(
                children: [
                  Text(
                    relogio.cidade,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.tealAccent,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    horaFormatada,
                    style: const TextStyle(
                      fontSize: 56,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    dataFormatada,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        ),
        const Divider(thickness: 1, color: Colors.grey),
        Expanded(
          child: ListView.separated(
            itemCount: listaRelogiosDisponiveis.length,
            separatorBuilder: (_, __) => const Divider(color: Colors.grey),
            itemBuilder: (context, index) {
              final cidade = listaRelogiosDisponiveis[index];
              final hora = DateFormat.Hms().format(cidade.horaLocal);
              final isSelecionado = cidade == relogioSelecionado.value;

              return Card(
                color: isSelecionado
                    ? Colors.teal.withAlpha((0.3 * 255).round())
                    : Colors.grey[900],
                elevation: isSelecionado ? 4 : 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  title: Text(
                    cidade.cidade,
                    style: const TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  subtitle: Text(
                    hora,
                    style: const TextStyle(fontSize: 28, color: Colors.white70),
                  ),
                  onTap: () {
                    relogioSelecionado.value = cidade;
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
