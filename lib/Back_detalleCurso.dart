import 'package:fenix/Back_interfazNotificaciones.dart'; // Reutilizamos el modelo de Notificacion
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DetalleCurso {
  final int id;
  final String name;
  final String code;
  final List<Notificacion> notifications;

  DetalleCurso({
    required this.id,
    required this.name,
    required this.code,
    required this.notifications,
  });
}

class DetalleCursoLogic extends ChangeNotifier {
  final _supabase = Supabase.instance.client;
  final int courseId;

  DetalleCurso? _curso;
  bool _isLoading = true;
  String? _error;

  DetalleCurso? get curso => _curso;
  bool get isLoading => _isLoading;
  String? get error => _error;

  DetalleCursoLogic({required this.courseId}) {
    _fetchCourseDetails();
  }

  Future<void> _fetchCourseDetails() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // 1. Obtener los detalles del curso (nombre y código)
      final courseData = await _supabase
          .from('courses')
          .select('name, code')
          .eq('id', courseId)
          .single();

      // 2. Obtener las notificaciones para este curso específico
      final notificationsData = await _supabase
          .from('notifications')
          .select()
          .eq('target_course_id', courseId)
          .order('created_at', ascending: false);

      final notifications = (notificationsData as List)
          .map((json) => Notificacion.fromJson(json))
          .toList();

      _curso = DetalleCurso(
        id: courseId,
        name: courseData['name'] as String,
        code: courseData['code'] as String,
        notifications: notifications,
      );

    } catch (e) {
      debugPrint("Error cargando los detalles del curso: $e");
      _error = "No se pudieron cargar los detalles del curso.";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
