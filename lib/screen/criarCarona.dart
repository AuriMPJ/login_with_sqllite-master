import 'dart:math';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

import '../common/messages/messages.dart';
import '../common/routes/view_routes.dart';
import '../components/user_login_header.dart';
import '../components/user_text_field.dart';
import '../external/database/db_sql_lite.dart';
import '../model/user_model.dart';
import '../model/carona_model.dart';

class CreateCarona extends StatefulWidget {
  const CreateCarona({super.key});

  @override
  State<CreateCarona> createState() => _CreateCaronaState();
}

class _CreateCaronaState extends State<CreateCarona> {
  final _formKey = GlobalKey<FormState>();
  final _caronaHorarioController = TextEditingController();
  final _caronaDataController = TextEditingController();
  final _caronaDestinoController = TextEditingController();
  final _caronaOrigemController = TextEditingController();
  late final CaronaModel carona;
  late final UserModel user = ModalRoute.of(context)!.settings.arguments as UserModel;

  @override
  void dispose() {
    _caronaHorarioController.dispose();
    _caronaDataController.dispose();
    _caronaDestinoController.dispose();
    _caronaOrigemController.dispose();
    super.dispose();
  }

  void signUp(BuildContext context) async {
    Random random = new Random();
    // Retorna TRUE em caso de
    // conteudo valido de todos os campos
    if (_formKey.currentState!.validate()) {
      CaronaModel carona = CaronaModel(
        caronaId: random.nextInt(100000).toString(),
        caronaIdCriador: user.userId,
        caronaHorario: _caronaHorarioController.text.trim(),
        caronaData: _caronaDataController.text.trim(),
        caronaDestino: _caronaDestinoController.text.trim(),
        caronaOrigem: _caronaOrigemController.text.trim(),
      );

      final db = SqlLiteDb();
      db.saveCarona(carona).then(
            (value) {
          AwesomeDialog(
            context: context,
            headerAnimationLoop: false,
            dialogType: DialogType.success,
            title: MessagesApp.successUserInsert,
            btnOkOnPress: () => Navigator.pushNamedAndRemoveUntil(
                context, RoutesApp.homePage, arguments: user, (Route<dynamic> route) => false),
            btnOkText: 'OK',
          ).show(); // Message
        },
      ).catchError((error) {
        if (error.toString().contains('UNIQUE constraint failed')) {
          MessagesApp.showCustom(
            context,
            MessagesApp.errorUserExist,
          );
        } else {
          MessagesApp.showCustom(
            context,
            MessagesApp.errorDefault,
          );
        }
      });
      // await db.saveUser(user);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Carona'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 20),
          child: Center(
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const UserLoginHeader('Cadastrar Login'),
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
                    left: 80,
                    right: 80,
                  ),
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => signUp(context),
                    style:
                    ElevatedButton.styleFrom(shape: const StadiumBorder()),
                    child: const Text(
                      'Cadastrar',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(
                    top: 20,
                    left: 10,
                    right: 10,
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
