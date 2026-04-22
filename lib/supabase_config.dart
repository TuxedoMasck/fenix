import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static Future<void> initialize() async {
    // Las credenciales se inyectan mediante variables de entorno para proteger la base de datos
    await Supabase.initialize(
      url: const String.fromEnvironment('SUPABASE_URL', defaultValue: 'URL_NO_PROPORCIONADA'),
      anonKey: const String.fromEnvironment('SUPABASE_ANON_KEY', defaultValue: 'LLAVE_NO_PROPORCIONADA'),
    );
  }
}
