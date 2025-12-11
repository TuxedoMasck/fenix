import 'package:fenix/Back_cursos.dart';
import 'package:fenix/Back_interfazSolicitudes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InterfazSolicitudes extends StatelessWidget {
  const InterfazSolicitudes({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SolicitudesLogic(),
      child: const _InterfazSolicitudesView(),
    );
  }
}

class _InterfazSolicitudesView extends StatelessWidget {
  const _InterfazSolicitudesView();

  @override
  Widget build(BuildContext context) {
    final logic = context.watch<SolicitudesLogic>();

    return Scaffold(
      appBar: AppBar(title: const Text('Crear Solicitud/Notificación')),
      body: _buildBody(context, logic),
    );
  }

  Widget _buildBody(BuildContext context, SolicitudesLogic logic) {
    if (logic.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (logic.error != null) {
      return Center(child: Text(logic.error!));
    }

    if (logic.userRole == 'professor') {
      return _buildProfessorView(context, logic);
    } else {
      return _buildStudentView(context, logic);
    }
  }

  // Vista para Profesores
  Widget _buildProfessorView(BuildContext context, SolicitudesLogic logic) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _buildProfessorButton(
          context,
          icon: Icons.public,
          title: 'Enviar Notificación Global',
          subtitle: 'Enviar un aviso a todos los usuarios de la app.',
          onTap: () => _showNotificationDialog(context, logic),
        ),
        const SizedBox(height: 24),
        const Text('Enviar Notificación por Curso', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const Divider(),
        ...logic.professorCourses.map((curso) {
          return _buildProfessorButton(
            context,
            icon: Icons.school_outlined,
            title: curso.name,
            subtitle: 'Enviar un aviso solo a los alumnos de este curso.',
            onTap: () => _showNotificationDialog(context, logic, course: curso),
          );
        }).toList(),
      ],
    );
  }

  // Vista para Estudiantes
  Widget _buildStudentView(BuildContext context, SolicitudesLogic logic) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24.0),
        child: Text(
          'Esta sección es para la creación de solicitudes. Próximamente podrás solicitar becas, constancias y más.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildProfessorButton(BuildContext context, {required IconData icon, required String title, required String subtitle, required VoidCallback onTap}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      child: ListTile(
        leading: Icon(icon, size: 40),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        onTap: onTap,
      ),
    );
  }

  // Ventana emergente para enviar notificaciones
  void _showNotificationDialog(BuildContext context, SolicitudesLogic logic, {Curso? course}) {
    final titleController = TextEditingController();
    final bodyController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    bool isSending = false;

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (dialogContext, setState) {
            return AlertDialog(
              title: Text(course == null ? 'Notificación Global' : 'Notificación para ${course.name}'),
              content: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: titleController,
                        decoration: const InputDecoration(labelText: 'Título'),
                        validator: (v) => (v == null || v.isEmpty) ? 'El título es requerido' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: bodyController,
                        decoration: const InputDecoration(labelText: 'Mensaje'),
                        maxLines: 4,
                         validator: (v) => (v == null || v.isEmpty) ? 'El mensaje es requerido' : null,
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(onPressed: () => Navigator.of(dialogContext).pop(), child: const Text('Cancelar')),
                isSending
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: () async {
                          if (!formKey.currentState!.validate()) return;

                          setState(() => isSending = true);
                          
                          final title = titleController.text;
                          final body = bodyController.text;
                          String? error;

                          if (course == null) {
                            error = await logic.sendGlobalNotification(title, body);
                          } else {
                            error = await logic.sendCourseNotification(course.id, title, body);
                          }
                          
                          if (dialogContext.mounted) {
                             if (error == null) {
                                Navigator.of(dialogContext).pop();
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Notificación enviada con éxito.'), backgroundColor: Colors.green));
                             } else {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error), backgroundColor: Colors.red));
                                setState(() => isSending = false);
                             }
                          }
                        },
                        child: const Text('Enviar'),
                      ),
              ],
            );
          },
        );
      },
    );
  }
}
