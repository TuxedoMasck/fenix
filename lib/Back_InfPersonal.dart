import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class InfPersonalLogic extends ChangeNotifier {
  final _supabase = Supabase.instance.client;
  late TextEditingController nameController;
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  InfPersonalLogic() {
    nameController = TextEditingController();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final user = _supabase.auth.currentUser;
    if (user != null) {
      nameController.text = user.userMetadata?['full_name'] ?? '';
    }
  }

  Future<String?> saveChanges() async {
    _isLoading = true;
    notifyListeners();
    try {
      await _supabase.auth.updateUser(
        UserAttributes(data: {'full_name': nameController.text}),
      );
      return null; // Success
    } on AuthException catch (e) {
      return e.message;
    } catch (e) {
      return 'Ocurrió un error inesperado: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }
}
