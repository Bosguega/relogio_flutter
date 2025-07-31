import 'package:flutter/material.dart';
import 'package:relogio_flutter/data/models/relogio_model.dart';
import 'package:relogio_flutter/features/relogio_mundial/data/relogios_disponiveis.dart';

final relogioSelecionado = ValueNotifier<RelogioModel>(listaRelogiosDisponiveis[0]);
