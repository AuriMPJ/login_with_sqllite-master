class CaronaModel {
  String caronaId;
  String caronaIdCriador;
  String caronaOrigem;
  String caronaDestino;
  String caronaHorario;
  String caronaData;

  CaronaModel({
    required this.caronaId,
    required this.caronaIdCriador,
    required this.caronaOrigem,
    required this.caronaDestino,
    required this.caronaHorario,
    required this.caronaData,
  });

  @override
  String toString() {
    return 'CaronaModel(caronaId: $caronaId, caronaIdCriador: $caronaIdCriador, caronaOrigem: $caronaOrigem, caronaDestino: $caronaDestino, caronaHorario: $caronaHorario, caronaData: $caronaData)';
  }
}
