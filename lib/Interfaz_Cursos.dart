import 'package:fenix/Back_cursos.dart';
import 'package:fenix/Interfaz_DetalleCurso.dart'; // 1. Importar la nueva pantalla
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InterfazCursos extends StatelessWidget {
  const InterfazCursos({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CursosLogic(),
      child: const _InterfazCursosView(),
    );
  }
}

class _InterfazCursosView extends StatelessWidget {
  const _InterfazCursosView();

  @override
  Widget build(BuildContext context) {
    final logic = context.watch<CursosLogic>();

    return Scaffold(
      appBar: AppBar(title: const Text('Mis Cursos')),
      body: RefreshIndicator(
        onRefresh: logic.fetchUserCourses,
        child: _buildBody(context, logic),
      ),
    );
  }

  Widget _buildBody(BuildContext context, CursosLogic logic) {
    if (logic.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (logic.error != null) {
      return Center(child: Text(logic.error!));
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: _buildActionButtons(context, logic),
        ),
        const Divider(),
        Expanded(
          child: logic.cursos.isEmpty
              ? const Center(child: Text('No estás inscrito en ningún curso.'))
              : _buildCoursesList(context, logic.cursos), // 2. Pasar el contexto
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context, CursosLogic logic) {
    List<Widget> buttons = [];

    if (logic.userRole == 'professor') {
      buttons.add(
        ElevatedButton.icon(
          icon: const Icon(Icons.add_circle_outline),
          label: const Text('Crear Curso'),
          onPressed: () => _showCreateCourseDialog(context, logic),
        ),
      );
    }

    buttons.add(
      ElevatedButton.icon(
        icon: const Icon(Icons.group_add_outlined),
        label: const Text('Unirme a Curso'),
        onPressed: () => _showJoinCourseDialog(context, logic),
      ),
    );

    return Wrap(spacing: 12, runSpacing: 12, children: buttons);
  }

  ListView _buildCoursesList(BuildContext context, List<Curso> cursos) {
    return ListView.builder(
      itemCount: cursos.length,
      itemBuilder: (context, index) {
        final curso = cursos[index];
        return ListTile(
          leading: const CircleAvatar(child: Icon(Icons.school_outlined)),
          title: Text(curso.name),
          // 3. Navegar a la pantalla de detalle al tocar
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => InterfazDetalleCurso(courseId: curso.id)),
            );
          },
        );
      },
    );
  }

  void _showCreateCourseDialog(BuildContext context, CursosLogic logic) {
    final nameController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Crear Nuevo Curso'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(labelText: 'Nombre del curso'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () async {
              final error = await logic.createCourse(nameController.text);
              if (ctx.mounted) {
                if (error == null) {
                  Navigator.of(ctx).pop();
                } else {
                  ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text(error), backgroundColor: Colors.red));
                }
              }
            },
            child: const Text('Crear'),
          ),
        ],
      ),
    );
  }

  void _showJoinCourseDialog(BuildContext context, CursosLogic logic) {
    final codeController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Unirme a un Curso'),
        content: TextField(
          controller: codeController,
          decoration: const InputDecoration(labelText: 'Código del curso'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () async {
              final error = await logic.joinCourse(codeController.text);
              if (ctx.mounted) {
                if (error == null) {
                  Navigator.of(ctx).pop();
                } else {
                  ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text(error), backgroundColor: Colors.red));
                }
              }
            },
            child: const Text('Unirme'),
          ),
        ],
      ),
    );
  }
}
