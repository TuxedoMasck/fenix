import 'package:flutter/material.dart';

class MenuOpciones extends StatelessWidget {
  const MenuOpciones({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue, // Puedes cambiar este color
            ),
            child: Text(
              'Menú',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.notifications_outlined),
            title: const Text('Notificaciones'),
            onTap: () {
              // TODO: Navegar a la pantalla de notificaciones
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.assignment_outlined),
            title: const Text('Solicitudes'),
            onTap: () {
              // TODO: Navegar a la pantalla de solicitudes
              Navigator.pop(context);
            },
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              'Mi universidad',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          _buildUniversityOption(icon: Icons.schedule, title: 'Horario', onTap: () => Navigator.pop(context)),
          _buildUniversityOption(icon: Icons.grade_outlined, title: 'Calificaciones', onTap: () => Navigator.pop(context)),
          _buildUniversityOption(icon: Icons.school_outlined, title: 'Inscripción de cursos', onTap: () => Navigator.pop(context)),
          _buildUniversityOption(icon: Icons.delete_outline, title: 'Baja UEAS', onTap: () => Navigator.pop(context)),
          _buildUniversityOption(icon: Icons.auto_stories_outlined, title: 'Recuperación/Extraordinarios', onTap: () => Navigator.pop(context)),
          const Divider(),
           ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: const Text('Configuración'),
            onTap: () {
              // TODO: Navegar a la pantalla de configuración
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildUniversityOption({required IconData icon, required String title, required VoidCallback onTap}){
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
    );
  }
}
