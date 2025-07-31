class RelogioModel {
  final String cidade;
  final Duration diferencaUtc;

  const RelogioModel({
    required this.cidade,
    required this.diferencaUtc,
  });

  DateTime get horaLocal {
    final utcNow = DateTime.now().toUtc();
    return utcNow.add(diferencaUtc);
  }
}
