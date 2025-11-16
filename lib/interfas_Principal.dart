
import 'package:flutter/material.dart';

class InterfazPrincipal extends StatelessWidget {
  const InterfazPrincipal({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Interfaz Principal'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Lógica para mostrar notificaciones
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const UserAccountsDrawerHeader(
              accountName: Text("Nombre de Usuario"),
              accountEmail: Text("usuario@correo.com"),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  "U",
                  style: TextStyle(fontSize: 40.0),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Perfil del usuario'),
              onTap: () {
                // Lógica para ir al perfil del usuario
              },
            ),
            ListTile(
              leading: const Icon(Icons.help),
              title: const Text('Ayuda'),
              onTap: () {
                // Lógica para mostrar la ayuda
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Menú de opciones'),
              onTap: () {
                // Lógica para el menú de opciones
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Notificaciones Recientes',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            // Aquí iría una lista de notificaciones recientes
            const Card(
              child: ListTile(
                leading: Icon(Icons.warning),
                title: Text('Notificación 1'),
                subtitle: Text('Descripción de la notificación...'),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Apartado de Cursos',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            // Aquí iría una lista o cuadrícula de cursos
            SizedBox(
              height: 150,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: const [
                  CursoCard(nombre: 'Curso 1'),
                  CursoCard(nombre: 'Curso 2'),
                  CursoCard(nombre: 'Curso 3'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Acceso Rápido',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.description),
                  label: const Text('Documentos'),
                ),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.grade),
                  label: const Text('Calificaciones'),
                ),
              ],
            ),

            const SizedBox(height: 20),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  // Lógica para la credencial
                },
                icon: const Icon(Icons.badge),
                label: const Text('Botón de Credencial'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Calendario',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Card(
              child: CalendarDatePicker(
                initialDate: DateTime.now(),
                firstDate: DateTime(2020),
                lastDate: DateTime(2030),
                onDateChanged: (DateTime value) {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CursoCard extends StatelessWidget {
  final String nombre;
  const CursoCard({super.key, required this.nombre});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(right: 16),
      child: Container(
        width: 200,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              nombre,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const Text('Descripción breve del curso...'),
            const Spacer(),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Ir al curso'),
            )
          ],
        ),
      ),
    );
  }
}
