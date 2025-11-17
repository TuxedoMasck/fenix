import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final _supabase = Supabase.instance.client;

  // Inicia sesión con Supabase usando email y contraseña.
  Future<bool> login(String email, String password) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      // Si el usuario existe y la sesión se ha creado, el login fue exitoso.
      return response.user != null;
    } on AuthException catch (e) {
      // Si hay un error de autenticación (ej: credenciales inválidas), lo mostramos.
      print('Error de autenticación: ${e.message}');
      return false;
    } catch (e) {
      // Para cualquier otro tipo de error.
      print('Ocurrió un error inesperado: $e');
      return false;
    }
  }

  // Cierra la sesión del usuario actual.
  Future<void> logout() async {
    await _supabase.auth.signOut();
  }
}
