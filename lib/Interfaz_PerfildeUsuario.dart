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
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Image.asset('assets/images/UAM.png', height: 40),
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  flex: 2,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (logic.avatarUrl != null) {
                              _showExpandedImage(context, logic.avatarUrl!);
                            }
                          },
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // El Hero widget es la clave de la animación
                              Hero(
                                tag: logic.avatarUrl ?? 'user-avatar',
                                child: CircleAvatar(
                                  radius: 80,
                                  backgroundImage: logic.avatarUrl != null
                                      ? NetworkImage(logic.avatarUrl!)
                                      : null,
                                  child: logic.avatarUrl == null && !logic.isLoading
                                      ? const Icon(Icons.person, size: 100)
                                      : null,
                                ),
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
                        ),
                        const SizedBox(height: 16),
                        Text(
                          logic.username ?? '',
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

  void _showExpandedImage(BuildContext context, String imageUrl) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.black.withOpacity(0.8),
        pageBuilder: (BuildContext context, _, __) {
          return _FullScreenImageViewer(imageUrl: imageUrl);
        },
      ),
    );
  }

  void _showPrivacyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Política de Privacidad y Datos'),
          content: const SingleChildScrollView(
            child: Text(
              'En cumplimiento con la Ley Federal de Protección de Datos Personales en Posesión de los Particulares (LFPDPPP), Fenix App informa que los datos personales que usted proporciona (nombre, correo, identificadores, etc.) son utilizados exclusivamente para el funcionamiento de la aplicación, incluyendo la autenticación, personalización del perfil y comunicación interna. Sus datos no serán transferidos a terceros sin su consentimiento, salvo las excepciones previstas por la ley. Al usar esta aplicación, usted consiente el tratamiento de sus datos personales para los fines descritos. El responsable de los datos es la administración de Fenix App. Para ejercer sus derechos ARCO (Acceso, Rectificación, Cancelación y Oposición), por favor, contáctenos a través de la sección de soporte.'
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Aceptar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Acerca de la App'),
          content: const SingleChildScrollView(
            child: Text(
                'Esta app busca centralizar todo tipo de informacion dispersa de la Universidad Autonoma Metropolitana, con el fin de facilitar las notificaciones a los alumnos, profesores e incluso al personal administrativo, para evitar perdidas de informacion.'),
          ),
          actions: [
            TextButton(
              child: const Text('Aceptar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
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
          onTap: () => logic.navigateToInfPersonal(context),
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
          icon: Icons.privacy_tip_outlined,
          title: 'Privacidad',
          onTap: () => _showPrivacyDialog(context),
        ),
        _buildMenuOption(
          context: context,
          icon: Icons.info_outline,
          title: 'Acerca de la app',
          onTap: () => _showAboutDialog(context),
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

//Widget para la Vista de Imagen a Pantalla Completa
class _FullScreenImageViewer extends StatelessWidget {
  final String imageUrl;

  const _FullScreenImageViewer({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Center(
          child: Hero(
            tag: imageUrl,
            child: InteractiveViewer(
              child: Image.network(imageUrl),
            ),
          ),
        ),
      ),
    );
  }
}
