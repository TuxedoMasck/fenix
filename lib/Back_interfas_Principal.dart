import 'package:fenix/Interfaz_Ayuda.dart';
import 'package:fenix/Interfaz_PerfildeUsuario.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// --- Modelos de Datos ---

class Usuario {
  final String nombre;
  final String email;
  final String? avatarUrl; // La URL de la foto puede ser nula

  Usuario({required this.nombre, required this.email, this.avatarUrl});

  // Obtiene la inicial del nombre para mostrarla si no hay foto.
  String get inicialAvatar {
    if (nombre.isEmpty) return '?';
    return nombre[0].toUpperCase();
  }
}

class Notificacion {
  final String titulo;
  final String subtitulo;
  final IconData icono;

  Notificacion({required this.titulo, required this.subtitulo, required this.icono});
}

class Curso {
  final String nombre;
  final String descripcion;

  Curso({required this.nombre, required this.descripcion});
}

// --- Lógica de la Interfaz Principal ---

class InterfazPrincipalLogic extends ChangeNotifier {
  final _supabase = Supabase.instance.client;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  Usuario? _usuario;
  Usuario? get usuario => _usuario;

  // La data de notificaciones y cursos sigue siendo de ejemplo por ahora.
  final List<Notificacion> _notificaciones = [
    Notificacion(titulo: 'Notificación 1', subtitulo: 'Descripción de la notificación...', icono: Icons.warning),
    Notificacion(titulo: 'Notificación 2', subtitulo: 'Otra descripción...', icono: Icons.info),
  ];
  List<Notificacion> get notificaciones => _notificaciones;

  final List<Curso> _cursos = [
    Curso(nombre: 'Curso 1', descripcion: 'Descripción breve del curso...'),
    Curso(nombre: 'Curso 2', descripcion: 'Descripción breve del curso...'),
  ];
  List<Curso> get cursos => _cursos;

  // Carga los datos del usuario actual desde Supabase.
  Future<void> cargarDatosUsuario() async {
    _isLoading = true;
    notifyListeners();

    final user = _supabase.auth.currentUser;
    if (user != null) {
      final nombre = user.userMetadata?['full_name'] ?? 'Sin Nombre';
      final email = user.email ?? 'sin.email@example.com';
      final avatarUrl = user.userMetadata?['avatar_url'];

      _usuario = Usuario(nombre: nombre, email: email, avatarUrl: avatarUrl);
    } else {
      // Fallback por si no hay usuario (aunque no debería pasar en esta pantalla).
      _usuario = Usuario(nombre: 'Invitado', email: '');
    }

    _isLoading = false;
    notifyListeners();
  }

  // Navega al perfil y, al regresar, recarga los datos para reflejar cambios.
  Future<void> navegarAPerfil(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const InterfazPerfilDeUsuario()),
    );
    // ¡Importante! Recarga los datos al volver.
    await cargarDatosUsuario();
  }

  // --- Otros métodos de la UI (sin cambios) ---

  void mostrarAyuda(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const InterfazAyuda()),
    );
  }

  void abrirOpciones(BuildContext context) {
    // Aquí podrías navegar a una pantalla de opciones completa
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Abriendo menú de opciones')));
  }
}
