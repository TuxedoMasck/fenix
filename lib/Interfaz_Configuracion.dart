import 'package:fenix/Back_Configuracion.dart';
import 'package:fenix/Back_Theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InterfazConfiguracion extends StatelessWidget {
  const InterfazConfiguracion({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Ya estamos proveyendo ThemeLogic en main.dart, así que aquí solo lo consumimos.
        // Este provider es para la lógica específica de esta pantalla.
        ChangeNotifierProvider(create: (_) => ConfiguracionLogic()),
      ],
      child: const _InterfazConfiguracionView(),
    );
  }
}

class _InterfazConfiguracionView extends StatelessWidget {
  const _InterfazConfiguracionView();

  @override
  Widget build(BuildContext context) {
    final themeLogic = context.watch<ThemeLogic>();
    final configLogic = context.watch<ConfiguracionLogic>();

    return Scaffold(
      appBar: AppBar(title: const Text('Configuración')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          SwitchListTile(
            title: const Text('Modo Oscuro'),
            subtitle: const Text('Activa el tema oscuro en toda la aplicación.'),
            value: themeLogic.themeMode == ThemeMode.dark,
            onChanged: (value) {
              themeLogic.toggleTheme(value);
            },
          ),
          const Divider(),
          SwitchListTile(
            title: const Text('Activar Notificaciones'),
            subtitle: const Text('Recibe alertas sobre calificaciones, cursos y avisos.'),
            value: configLogic.areNotificationsEnabled,
            onChanged: (value) {
              configLogic.toggleNotifications(value);
            },
          ),
        ],
      ),
    );
  }
}
