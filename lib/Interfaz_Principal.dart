import 'package:fenix/Back_interfas_Principal.dart';
import 'package:fenix/Interfaz_Credencial.dart';
import 'package:fenix/Interfaz_Cursos.dart';
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

  void _showExpandedImage(BuildContext context, String imageUrl) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.black.withOpacity(0.8),
        pageBuilder: (BuildContext context, _, __) {
          return _FullScreenImageViewer(imageUrl: imageUrl);
        },
      ),
    );
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
              icon: const Icon(Icons.more_vert),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
              tooltip: 'Abrir menú de opciones',
            ),
          ),
        ],
      ),
      endDrawer: const MenuOpciones(),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(usuario.nombre),
              accountEmail: Text(usuario.email),
              currentAccountPicture: GestureDetector(
                onTap: () {
                  if (usuario.avatarUrl != null) {
                    _showExpandedImage(context, usuario.avatarUrl!);
                  }
                },
                child: Hero(
                  tag: usuario.avatarUrl ?? 'user-avatar-main',
                  child: CircleAvatar(
                    backgroundImage: usuario.avatarUrl != null
                        ? NetworkImage(usuario.avatarUrl!)
                        : null,
                    child: usuario.avatarUrl == null
                        ? Text(
                            usuario.inicialAvatar,
                            style: const TextStyle(fontSize: 40.0),
                          )
                        : null,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Perfil del usuario'),
              onTap: () => logic.navegarAPerfil(context),
            ),
            ListTile(
              leading: const Icon(Icons.help_outline),
              title: const Text('Soporte y Ayuda'),
              onTap: () => logic.mostrarAyuda(context),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
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
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const InterfazCursos(),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Acceso Rápido',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              alignment: WrapAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const InterfazCursos(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.school),
                  label: const Text('Mis Cursos'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                  ),
                ),
                ElevatedButton.icon(
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const InterfazCredencial(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.badge),
                  label: const Text('Credencial'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                  ),
                ),
              ],
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

// --- Widget para la Vista de Imagen a Pantalla Completa (reutilizado) ---
class _FullScreenImageViewer extends StatelessWidget {
  final String imageUrl;

  const _FullScreenImageViewer({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Center(
          child: Hero(
            tag: imageUrl, // La etiqueta debe ser única por imagen
            child: InteractiveViewer(
              child: Image.network(imageUrl),
            ),
          ),
        ),
      ),
    );
  }
}
