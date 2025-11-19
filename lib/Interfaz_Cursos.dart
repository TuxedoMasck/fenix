import 'package:fenix/Back_cursos.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InterfazCursos extends StatelessWidget {
  const InterfazCursos({super.key});

  @override
  Widget build(BuildContext context) {
    // Conecta la UI a la lógica del backend.
    final logic = Provider.of<CursosLogic>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Cursos'),
        actions: [
          // Botón para unirse a un curso.
          IconButton(
            icon: const Icon(Icons.group_add),
            tooltip: 'Unirse a un curso',
            onPressed: () => _mostrarDialogoUnirse(context, logic),
          ),
          // Botón para crear un curso.
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            tooltip: 'Crear un curso nuevo',
            onPressed: () => _mostrarDialogoCrear(context, logic),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: logic.cursos.length,
        itemBuilder: (context, index) {
          final curso = logic.cursos[index];
          return Card(
            elevation: 2.0,
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: ListTile(
              leading: CircleAvatar(
                // Muestra un ícono diferente según el rol.
                child: Icon(
                  curso.rol == UserRole.administrador
                      ? Icons.person
                      : Icons.group,
                ),
              ),
              title: Text(curso.nombre),
              subtitle: Text(curso.rol == UserRole.administrador
                  ? 'Administrador'
                  : 'Miembro'),
              trailing: curso.rol == UserRole.administrador
              // Si es admin, muestra el código para compartir.
                  ? TextButton.icon(
                icon: const Icon(Icons.share, size: 16),
                label: Text(curso.codigo),
                onPressed: () => logic.compartirCodigo(context, curso.codigo),
              )
                  : null,
              onTap: () {
                // Navegar a la pantalla de detalles del curso.
              },
            ),
          );
        },
      ),
    );
  }

  void _mostrarDialogoUnirse(BuildContext context, CursosLogic logic) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Unirse a un curso'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Ingresa el código del curso',
            hintText: 'Ej: ABC-123',
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                logic.unirseACurso(controller.text);
                Navigator.pop(context);
              }
            },
            child: const Text('Unirse'),
          ),
        ],
      ),
    );
  }

  void _mostrarDialogoCrear(BuildContext context, CursosLogic logic) {
    final nombreController = TextEditingController();
    final descController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Crear un curso nuevo'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nombreController,
              decoration: const InputDecoration(labelText: 'Nombre del curso'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: descController,
              decoration: const InputDecoration(labelText: 'Descripción'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () {
              if (nombreController.text.isNotEmpty && descController.text.isNotEmpty) {
                logic.crearCurso(nombreController.text, descController.text);
                Navigator.pop(context);
              }
            },
            child: const Text('Crear'),
          ),
        ],
      ),
    );
  }
}