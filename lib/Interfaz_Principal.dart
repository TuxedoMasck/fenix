import 'package:fenix/Back_interfas_Principal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InterfazPrincipal extends StatefulWidget {
  const InterfazPrincipal({super.key});

  @override
  State<InterfazPrincipal> createState() => _InterfazPrincipalState();
}

class _InterfazPrincipalState extends State<InterfazPrincipal> {
  @override
  void initState() {
    super.initState();
    // Llama al método para cargar los datos cuando el widget se inicia
    // Y le decimos que no redibuje el widget en este momento.
    Provider.of<InterfazPrincipalLogic>(context, listen: false)
        .cargarDatosUsuario();
  }

  @override
  Widget build(BuildContext context) {
    // Escucha los cambios en la lógica para redibujar la UI cuando sea necesario
    final logic = Provider.of<InterfazPrincipalLogic>(context);

    if (logic.isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Cargando...'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final usuario = logic.usuario!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Interfaz Principal'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () => logic.mostrarNotificaciones(context),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(usuario.nombre),
              accountEmail: Text(usuario.email),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  usuario.inicialAvatar,
                  style: const TextStyle(fontSize: 40.0),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Perfil del usuario'),
              onTap: () => logic.navegarAPerfil(context),
            ),
            ListTile(
              leading: const Icon(Icons.help),
              title: const Text('Ayuda'),
              onTap: () => logic.mostrarAyuda(context),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Menú de opciones'),
              onTap: () => logic.abrirOpciones(context),
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
            // Construye la lista de notificaciones desde la lógica
            ...logic.notificaciones
                .map((notif) => Card(
                      child: ListTile(
                        leading: Icon(notif.icono),
                        title: Text(notif.titulo),
                        subtitle: Text(notif.subtitulo),
                      ),
                    ))
                .toList(),
            const SizedBox(height: 20),
            const Text(
              'Apartado de Cursos',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 150,
              // Construye la lista de cursos desde la lógica
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: logic.cursos.length,
                itemBuilder: (context, index) {
                  final curso = logic.cursos[index];
                  return CursoCard(
                    curso: curso,
                    onPressed: () => logic.abrirCurso(context, curso),
                  );
                },
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
                onPressed: () => logic.mostrarCredencial(context),
                icon: const Icon(Icons.badge),
                label: const Text('Botón de Credencial'),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
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
                initialDate: logic.fechaSeleccionada,
                firstDate: DateTime(2020),
                lastDate: DateTime(2030),
                onDateChanged: (value) => logic.onDateChanged(value),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CursoCard extends StatelessWidget {
  final Curso curso;
  final VoidCallback onPressed;

  const CursoCard({super.key, required this.curso, required this.onPressed});

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
              curso.nombre,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(curso.descripcion),
            const Spacer(),
            ElevatedButton(
              onPressed: onPressed,
              child: const Text('Ir al curso'),
            )
          ],
        ),
      ),
    );
  }
}
