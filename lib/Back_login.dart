import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class AuthService {
  final _supabase = Supabase.instance.client;

  // Devuelve un mensaje de error si falla, o null si tiene éxito.
  Future<String?> login(String email, String password) async {
    try {
      await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      // Si no hay excepción, el login fue exitoso.
      return null;
    } on AuthException catch (e) {
      // Devuelve el mensaje de error específico de Supabase.
      return e.message;
    } catch (e) {
      // Para cualquier otro tipo de error.
      return 'Ocurrió un error inesperado: $e';
    }
  }


  // Cierra la sesión del usuario actual.
  Future<void> logout() async {
    await _supabase.auth.signOut();
  }
}
