import 'package:flutter/material.dart';
import 'package:relogio_flutter/data/models/alarme_model.dart';
import 'package:relogio_flutter/features/alarmes/data/alarmes_storage.dart';


class AlarmesProvider extends ChangeNotifier {
  List<AlarmeModel> _alarmes = [];

  List<AlarmeModel> get alarmes => List.unmodifiable(_alarmes);

  Future<void> carregarAlarmes() async {
    _alarmes = await AlarmesStorage.load();
    _ordenar();
    notifyListeners();
  }

  Future<void> adicionar(AlarmeModel novo) async {
    _alarmes.add(novo);
    _ordenar();
    await _salvar();
    notifyListeners();
  }

  Future<void> editar(AlarmeModel editado) async {
    final index = _alarmes.indexWhere((a) => a.id == editado.id);
    if (index != -1) {
      _alarmes[index] = editado;
      _ordenar();
      await _salvar();
      notifyListeners();
    }
  }

  Future<void> remover(String id) async {
    _alarmes.removeWhere((a) => a.id == id);
    await _salvar();
    notifyListeners();
  }

  void _ordenar() {
    _alarmes.sort((a, b) {
      final h1 = a.hora.hour * 60 + a.hora.minute;
      final h2 = b.hora.hour * 60 + b.hora.minute;
      return h1.compareTo(h2);
    });
  }

  Future<void> _salvar() async {
    await AlarmesStorage.save(_alarmes);
  }
}
