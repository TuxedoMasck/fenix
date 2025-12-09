import 'package:fenix/Back_detalleCurso.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class InterfazDetalleCurso extends StatelessWidget {
  final int courseId;

  const InterfazDetalleCurso({super.key, required this.courseId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DetalleCursoLogic(courseId: courseId),
      child: Consumer<DetalleCursoLogic>(
        builder: (context, logic, child) {
          final curso = logic.curso;

          return Scaffold(
            appBar: AppBar(
              title: Text(logic.isLoading ? 'Cargando...' : curso?.name ?? 'Detalle del Curso'),
            ),
            body: _buildBody(context, logic),
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, DetalleCursoLogic logic) {
    if (logic.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (logic.error != null || logic.curso == null) {
      return Center(child: Text(logic.error ?? 'No se pudo cargar el curso.'));
    }

    final curso = logic.curso!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Sección para el código del curso
        _buildCourseCodeSection(context, curso.code),
        const Divider(),
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('Notificaciones del Curso', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        // Lista de notificaciones
        Expanded(
          child: curso.notifications.isEmpty
              ? const Center(child: Text('No hay notificaciones en este curso.'))
              : ListView.builder(
                  itemCount: curso.notifications.length,
                  itemBuilder: (context, index) {
                    final notificacion = curso.notifications[index];
                    return ListTile(
                      leading: const CircleAvatar(child: Icon(Icons.notifications)),
                      title: Text(notificacion.titulo, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(notificacion.cuerpo),
                      trailing: Text(
                        timeago.format(notificacion.fecha, locale: 'es'),
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildCourseCodeSection(BuildContext context, String code) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Código para unirse al curso:', style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text(
                  code,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 2),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.copy_outlined),
                tooltip: 'Copiar código',
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: code));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('¡Código copiado al portapapeles!')),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
