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

      final enrollmentData = await _supabase
          .from('enrollments')
          .select('course_id')
          .eq('student_id', user.id);

      if (enrollmentData.isEmpty) {
        _notificaciones = [];
        _isLoading = false;
        notifyListeners();
        return;
      }

      final courseIds = (enrollmentData as List)
          .map((row) => row['course_id'] as int)
          .toList();

      final notificationsData = await _supabase
          .from('notifications')
          .select()
          .filter('target_course_id', 'in', courseIds)
          .order('created_at', ascending: false);

      _notificaciones = (notificationsData as List)
          .map((json) => Notificacion.fromJson(json))
          .toList();

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
