import 'package:fenix/Back_interfas_Principal.dart';
import 'package:fenix/Back_cursos.dart';
import 'package:fenix/Interfaz_Credencial.dart';
import 'package:fenix/Interfaz_Cursos.dart';
import 'package:fenix/Interfaz_DetalleCurso.dart'; // 1. Importar la nueva pantalla
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
    Provider.of<InterfazPrincipalLogic>(context, listen: false).initialize();
  }

  @override
  Widget build(BuildContext context) {
    final logic = context.watch<InterfazPrincipalLogic>();

    if (logic.isLoading) {
      return Scaffold(appBar: AppBar(title: const Text('Cargando...')), body: const Center(child: CircularProgressIndicator()));
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
              currentAccountPicture: CircleAvatar(
                backgroundImage: usuario.avatarUrl != null ? NetworkImage(usuario.avatarUrl!) : null,
                child: usuario.avatarUrl == null ? Text(usuario.inicialAvatar, style: const TextStyle(fontSize: 40.0)) : null,
              ),
            ),
            ListTile(leading: const Icon(Icons.person), title: const Text('Perfil del usuario'), onTap: () => logic.navegarAPerfil(context)),
            ListTile(leading: const Icon(Icons.help_outline), title: const Text('Soporte y Ayuda'), onTap: () => logic.mostrarAyuda(context)),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Apartado de Cursos', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            logic.cursos.isEmpty
                ? ElevatedButton.icon(
                    icon: const Icon(Icons.school_outlined),
                    label: const Text('Ir a Mis Cursos'),
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const InterfazCursos())),
                  )
                : Column(
                    children: [
                      SizedBox(
                        height: 150,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: logic.cursos.length,
                          itemBuilder: (context, index) {
                            final curso = logic.cursos[index];
                            return CursoCard(
                              curso: curso,
                              // 2. Navegar a la pantalla de detalle al tocar
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => InterfazDetalleCurso(courseId: curso.id)),
                                );
                              },
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const InterfazCursos())),
                        child: const Text('Ver todos los cursos'),
                      ),
                    ],
                  ),
            const SizedBox(height: 20),
            const Text('Acceso Rápido', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            logic.recentActions.isEmpty
                ? const Center(child: Text('Tus acciones recientes aparecerán aquí.', style: TextStyle(color: Colors.grey)))
                : Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    alignment: WrapAlignment.center,
                    children: logic.recentActions.map((item) {
                      return ElevatedButton.icon(
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => item.screen)),
                        icon: Icon(item.icon),
                        label: Text(item.title),
                      );
                    }).toList(),
                  ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _buildBottomBarButton(context, Icons.calendar_today, 'Calendario', () {
              showDialog(
                context: context,
                builder: (ctx) => Dialog(
                  child: InteractiveViewer(child: Image.asset('assets/images/Calendario.png')),
                ),
              );
            }),
            _buildBottomBarButton(context, Icons.badge, 'Credencial', () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const InterfazCredencial()));
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBarButton(BuildContext context, IconData icon, String label, VoidCallback onPressed) {
    return TextButton(
      onPressed: onPressed,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [Icon(icon), Text(label)],
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
    return SizedBox(
      width: 200,
      child: GestureDetector( // 3. Hacer la tarjeta entera presionable
        onTap: onPressed,
        child: Card(
          margin: const EdgeInsets.only(right: 16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Text(curso.name, style: const TextStyle(fontWeight: FontWeight.bold))],
            ),
          ),
        ),
      ),
    );
  }
}
