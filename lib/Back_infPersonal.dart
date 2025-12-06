import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class InfPersonalLogic extends ChangeNotifier {
  final _supabase = Supabase.instance.client;
  
  bool _isLoading = true;
  bool get isLoading => _isLoading;

  // Controladores para los campos editables
  late TextEditingController usernameController;
  late TextEditingController departmentController;
  late TextEditingController degreeController;

  // Variables para los campos no editables
  String fullName = '';
  String division = '';
  String email = '';

  InfPersonalLogic() {
    usernameController = TextEditingController();
    departmentController = TextEditingController();
    degreeController = TextEditingController();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    _isLoading = true;
    notifyListeners();

    final userId = _supabase.auth.currentUser!.id;
    final userEmail = _supabase.auth.currentUser!.email!;

    try {
      final data = await _supabase.from('Perfiles').select().eq('id', userId).single();

      // Asigna los valores a los controladores y variables
      usernameController.text = data['username'] ?? '';
      departmentController.text = data['department'] ?? '';
      degreeController.text = data['degree'] ?? '';
      fullName = data['full_name'] ?? 'Sin nombre completo';
      division = data['division'] ?? 'Sin división';
      email = userEmail;

    } catch (e) {
      debugPrint("Error cargando el perfil: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String?> saveChanges() async {
    _isLoading = true;
    notifyListeners();

    try {
      final userId = _supabase.auth.currentUser!.id;
      await _supabase.from('Perfiles').update({
        'username': usernameController.text,
        'department': departmentController.text,
        'degree': degreeController.text,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', userId);
      
      return null; // Éxito
    } catch (e) {
      return 'Ocurrió un error al guardar: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    departmentController.dispose();
    degreeController.dispose();
    super.dispose();
  }
}
