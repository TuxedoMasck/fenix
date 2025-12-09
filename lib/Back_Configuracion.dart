import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfiguracionLogic extends ChangeNotifier {
  static const _notificationsPrefKey = 'notifications_enabled';
  bool _areNotificationsEnabled = true;

  bool get areNotificationsEnabled => _areNotificationsEnabled;

  ConfiguracionLogic() {
    _loadNotificationSetting();
  }

  Future<void> _loadNotificationSetting() async {
    final prefs = await SharedPreferences.getInstance();
    _areNotificationsEnabled = prefs.getBool(_notificationsPrefKey) ?? true;
    notifyListeners();
  }

  Future<void> toggleNotifications(bool value) async {
    if (value) {
      // Si el usuario quiere ACTIVAR las notificaciones
      final status = await Permission.notification.status;

      if (status.isGranted) {
        // El permiso ya está concedido, simplemente activa la lógica.
        _areNotificationsEnabled = true;
      } else if (status.isPermanentlyDenied) {
        // El permiso fue denegado permanentemente. Abre los ajustes de la app.
        await openAppSettings();
        // No cambiamos el estado del interruptor, el usuario debe hacerlo manualmente.
        // Al volver a la app, verificaremos de nuevo el permiso.
        _areNotificationsEnabled = await Permission.notification.isGranted;
      } else {
        // Pide el permiso por primera vez o si fue denegado temporalmente.
        final newStatus = await Permission.notification.request();
        _areNotificationsEnabled = newStatus.isGranted;
      }
    } else {
      // Si el usuario quiere DESACTIVAR las notificaciones
      _areNotificationsEnabled = false;
    }

    // Guarda la última preferencia del usuario
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notificationsPrefKey, _areNotificationsEnabled);
    notifyListeners();
  }
}
