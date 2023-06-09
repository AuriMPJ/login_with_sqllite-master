import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import '../common/routes/view_routes.dart';
import '../components/user_login_header.dart';
import '../model/user_model.dart';
import '../model/carona_model.dart';

import '../common/messages/messages.dart';
import '../components/user_text_field.dart';
import '../external/database/db_sql_lite.dart';

class UpdateCarona extends StatefulWidget {
  //UserModel user;
  // UpdateUser(this.user, {super.key});
  const UpdateCarona({super.key});

  @override
  State<UpdateCarona> createState() => _UpdateCaronaFormState();
}

class _UpdateCaronaFormState extends State<UpdateCarona> {
  final _formKey = GlobalKey<FormState>();
  final _caronaHorarioController = TextEditingController();
  final _caronaDataController = TextEditingController();
  final _caronaDestinoController = TextEditingController();
  final _caronaOrigemController = TextEditingController();
  late CaronaModel carona;
  late UserModel user;
  final db = SqlLiteDb();

  @override
  void didChangeDependencies() {
    carona = ModalRoute.of(context)!.settings.arguments as CaronaModel;
    _getCaronaData(carona);
    super.didChangeDependencies();
  }

  _load() async{
    UserModel? um = await db.getUserById(carona.caronaIdCriador); // load the users on Widget init
    if(um!=null) {
      user=um;
    }
  }

  _getCaronaData(CaronaModel carona) async {
    setState(() {
      _caronaHorarioController.text = carona.caronaHorario;
      _caronaDataController.text = carona.caronaData;
      _caronaDestinoController.text = carona.caronaDestino;
      _caronaOrigemController.text = carona.caronaOrigem;
      // _userPasswordConfirmController.text = user;
    });
    _load();
  }

  _updateCaronaData(BuildContext context) {
    if (_formKey.currentState!.validate()) {

      CaronaModel caronaUpdated = CaronaModel(
        caronaId: carona.caronaId,
        caronaIdCriador: carona.caronaIdCriador,
        caronaHorario: _caronaHorarioController.text.trim(),
        caronaData: _caronaDataController.text.trim(),
        caronaDestino: _caronaDestinoController.text.trim(),
        caronaOrigem: _caronaOrigemController.text.trim(),
      );

      final db = SqlLiteDb();
      db.updateCarona(caronaUpdated).then(
            (value) {
          AwesomeDialog(
            context: context,
            headerAnimationLoop: false,
            dialogType: DialogType.success,
            title: MessagesApp.successUserUpdate,
            btnOkOnPress: () => Navigator.pushNamedAndRemoveUntil(
                context, RoutesApp.homePage, arguments: user, (Route<dynamic> route) => false),
            btnOkText: 'OK',
          ).show();
        },
      ).catchError((error) {
        AwesomeDialog(
          context: context,
          headerAnimationLoop: false,
          dialogType: DialogType.error,
          title: MessagesApp.errorUserNoUpdate,
          btnCancelOnPress: () => Navigator.pop(context),
          btnCancelText: 'OK',
        ).show();
      });
    }
  }

  _deleteCaronaData(BuildContext context) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      headerAnimationLoop: false,
      // animType: AnimType.topSlide,
      title: 'Confirma Exclusão???',
      btnCancelOnPress: () => Navigator.pop(context),
      btnOkText: 'Sim',
      btnOkOnPress: () {
        final db = SqlLiteDb();
        db.deleteCarona(carona.caronaId).then(
              (value) {
            AwesomeDialog(
              context: context,
              headerAnimationLoop: false,
              dialogType: DialogType.success,
              title: MessagesApp.successUserDelete,
              btnOkOnPress: () => Navigator.pushNamedAndRemoveUntil(
                  context, RoutesApp.homePage, arguments: user, (Route<dynamic> route) => false),
              btnOkText: 'OK',
            ).show();
          },
        ).catchError((error) {
          AwesomeDialog(
            context: context,
            headerAnimationLoop: false,
            dialogType: DialogType.error,
            title: MessagesApp.errorDefault,
            btnCancelOnPress: () => Navigator.pop(context),
            btnCancelText: 'OK',
          ).show();
        });
      },
      btnCancelText: 'Cancelar',
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Atualização de Carona'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 20),
          child: Center(
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const UserLoginHeader('Atualização dos Dados'),
                UserTextField(
                  hintName: 'Origem',
                  icon: Icons.person,
                  controller: _caronaOrigemController,
                ),
                UserTextField(
                  hintName: 'Destino',
                  icon: Icons.person_2_outlined,
                  controller: _caronaDestinoController,
                ),
                UserTextField(
                  hintName: 'Data',
                  icon: Icons.email,
                  controller: _caronaDataController,
                  inputType: TextInputType.emailAddress,
                ),
                UserTextField(
                  hintName: 'Horario',
                  icon: Icons.lock,
                  controller: _caronaHorarioController,
                ),

                Container(
                  padding: const EdgeInsets.only(
                    top: 30,
                    left: 40,
                    right: 40,
                  ),
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _updateCaronaData(context),
                          style: ElevatedButton.styleFrom(
                              shape: const StadiumBorder()),
                          child: const Text(
                            'Atualizar',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _deleteCaronaData(context),
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                              Theme.of(context).colorScheme.error,
                              shape: const StadiumBorder()),
                          child: const Text(
                            'Deletar',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
