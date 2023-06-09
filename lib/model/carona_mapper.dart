import 'package:login_with_sqllite/external/database/carona_table_schema.dart';
import 'package:login_with_sqllite/model/carona_model.dart';

abstract class CaronaMapper {
  // Mapeia um Usuario para o formato a ser salvo
  // no banco de dados
  static Map<String, dynamic> toMapBD(CaronaModel carona) {
    return {
      CaronaTableSchema.caronaDataColumn: carona.caronaData,
      CaronaTableSchema.caronaDestinoColumn: carona.caronaDestino,
      CaronaTableSchema.caronaHorarioColumn: carona.caronaHorario,
      CaronaTableSchema.caronaIdColumn: carona.caronaId,
      CaronaTableSchema.caronaIdCriadorColumn: carona.caronaIdCriador,
      CaronaTableSchema.caronaOrigemColumn: carona.caronaOrigem,
    };
  }

  // Mapeia um Map vindo do SqlLite para um
  // uma classer UserModel
  static CaronaModel fromMapBD(Map<String, dynamic> map) {
    return CaronaModel(
      caronaData: map[CaronaTableSchema.caronaDataColumn],
      caronaDestino: map[CaronaTableSchema.caronaDestinoColumn],
      caronaHorario: map[CaronaTableSchema.caronaHorarioColumn],
      caronaId: map[CaronaTableSchema.caronaIdColumn],
      caronaIdCriador: map[CaronaTableSchema.caronaIdCriadorColumn],
      caronaOrigem: map[CaronaTableSchema.caronaOrigemColumn],
    );
  }

  // clona um UserModel
  static CaronaModel cloneUser(CaronaModel carona) {
    return CaronaModel(
      caronaId: carona.caronaId,
      caronaIdCriador: carona.caronaIdCriador,
      caronaDestino: carona.caronaDestino,
      caronaHorario: carona.caronaHorario,
      caronaData: carona.caronaData,
      caronaOrigem: carona.caronaOrigem,
    );
  }
}
