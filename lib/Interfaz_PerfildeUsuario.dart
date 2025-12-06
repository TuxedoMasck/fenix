import 'package:fenix/Back_interfazUsuario.dart';
import 'package:fenix/Interfaz_InfPersonal.dart';
import 'package:fenix/Interfaz_Olvidecontrase%C3%B1a.dart';
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
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_outlined, color: Colors.black),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Image.asset('assets/images/UAM.png', height: 45),
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  flex: 2,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            CircleAvatar(
                              radius: 80,
                              backgroundImage: logic.avatarUrl != null
                                  ? NetworkImage(logic.avatarUrl!)
                                  : null,
                              child: logic.avatarUrl == null && !logic.isLoading
                                  ? const Icon(Icons.person, size: 100)
                                  : null,
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: IconButton.filled(
                                icon: const Icon(Icons.camera_alt),
                                onPressed: () => logic.seleccionarYSubirFoto(context),
                              ),
                            ),
                            if (logic.isLoading)
                              const CircleAvatar(
                                radius: 80,
                                backgroundColor: Colors.black54,
                                child: CircularProgressIndicator(color: Colors.white),
                              ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          logic.userName ?? '',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: _buildSettingsMenu(context, logic),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSettingsMenu(BuildContext context, PerfilUsuarioLogic logic) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        const Text(
          'Configuración de cuenta',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        _buildMenuOption(
          context: context,
          icon: Icons.person_outline,
          title: 'Información personal',
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const InterfazInfPersonal()));
          },
        ),
        _buildMenuOption(
          context: context,
          icon: Icons.lock_outline,
          title: 'Cambiar contraseña',
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const InterfazOlvideContrasena()));
          },
        ),
        _buildMenuOption(
          context: context,
          icon: Icons.security_outlined,
          title: 'Privacidad y seguridad',
          onTap: () {},
        ),
        _buildMenuOption(
          context: context,
          icon: Icons.info_outline,
          title: 'Acerca de la app',
          onTap: () {},
        ),
        const Divider(),
        _buildMenuOption(
          context: context,
          icon: Icons.logout,
          title: 'Cerrar sesión',
          isDestructive: true,
          onTap: () => logic.logout(context),
        ),
      ],
    );
  }

  Widget _buildMenuOption({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    final color = isDestructive ? Colors.red : Colors.black;
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title, style: TextStyle(color: color)),
      onTap: onTap,
      trailing: isDestructive ? null : const Icon(Icons.arrow_forward_ios, size: 16),
    );
  }
}
