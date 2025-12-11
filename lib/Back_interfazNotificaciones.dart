import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Notificacion {
  final String id;
  final String titulo;
  final String cuerpo;
  final DateTime fecha;
  bool leida;

  Notificacion({
    required this.id,
    required this.titulo,
    required this.cuerpo,
    required this.fecha,
    this.leida = false,
  });

  factory Notificacion.fromJson(Map<String, dynamic> json) {
    return Notificacion(
      id: json['id'] as String,
      titulo: json['title'] as String,
      cuerpo: json['body'] as String,
      fecha: DateTime.parse(json['created_at'] as String),
    );
  }
}

class NotificacionesLogic extends ChangeNotifier {
  final _supabase = Supabase.instance.client;

  List<Notificacion> _notificaciones = [];
  bool _isLoading = true;
  String? _error;

  List<Notificacion> get notificaciones => _notificaciones;
  bool get isLoading => _isLoading;
  String? get error => _error;

  NotificacionesLogic() {
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final user = _supabase.auth.currentUser;
      if (user == null) throw 'Usuario no autenticado.';

      final profileData = await _supabase.from('Perfiles').select('role').eq('id', user.id).single();
      final userRole = profileData['role'] as String?;

      List<int> userCourseIds = [];
      if (userRole == 'professor') {
        final coursesData = await _supabase.from('courses').select('id').eq('professor_id', user.id);
        userCourseIds = (coursesData as List).map((row) => row['id'] as int).toList();
      } else {
        final enrollmentData = await _supabase.from('enrollments').select('course_id').eq('student_id', user.id);
        userCourseIds = (enrollmentData as List).map((row) => row['course_id'] as int).toList();
      }

      final query = _supabase.from('notifications').select();
      
      if (userCourseIds.isNotEmpty) {
        query.or('target_course_id.in.(${userCourseIds.join(',')}),target_course_id.is.null');
      } else {
        query.filter('target_course_id', 'is', null);
      }

      final notificationsData = await query.order('created_at', ascending: false);

      _notificaciones = (notificationsData as List).map((json) => Notificacion.fromJson(json)).toList();

    } catch (e) {
      debugPrint("Error al cargar notificaciones: $e");
      _error = "No se pudieron cargar las notificaciones. Inténtalo de nuevo.";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void marcarComoLeida(String id) {
    final index = _notificaciones.indexWhere((n) => n.id == id);
    if (index != -1 && !_notificaciones[index].leida) {
      _notificaciones[index].leida = true;
      notifyListeners();
    }
  }

  void eliminarNotificacion(String id) {
    _notificaciones.removeWhere((n) => n.id == id);
    notifyListeners();
  }
}
