import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: 'https://blwwpzayvgflkqxemxrc.supabase.co',
      anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJsd3dwemF5dmdmbGtxeGVteHJjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjMzMzY4NzgsImV4cCI6MjA3ODkxMjg3OH0.5XryvpRpIQyx6AACae6eWnzg5v-vjjY-IanfbXjd59I',
    );
  }
}
