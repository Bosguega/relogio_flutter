import 'package:flutter/material.dart';

class DiasDaSemanaSeletor extends StatefulWidget {
  final List<int> diasSelecionados;
  final ValueChanged<List<int>> onSelecionado;

  const DiasDaSemanaSeletor({
    super.key,
    required this.diasSelecionados,
    required this.onSelecionado,
  });

  @override
  State<DiasDaSemanaSeletor> createState() => _DiasDaSemanaSeletorState();
}

class _DiasDaSemanaSeletorState extends State<DiasDaSemanaSeletor> {
  late List<bool> _selecionados;

  final List<String> _dias = ['D', 'S', 'T', 'Q', 'Q', 'S', 'S']; // Dom a Sáb

  @override
  void initState() {
    super.initState();
    _selecionados = List.generate(7, (i) => widget.diasSelecionados.contains(i));
  }

  void _alternarDia(int index) {
    setState(() {
      _selecionados[index] = !_selecionados[index];
    });
    final selecionados = List<int>.generate(
      7,
      (i) => _selecionados[i] ? i : -1,
    ).where((i) => i != -1).toList();

    widget.onSelecionado(selecionados);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(7, (index) {
        final ativo = _selecionados[index];
        return GestureDetector(
          onTap: () => _alternarDia(index),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: ativo ? Theme.of(context).colorScheme.primary : Colors.transparent,
              shape: BoxShape.circle,
              border: Border.all(color: Theme.of(context).colorScheme.onSurface),
            ),
            child: Text(
              _dias[index],
              style: TextStyle(
                color: ativo
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
        );
      }),
    );
  }
}
