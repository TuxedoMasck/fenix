import 'package:fenix/Back_cursos.dart';
import 'package:fenix/Interfaz_Ayuda.dart';
import 'package:fenix/Interfaz_PerfildeUsuario.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Usuario {
  final String nombre; // Esta propiedad ahora contendrá el username
  final String email;
  final String? avatarUrl;

  Usuario({required this.nombre, required this.email, this.avatarUrl});

  String get inicialAvatar {
    if (nombre.isEmpty) return '?';
    return nombre[0].toUpperCase();
  }
}

// Modelo para los items de Acceso Rápido
class QuickAccessItem {
  final IconData icon;
  final String title;
  final Widget screen;

  QuickAccessItem({required this.icon, required this.title, required this.screen});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuickAccessItem && runtimeType == other.runtimeType && title == other.title;

  @override
  int get hashCode => title.hashCode;
}

//Lógica de la Interfaz Principal

class InterfazPrincipalLogic extends ChangeNotifier {
  final _supabase = Supabase.instance.client;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  Usuario? _usuario;
  Usuario? get usuario => _usuario;

  List<Curso> _cursos = [];
  List<Curso> get cursos => _cursos;

  List<QuickAccessItem> _recentActions = [];
  List<QuickAccessItem> get recentActions => _recentActions;

  Future<void> initialize() async {
    await _cargarDatosUsuario();
    await _fetchUserCourses();
    _isLoading = false;
    notifyListeners();
  }

  void registerRecentAction(QuickAccessItem item) {
    _recentActions.removeWhere((action) => action.title == item.title);
    _recentActions.insert(0, item);
    if (_recentActions.length > 3) {
      _recentActions = _recentActions.sublist(0, 3);
    }
    notifyListeners();
  }

  // SOLUCIÓN: El método ahora carga el 'username' desde la tabla 'Perfiles'
  Future<void> _cargarDatosUsuario() async {
    final user = _supabase.auth.currentUser;
    if (user != null) {
      try {
        final profileData = await _supabase.from('Perfiles').select('username').eq('id', user.id).single();
        final nombre = profileData['username'] ?? 'Sin nombre de usuario';
        final email = user.email ?? 'sin.email@example.com';
        final avatarUrl = user.userMetadata?['avatar_url'];
        _usuario = Usuario(nombre: nombre, email: email, avatarUrl: avatarUrl);
      } catch (e) {
        debugPrint("Error cargando nombre de usuario para el drawer: $e");
        final email = user.email ?? 'sin.email@example.com';
        final avatarUrl = user.userMetadata?['avatar_url'];
        _usuario = Usuario(nombre: 'Error al cargar', email: email, avatarUrl: avatarUrl);
      }
    } else {
      _usuario = Usuario(nombre: 'Invitado', email: '');
    }
  }


  Future<void> _fetchUserCourses() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    try {
      final profileData = await _supabase.from('Perfiles').select('role').eq('id', user.id).single();
      final userRole = profileData['role'] as String?;

      if (userRole == 'professor') {
        final data = await _supabase.from('courses').select().eq('professor_id', user.id);
        _cursos = (data as List).map((json) => Curso.fromJson(json)).toList();
      } else {
        final enrollmentData = await _supabase.from('enrollments').select('course_id').eq('student_id', user.id);
        if (enrollmentData.isNotEmpty) {
          final courseIds = (enrollmentData as List).map((row) => row['course_id'] as int).toList();
          final data = await _supabase.from('courses').select().filter('id', 'in', courseIds);
          _cursos = (data as List).map((json) => Curso.fromJson(json)).toList();
        } else {
          _cursos = [];
        }
      }
    } catch (e) {
      debugPrint("Error al cargar cursos en la pantalla principal: $e");
    }
  }

  Future<void> navegarAPerfil(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const InterfazPerfilDeUsuario()),
    );
    await initialize();
  }

  void mostrarAyuda(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const InterfazAyuda()),
    );
  }
}
