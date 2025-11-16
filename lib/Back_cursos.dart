import 'dart:math';
import 'package:flutter/material.dart';

// --- Modelos de Datos ---

// Define si el usuario es administrador o miembro del curso.
enum UserRole { administrador, miembro }

// Representa un curso con su nombre, descripción y el rol del usuario.
class Curso {
  final String id;
  final String nombre;
  final String descripcion;
  final String codigo;
  final UserRole rol;

  Curso({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.codigo,
    required this.rol,
  });
}

// --- Lógica del Backend ---

class CursosLogic extends ChangeNotifier {
  // Lista de cursos (simula una base de datos).
  final List<Curso> _cursos = [
    Curso(
      id: '1',
      nombre: 'Cálculo Avanzado',
      descripcion: 'Curso de matemáticas para ingeniería.',
      codigo: 'A4X-12B',
      rol: UserRole.administrador,
    ),
    Curso(
      id: '2',
      nombre: 'Historia del Arte Moderno',
      descripcion: 'Un recorrido por las vanguardias del siglo XX.',
      codigo: 'C9Z-88V',
      rol: UserRole.miembro,
    ),
  ];

  // Getter para que la UI acceda a los cursos.
  List<Curso> get cursos => _cursos;

  // Genera un código aleatorio para un nuevo curso.
  String _generarCodigo() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    final code = String.fromCharCodes(Iterable.generate(
      6, (_) => chars.codeUnitAt(random.nextInt(chars.length)),
    ));
    return '${code.substring(0, 3)}-${code.substring(3, 6)}';
  }

  // Lógica para crear un nuevo curso.
  void crearCurso(String nombre, String descripcion) {
    final nuevoCurso = Curso(
      id: DateTime.now().toString(), // ID único simple.
      nombre: nombre,
      descripcion: descripcion,
      codigo: _generarCodigo(),
      rol: UserRole.administrador, // Quien crea el curso es admin.
    );
    _cursos.add(nuevoCurso);
    notifyListeners(); // Notifica a la UI para que se actualice.
  }

  // Lógica para unirse a un curso.
  void unirseACurso(String codigo) {
    // Aquí iría la lógica para validar el código con un backend real.
    // Por ahora, es solo una simulación.
    print('Intentando unirse al curso con el código: $codigo');
    // Si el código es válido, se añadiría el curso a la lista del usuario.
    notifyListeners();
  }

  // Lógica para compartir el código.
  void compartirCodigo(BuildContext context, String codigo) {
    // En una app real, podrías usar el paquete `share_plus`.
    // Por ahora, solo lo mostramos en un SnackBar.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Código del curso copiado: $codigo')),
    );
  }
}
