
import 'package:fenix/Back_interfazUsuario.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InterfazPerfilDeUsuario extends StatelessWidget {
  const InterfazPerfilDeUsuario({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PerfilUsuarioLogic(),
      child: Consumer<PerfilUsuarioLogic>(
        builder: (context, logic, child) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Perfil de Usuario'),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // 1. Logo de la Escuela
                  Image.asset(
                    'assets/images/UAM.png',
                    height: 150, // Puedes ajustar la altura como necesites
                  ),
                  const SizedBox(height: 32),

                  // 2. Foto de Perfil
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      const CircleAvatar(
                        radius: 80,
                        backgroundColor: Colors.blueGrey,
                        child: Icon(Icons.person, size: 100, color: Colors.white),
                      ),
                      IconButton.filled(
                        icon: const Icon(Icons.camera_alt),
                        onPressed: () => logic.seleccionarNuevaFoto(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // 3. Nombre del Usuario
                  TextFormField(
                    controller: logic.nameController,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    decoration: const InputDecoration(
                      labelText: 'Tu Nombre',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // 4. Botón para Guardar Cambios
                  ElevatedButton.icon(
                    icon: const Icon(Icons.save),
                    label: const Text('Guardar Cambios'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                    onPressed: () => logic.guardarCambios(context),
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
