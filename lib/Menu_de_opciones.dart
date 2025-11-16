import 'package:fenix/Back_menu_opciones.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MenuOpciones extends StatelessWidget {
  const MenuOpciones({super.key});

  @override
  Widget build(BuildContext context) {
    final logic = Provider.of<MenuOpcionesLogic>(context);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Opciones',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          SwitchListTile(
            title: const Text('Modo Oscuro'),
            value: logic.isDarkMode,
            onChanged: logic.toggleDarkMode,
          ),
          SwitchListTile(
            title: const Text('Notificaciones'),
            value: logic.areNotificationsEnabled,
            onChanged: logic.toggleNotifications,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Cerrar Sesión'),
            onTap: () => logic.logout(context),
          ),
        ],
      ),
    );
  }
}
