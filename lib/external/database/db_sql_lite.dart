import 'package:login_with_sqllite/external/database/carona_table_schema.dart';
import 'package:login_with_sqllite/external/database/user_table_schema.dart';
import 'package:login_with_sqllite/model/carona_mapper.dart';
import 'package:login_with_sqllite/model/carona_model.dart';
import 'package:login_with_sqllite/model/user_mapper.dart';
import 'package:login_with_sqllite/model/user_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SqlLiteDb {
  //static final SqlLiteDb instance = SqlLiteDb._();
  static Database? _db;

  //SqlLiteDb._();
  Future<Database> get dbInstance async {
    // retorna a intancia se já tiver sido criada

    if (_db != null) {
      await _db?.execute(UserTableSchema.createUserTableScript());
      await _db?.execute(CaronaTableSchema.createCaronaTableScript());
      return _db!;
    }

    _db = await _initDB('user.db');
    return _db!;
  }

  Future<Database> _initDB(String dbName) async {
    // definie o caminho padrao para salvar o banco
    final dbPath = await getDatabasesPath();

    // define nome e onde sera salvo o banco
    String path = join(dbPath, dbName);

    // cria o banco
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreateSchema,
    );
  }

  // executa script de criacao de tabelas
  Future<void> _onCreateSchema(Database db, int? versao) async {
    await db.execute(UserTableSchema.createUserTableScript());
    await db.execute(CaronaTableSchema.createCaronaTableScript());
  }

  Future<int> saveUser(UserModel user) async {
    var dbClient = await dbInstance;
    var res = await dbClient.insert(
      UserTableSchema.nameTable,
      UserMapper.toMapBD(user),
    );

    return res;
  }

  Future<int> saveCarona(CaronaModel carona) async {
    var dbClient = await dbInstance;
    var res = await dbClient.insert(
      CaronaTableSchema.nameTable,
      CaronaMapper.toMapBD(carona),
    );

    return res;
  }

  Future<int> updateUser(UserModel user) async {
    var dbClient = await dbInstance;
    var res = await dbClient.update(
      UserTableSchema.nameTable,
      UserMapper.toMapBD(user),
      where: '${UserTableSchema.userIDColumn} = ?',
      whereArgs: [user.userId],
    );
    return res;
  }

  Future<int> updateCarona(CaronaModel carona) async {
    var dbClient = await dbInstance;
    var res = await dbClient.update(
      CaronaTableSchema.nameTable,
      CaronaMapper.toMapBD(carona),
      where: '${CaronaTableSchema.caronaIdColumn} = ?',
      whereArgs: [carona.caronaId],
    );
    return res;
  }

  Future<int> deleteUser(String userId) async {
    var dbClient = await dbInstance;
    var res = await dbClient.delete(
      UserTableSchema.nameTable,
      where: '${UserTableSchema.userIDColumn} = ?',
      whereArgs: [userId],
    );
    return res;
  }

  Future<int> deleteCarona(String caronaId) async {
    var dbClient = await dbInstance;
    var res = await dbClient.delete(
      CaronaTableSchema.nameTable,
      where: '${CaronaTableSchema.caronaIdColumn} = ?',
      whereArgs: [caronaId],
    );
    return res;
  }

  Future<UserModel?> getLoginUser(String userId, String password) async {
    var dbClient = await dbInstance;
    var res = await dbClient.rawQuery(
      "SELECT * FROM ${UserTableSchema.nameTable} WHERE "
      "${UserTableSchema.userIDColumn} = '$userId' AND "
      "${UserTableSchema.userPasswordColumn} = '$password'",
    );

    if (res.isNotEmpty) {
      return UserMapper.fromMapBD(res.first);
    }

    return null;
  }

  Future<UserModel?> getUserById(String userId) async {
    var dbClient = await dbInstance;
    var res = await dbClient.rawQuery(
      "SELECT * FROM ${UserTableSchema.nameTable} WHERE "
          "${UserTableSchema.userIDColumn} = '$userId'",
    );

    if (res.isNotEmpty) {
      return UserMapper.fromMapBD(res.first);
    }

    return null;
  }

  Future<CaronaModel?> getCaronaById(String caronaId) async {
    var dbClient = await dbInstance;
    var res = await dbClient.rawQuery(
      "SELECT * FROM ${CaronaTableSchema.nameTable} WHERE "
          "${CaronaTableSchema.caronaIdColumn} = '$caronaId'",
    );

    if (res.isNotEmpty) {
      return CaronaMapper.fromMapBD(res.first);
    }

    return null;
  }

  Future<List<CaronaModel>> getCaronas() async {
    var dbClient = await dbInstance;
    List<CaronaModel> listaModel = [];

    var res = await dbClient.rawQuery(
      "SELECT * FROM ${CaronaTableSchema.nameTable}",
    );

    if (res.isNotEmpty) {

      for(final c in res){
        var atual = c;
        listaModel.add(CaronaMapper.fromMapBD(atual));
      }

      return listaModel;

    }

    return listaModel;
  }
}
