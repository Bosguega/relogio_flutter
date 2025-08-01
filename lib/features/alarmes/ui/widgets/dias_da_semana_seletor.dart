import 'package:flutter/material.dart';

class DiasDaSemanaSeletor extends StatefulWidget {
  // Convenção: 1..7 (Seg=1 ... Dom=7)
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
  late List<bool> _selecionados; // 0..6 mapeia para 1..7

  // Labels curtos Seg..Dom (ideal puxar de AppLocalizations)
  final List<String> _labels = ['S', 'T', 'Q', 'Q', 'S', 'S', 'D'];

  @override
  void initState() {
    super.initState();
    _selecionados = List<bool>.generate(
      7,
      (i) => widget.diasSelecionados.contains(i + 1),
    );
  }

  void _alternarDia(int index) {
    setState(() => _selecionados[index] = !_selecionados[index]);
    final selecionados = <int>[];
    for (var i = 0; i < 7; i++) {
      if (_selecionados[i]) selecionados.add(i + 1);
    }
    widget.onSelecionado(selecionados);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: List<Widget>.generate(7, (index) {
        final ativo = _selecionados[index];
        final label = _labels[index];
        return FilterChip(
          label: Text(label),
          selected: ativo,
          onSelected: (_) => _alternarDia(index),
          showCheckmark: false,
          labelStyle: theme.textTheme.bodyMedium?.copyWith(
            color: ativo ? scheme.onPrimary : scheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
          selectedColor: scheme.primary,
          backgroundColor: scheme.surfaceContainerHighest,
          side: BorderSide(color: scheme.outlineVariant),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        );
      }),
    );
  }
}
