import 'package:flutter/material.dart';

class AlarmeModel {
  final TimeOfDay hora;
  bool ativo;
  List<int> diasSelecionados;

  AlarmeModel({
    required this.hora,
    this.ativo = true,
    this.diasSelecionados = const [], // Vazio = uma vez só
  });

  String horaFormatada() {
    final hour = hora.hour.toString().padLeft(2, '0');
    final minute = hora.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  bool get repetir => diasSelecionados.isNotEmpty;

  bool tocaNoDia(int diaDaSemana) {
    return diasSelecionados.contains(diaDaSemana);
  }
}
