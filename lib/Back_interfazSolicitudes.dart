import 'package:fenix/Back_cursos.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SolicitudesLogic extends ChangeNotifier {
  final _supabase = Supabase.instance.client;

  String? _userRole;
  List<Curso> _professorCourses = [];
  bool _isLoading = true;
  String? _error;

  String? get userRole => _userRole;
  List<Curso> get professorCourses => _professorCourses;
  bool get isLoading => _isLoading;
  String? get error => _error;

  SolicitudesLogic() {
    initialize();
  }

  Future<void> initialize() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final user = _supabase.auth.currentUser;
      if (user == null) throw 'Usuario no autenticado.';

      // 1. Obtener el rol del usuario
      final profileData = await _supabase.from('Perfiles').select('role').eq('id', user.id).single();
      _userRole = profileData['role'] as String?;

      // 2. Si es profesor, obtener sus cursos
      if (_userRole == 'professor') {
        final coursesData = await _supabase.from('courses').select().eq('professor_id', user.id);
        _professorCourses = (coursesData as List).map((json) => Curso.fromJson(json)).toList();
      }
    } catch (e) {
      debugPrint('Error inicializando solicitudes: $e');
      _error = 'No se pudo cargar la información. Inténtalo de nuevo.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String?> sendGlobalNotification(String title, String body) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return 'Usuario no autenticado.';

      await _supabase.from('notifications').insert({
        'title': title,
        'body': body,
        'author_id': user.id,
        // target_course_id se deja nulo para una notificación global
      });
      return null; // Éxito
    } catch (e) {
      return 'Error al enviar la notificación global: ${e.toString()}';
    }
  }

  Future<String?> sendCourseNotification(int courseId, String title, String body) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return 'Usuario no autenticado.';

      await _supabase.from('notifications').insert({
        'title': title,
        'body': body,
        'author_id': user.id,
        'target_course_id': courseId,
      });
      return null; // Éxito
    } catch (e) {
      return 'Error al enviar la notificación del curso: ${e.toString()}';
    }
  }
}
