import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeLogic extends ChangeNotifier {
  static const _isDarkKey = 'is_dark'; // Usaremos una clave booleana, más simple
  ThemeMode _themeMode = ThemeMode.light; // El valor por defecto siempre será claro

  ThemeMode get themeMode => _themeMode;

  ThemeLogic() {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    // Si no encuentra nada, el valor por defecto es 'false' (modo claro)
    final isDark = prefs.getBool(_isDarkKey) ?? false;
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  void toggleTheme(bool isDark) async {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    // Guardamos el valor booleano directamente
    await prefs.setBool(_isDarkKey, isDark);
  }
}
