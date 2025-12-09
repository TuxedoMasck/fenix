import 'package:fenix/Back_InfPersonal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InterfazInfPersonal extends StatelessWidget {
  const InterfazInfPersonal({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => InfPersonalLogic(),
      child: Consumer<InfPersonalLogic>(
        builder: (context, logic, child) {
          if (logic.isLoading) {
            return Scaffold(
              appBar: AppBar(title: const Text('Información Personal')),
              body: const Center(child: CircularProgressIndicator()),
            );
          }

          return Scaffold(
            appBar: AppBar(
              title: const Text('Información Personal'),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildReadOnlyField('Nombre Completo', logic.fullName),
                  _buildReadOnlyField('Correo Institucional', logic.email),
                  _buildReadOnlyField('División', logic.division),
                  const SizedBox(height: 24),
                  _buildEditableField('Nombre de Usuario', logic.usernameController),
                  _buildEditableField('Departamento', logic.departmentController),
                  _buildEditableField('Licenciatura', logic.licenciaturaController),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    onPressed: logic.isLoading
                        ? null
                        : () async {
                            final error = await logic.saveChanges();
                            if (context.mounted) {
                              if (error == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Información actualizada con éxito.'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                                Navigator.of(context).pop();
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(error),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            }
                          },
                    child: logic.isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Guardar Cambios'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildReadOnlyField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 16)),
          const Divider(),
        ],
      ),
    );
  }

  Widget _buildEditableField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
