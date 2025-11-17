import 'package:fenix/Back_interfazUsuario.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InterfazPerfilDeUsuario extends StatelessWidget {
  const InterfazPerfilDeUsuario({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PerfilUsuarioLogic(),
      child: Consumer<PerfilUsuarioLogic>( // Consumer para reconstruir la UI con los cambios
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
                    height: 150, 
                  ),
                  const SizedBox(height: 32),

                  // 2. Foto de Perfil (Ahora conectada a Supabase)
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      CircleAvatar(
                        radius: 80,
                        backgroundColor: Colors.blueGrey,
                        // Muestra la imagen de la red si existe, si no, es null
                        backgroundImage: logic.avatarUrl != null
                            ? NetworkImage(logic.avatarUrl!)
                            : null,
                        // Muestra el icono solo si no hay imagen
                        child: logic.avatarUrl == null && !logic.isLoading
                            ? const Icon(Icons.person, size: 100, color: Colors.white)
                            : null,
                      ),
                      // Botón para cambiar la foto
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: IconButton.filled(
                          icon: const Icon(Icons.camera_alt),
                          // Llama a la nueva función del backend
                          onPressed: () => logic.seleccionarYSubirFoto(context),
                        ),
                      ),
                      // Muestra un overlay de carga mientras se sube la imagen
                      if (logic.isLoading)
                        const CircleAvatar(
                          radius: 80,
                          backgroundColor: Colors.black54,
                          child: CircularProgressIndicator(color: Colors.white),
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
