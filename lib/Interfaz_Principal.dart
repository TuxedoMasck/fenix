import 'package:fenix/Back_interfas_Principal.dart';
import 'package:fenix/Menu_de_opciones.dart';
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
    Provider.of<InterfazPrincipalLogic>(context, listen: false)
        .cargarDatosUsuario();
  }

  @override
  Widget build(BuildContext context) {
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
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.more_vert), // Icono de tres puntos
              onPressed: () => Scaffold.of(context).openEndDrawer(),
              tooltip: 'Abrir menú de opciones',
            ),
          ),
        ],
      ),
      // Menú lateral derecho
      endDrawer: const MenuOpciones(),
      // Menú lateral izquierdo
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
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: Image.asset(
                          'assets/images/Calendario.png',
                          fit: BoxFit.cover,
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('Cerrar'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                icon: const Icon(Icons.calendar_today),
                label: const Text('Calendario'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
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
