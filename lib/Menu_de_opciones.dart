import 'package:fenix/Back_interfas_Principal.dart';
import 'package:fenix/Interfaz_Notificaciones.dart';
import 'package:fenix/Interfaz_Cursos.dart';
import 'package:fenix/Interfaz_Configuracion.dart'; // 1. Importar la nueva pantalla
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Pantalla de marcador de posición
class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text('Pantalla para \'$title\' en construcción.')),
    );
  }
}

class MenuOpciones extends StatelessWidget {
  const MenuOpciones({super.key});

  @override
  Widget build(BuildContext context) {
    final mainLogic = Provider.of<InterfazPrincipalLogic>(context, listen: false);

    void handleTap(String title, IconData icon, Widget screen) {
      final item = QuickAccessItem(icon: icon, title: title, screen: screen);
      mainLogic.registerRecentAction(item);
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
    }

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text('Menú', style: TextStyle(color: Colors.white, fontSize: 24)),
          ),
          ListTile(
            leading: const Icon(Icons.notifications_outlined),
            title: const Text('Notificaciones'),
            onTap: () => handleTap('Notificaciones', Icons.notifications_outlined, const InterfazNotificaciones()),
          ),
          ListTile(
            leading: const Icon(Icons.assignment_outlined),
            title: const Text('Solicitudes'),
            onTap: () => handleTap('Solicitudes', Icons.assignment_outlined, const PlaceholderScreen(title: 'Solicitudes')),
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text('Mi universidad', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          ),
          ListTile(
            leading: const Icon(Icons.schedule),
            title: const Text('Horario'),
            onTap: () => handleTap('Horario', Icons.schedule, const PlaceholderScreen(title: 'Horario')),
          ),
          ListTile(
            leading: const Icon(Icons.grade_outlined),
            title: const Text('Calificaciones'),
            onTap: () => handleTap('Calificaciones', Icons.grade_outlined, const PlaceholderScreen(title: 'Calificaciones')),
          ),
          ListTile(
            leading: const Icon(Icons.school_outlined),
            title: const Text('Inscripción de cursos'),
            onTap: () => handleTap('Inscripción de cursos', Icons.school_outlined, const InterfazCursos()),
          ),
          ListTile(
            leading: const Icon(Icons.delete_outline),
            title: const Text('Baja UEAS'),
            onTap: () => handleTap('Baja UEAS', Icons.delete_outline, const PlaceholderScreen(title: 'Baja UEAS')),
          ),
          ListTile(
            leading: const Icon(Icons.auto_stories_outlined),
            title: const Text('Recuperación/Extraordinarios'),
            onTap: () => handleTap('Recuperación/Extraordinarios', Icons.auto_stories_outlined, const PlaceholderScreen(title: 'Recuperación/Extraordinarios')),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: const Text('Configuración'),
            // 2. Conectar el botón a la nueva pantalla de configuración
            onTap: () => handleTap('Configuración', Icons.settings_outlined, const InterfazConfiguracion()),
          ),
        ],
      ),
    );
  }
}
