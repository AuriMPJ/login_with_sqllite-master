import 'package:flutter/material.dart';
import 'package:login_with_sqllite/model/carona_model.dart';
import 'package:sqflite/sqflite.dart';

import '../common/routes/view_routes.dart';
import '../model/user_model.dart';
import 'package:login_with_sqllite/external/database/db_sql_lite.dart';

class HomePage extends StatefulWidget {
  //UserModel user;
  // UpdateUser(this.user, {super.key});
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late UserModel user;
  final db = SqlLiteDb();
  List<CaronaModel> caronas = [];

  @override
  initState() {
    super.initState();
    _load();
  }

  _load() async{
    List<CaronaModel> cs = await db.getCaronas();
    setState(() => caronas = cs);
  }

  @override
  void didChangeDependencies() {
    user = ModalRoute.of(context)!.settings.arguments as UserModel;
    _getUserData(user);
    super.didChangeDependencies();
  }

  _getUserData(UserModel user) async {
    setState(() {
      user.userId = user.userId;
      user.userName = user.userName;
      user.userEmail = user.userEmail;
      user.userPassword = user.userPassword;
      // _userPasswordConfirmController.text = user;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            Wrap (
              children: <Widget>[

                ElevatedButton(
                  child: new Text("Editar Cadastro"),
                  onPressed: (){
                    Navigator.pushNamed(
                      context,
                      RoutesApp.loginUpdate,
                      arguments: user,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black, // Background color
                  ),
                ),

                ElevatedButton(
                  child: new Text("Criar Carona"),
                  onPressed: (){
                    Navigator.pushNamed(
                      context,
                      RoutesApp.caronaCreate,
                      arguments: user,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black, // Background color
                  ),
                ),
              ],
            ),

            Expanded (

              child: ListView.builder(
                itemCount: caronas.length,
                itemBuilder: (BuildContext context, int index) {

                  return ListTile(
                      title: Text(caronas[index].caronaOrigem +
                                  " - " +
                                  caronas[index].caronaDestino
                      ),
                      subtitle: Text("Ocorre em " + caronas[index].caronaData +
                                      " as " + caronas[index].caronaHorario
                      ),
                      onTap: (){

                        if(user.userId == caronas[index].caronaIdCriador){
                          Navigator.pushNamed(
                              context,
                              RoutesApp.caronaUpdate,
                              arguments: CaronaModel(caronaId: caronas[index].caronaId, caronaIdCriador: caronas[index].caronaIdCriador, caronaOrigem: caronas[index].caronaOrigem, caronaDestino: caronas[index].caronaDestino, caronaHorario: caronas[index].caronaHorario, caronaData: caronas[index].caronaData)
                          );
                        }

                      },
                  );

                },

              )
            )
          ],
        ),
      ),
    );
  }
}
