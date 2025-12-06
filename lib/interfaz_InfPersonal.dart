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
          return Scaffold(
            appBar: AppBar(
              title: const Text('Información Personal'),
            ),
            body: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  TextFormField(
                    controller: logic.nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nombre Completo',
                      border: OutlineInputBorder(),
                    ),
                  ),
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
                                    content: Text('Nombre actualizado con éxito.'),
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
}
