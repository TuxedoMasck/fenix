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

  // El logout se ha movido a PerfilUsuarioLogic
}
