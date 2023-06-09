import 'package:flutter/material.dart';
import 'package:login_with_sqllite/model/carona_model.dart';
import 'package:login_with_sqllite/model/user_model.dart';
import 'package:login_with_sqllite/screen/criarCarona.dart';
import 'package:login_with_sqllite/screen/login_form.dart';
import 'package:login_with_sqllite/screen/signup_form.dart';
import 'package:login_with_sqllite/screen/updateCarona.dart';
import 'package:login_with_sqllite/screen/update_form.dart';
import 'package:login_with_sqllite/screen/homePage.dart';

class RoutesApp {
  static const home = '/';
  static const loginSgnup = '/loginSignup';
  static const loginUpdate = '/loginUpdate';
  static const homePage = '/homePage';
  static const caronaCreate = '/caronaCreate';
  static const caronaUpdate = '/caronaUpdate';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final arguments = settings.arguments;
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (context) => const LoginForm());

      case loginSgnup:
        return MaterialPageRoute(builder: (context) => const SignUp());

      case caronaCreate:
        if (arguments is UserModel) {
          return MaterialPageRoute(
            // builder: (context) => UdpateUser(arguments),
            builder: (context) => const CreateCarona(),
            settings: settings,
          );
        } else {
          return _errorRoute();
        }


      case loginUpdate:
        if (arguments is UserModel) {
          return MaterialPageRoute(
            builder: (context) => const UpdateUser(),
            settings: settings,
          );
        } else {
          return _errorRoute();
        }

      case caronaUpdate:
        if (arguments is CaronaModel) {
          return MaterialPageRoute(
            builder: (context) => const UpdateCarona(),
            settings: settings,
          );
        } else {
          return _errorRoute();
        }

      case homePage:
        if (arguments is UserModel) {
          return MaterialPageRoute(
            builder: (context) => const HomePage(),
            settings: settings,
          );
        } else {
          return _errorRoute();
        }

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
