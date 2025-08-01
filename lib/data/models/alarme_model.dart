import 'package:flutter/material.dart';

class AlarmeModel {
  final String id; // identificador único
  final TimeOfDay hora;
  final bool ativo;
  // Convenção: 1..7 (Seg=1 ... Dom=7) para compatibilidade com DateTime.weekday
  final List<int> diasSelecionados;

  AlarmeModel({
    required this.id,
    required this.hora,
    this.ativo = true,
    this.diasSelecionados = const [],
  });

  factory AlarmeModel.novo({
    required TimeOfDay hora,
    bool ativo = true,
    List<int> diasSelecionados = const [],
  }) {
    final id = '${DateTime.now().microsecondsSinceEpoch}-${hora.hour}:${hora.minute}';
    return AlarmeModel(
      id: id,
      hora: hora,
      ativo: ativo,
      diasSelecionados: List.unmodifiable(diasSelecionados),
    );
  }

  String horaFormatada(BuildContext context) => hora.format(context);

  bool get repetir => diasSelecionados.isNotEmpty;

  bool tocaNoDia(int weekday1to7) => diasSelecionados.contains(weekday1to7);

  AlarmeModel copyWith({
    String? id,
    TimeOfDay? hora,
    bool? ativo,
    List<int>? diasSelecionados,
  }) {
    return AlarmeModel(
      id: id ?? this.id,
      hora: hora ?? this.hora,
      ativo: ativo ?? this.ativo,
      diasSelecionados: diasSelecionados ?? List<int>.from(this.diasSelecionados),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'hora': '${hora.hour.toString().padLeft(2, '0')}:${hora.minute.toString().padLeft(2, '0')}',
      'ativo': ativo,
      'diasSelecionados': diasSelecionados,
    };
  }

  static AlarmeModel fromJson(Map<String, dynamic> json) {
    final parts = (json['hora'] as String).split(':');
    final h = int.parse(parts[0]);
    final m = int.parse(parts[1]);
    return AlarmeModel(
      id: json['id'] as String,
      hora: TimeOfDay(hour: h, minute: m),
      ativo: json['ativo'] as bool? ?? true,
      diasSelecionados: (json['diasSelecionados'] as List?)?.cast<int>() ?? <int>[],
    );
  }
}
