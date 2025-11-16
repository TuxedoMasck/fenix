import 'package:fenix/login.dart';
import 'package:flutter/material.dart';

class MenuOpcionesLogic extends ChangeNotifier {
  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  bool _areNotificationsEnabled = true;
  bool get areNotificationsEnabled => _areNotificationsEnabled;

  void toggleDarkMode(bool value) {
    _isDarkMode = value;
    notifyListeners();
    // Aquí podrías guardar la preferencia del usuario
  }

  void toggleNotifications(bool value) {
    _areNotificationsEnabled = value;
    notifyListeners();
    // Aquí podrías guardar la preferencia del usuario
  }

  void logout(BuildContext context) {
    // Lógica para limpiar datos de sesión si es necesario

    // Navega a la pantalla de login y elimina todas las rutas anteriores
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => LoginPage()),
      (Route<dynamic> route) => false,
    );
  }
}
