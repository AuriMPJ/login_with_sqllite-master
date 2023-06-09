abstract class CaronaTableSchema {
  static const String nameTable = "carona";
  static const String caronaIdColumn = 'id';
  static const String caronaIdCriadorColumn = 'idCriador';
  static const String caronaDataColumn = 'data';
  static const String caronaOrigemColumn = 'origem';
  static const String caronaDestinoColumn = 'destino';
  static const String caronaHorarioColumn = 'horario';

  static String createCaronaTableScript() => '''
    CREATE TABLE IF NOT EXISTS $nameTable (
        $caronaIdColumn TEXT NOT NULL PRIMARY KEY, 
        $caronaIdCriadorColumn TEXT NOT NULL, 
        $caronaDataColumn TEXT NOT NULL, 
        $caronaOrigemColumn TEXT NOT NULL,
        $caronaDestinoColumn TEXT NOT NULL,
        $caronaHorarioColumn TEXT NOT NULL
        )
      ''';
}
