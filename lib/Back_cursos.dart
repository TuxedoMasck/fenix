import 'dart:math';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Curso {
  final int id;
  final String name;

  Curso({required this.id, required this.name});

  factory Curso.fromJson(Map<String, dynamic> json) {
    return Curso(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }
}

class CursosLogic extends ChangeNotifier {
  final _supabase = Supabase.instance.client;
  
  List<Curso> _cursos = [];
  String? _userRole;
  bool _isLoading = true;
  String? _error;

  List<Curso> get cursos => _cursos;
  String? get userRole => _userRole;
  bool get isLoading => _isLoading;
  String? get error => _error;

  CursosLogic() {
    _initialize();
  }

  Future<void> _initialize() async {
    await _fetchUserRole();
    await fetchUserCourses();
  }

  Future<void> _fetchUserRole() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    try {
      final data = await _supabase.from('Perfiles').select('role').eq('id', user.id).single();
      _userRole = data['role'] as String?;
    } catch (e) {
      debugPrint('Error fetching user role: $e');
      _userRole = 'student';
    }
  }

  Future<void> fetchUserCourses() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final user = _supabase.auth.currentUser;
      if (user == null) throw 'Usuario no autenticado.';

      if (_userRole == 'professor') {
        final data = await _supabase.from('courses').select().eq('professor_id', user.id);
        _cursos = (data as List).map((json) => Curso.fromJson(json)).toList();
      } else {
        final enrollmentData = await _supabase.from('enrollments').select('course_id').eq('student_id', user.id);
        if (enrollmentData.isNotEmpty) {
          final courseIds = (enrollmentData as List).map((row) => row['course_id'] as int).toList();
          // SOLUCIÓN DEFINITIVA: Usar el método .filter()
          final data = await _supabase.from('courses').select().filter('id', 'in', courseIds);
          _cursos = (data as List).map((json) => Curso.fromJson(json)).toList();
        } else {
          _cursos = [];
        }
      }
    } catch (e) {
      debugPrint("Error al cargar cursos: $e");
      _error = "No se pudieron cargar los cursos.";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  String _generateRandomCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    return String.fromCharCodes(Iterable.generate(6, (_) => chars.codeUnitAt(random.nextInt(chars.length))));
  }

  Future<String?> createCourse(String name) async {
    if (name.isEmpty) return 'El nombre del curso no puede estar vacío.';
    if (_userRole != 'professor') return 'Acción no permitida. Solo los profesores pueden crear cursos.';

    try {
      final user = _supabase.auth.currentUser!;
      final code = _generateRandomCode();
      
      await _supabase.from('courses').insert({
        'name': name,
        'professor_id': user.id,
        'code': code,
      });
      await fetchUserCourses();
      return null;
    } catch (e) {
      return 'Error al crear el curso: ${e.toString()}';
    }
  }

  Future<String?> joinCourse(String code) async {
    if (code.isEmpty) return 'El código no puede estar vacío.';

    try {
      final user = _supabase.auth.currentUser!;
      
      final courseData = await _supabase.from('courses').select('id').eq('code', code).single();
      final courseId = courseData['id'] as int;

      await _supabase.from('enrollments').insert({
        'student_id': user.id,
        'course_id': courseId,
      });
      await fetchUserCourses();
      return null;
    } catch (e) {
      return 'Error al unirse al curso. Verifica el código e inténtalo de nuevo.';
    }
  }
}
