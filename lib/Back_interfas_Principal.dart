import 'package:flutter/material.dart';

// Modelos de datos de ejemplo
class Usuario {
  final String nombre;
  final String email;
  final String inicialAvatar;

  Usuario({required this.nombre, required this.email, required this.inicialAvatar});
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

class InterfazPrincipalLogic extends ChangeNotifier {
  // Estado de carga
  bool _isLoading = true;
  bool get isLoading => _isLoading;

  // Datos del perfil de usuario (ahora nullable)
  Usuario? _usuario;
  Usuario? get usuario => _usuario;

  // Lista de notificaciones
  final List<Notificacion> _notificaciones = [
    Notificacion(titulo: 'Notificación 1', subtitulo: 'Descripción de la notificación...', icono: Icons.warning),
    Notificacion(titulo: 'Notificación 2', subtitulo: 'Otra descripción...', icono: Icons.info),
  ];
  List<Notificacion> get notificaciones => _notificaciones;

  // Lista de cursos
  final List<Curso> _cursos = [
    Curso(nombre: 'Curso 1', descripcion: 'Descripción breve del curso...'),
    Curso(nombre: 'Curso 2', descripcion: 'Descripción breve del curso...'),
    Curso(nombre: 'Curso 3', descripcion: 'Descripción breve del curso...'),
  ];
  List<Curso> get cursos => _cursos;

  // Lógica del Calendario
  DateTime _fechaSeleccionada = DateTime.now();
  DateTime get fechaSeleccionada => _fechaSeleccionada;

  // --- Métodos de Lógica ---

  // Simula la carga de datos del usuario desde un servidor
  Future<void> cargarDatosUsuario() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2)); // Simular espera de red
    _usuario = Usuario(nombre: 'Ricardo', email: 'ricardo@fenix.com', inicialAvatar: 'R');
    _isLoading = false;
    notifyListeners(); // Notifica a la UI que los datos han cambiado
  }

  void onDateChanged(DateTime nuevaFecha) {
    _fechaSeleccionada = nuevaFecha;
    notifyListeners();
  }

  void navegarAPerfil(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Navegando al perfil')));
  }

  void mostrarAyuda(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Mostrando ayuda')));
  }

  void abrirOpciones(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Abriendo menú de opciones')));
  }

  void mostrarNotificaciones(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Mostrando notificaciones')));
  }

  void mostrarCredencial(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Mostrando credencial')));
  }

  void abrirCurso(BuildContext context, Curso curso) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Abriendo curso: ${curso.nombre}')));
  }
}
