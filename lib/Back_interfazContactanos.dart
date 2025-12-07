import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ContactanosLogic extends ChangeNotifier {
  final _supabase = Supabase.instance.client;
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<String?> sendMessage({
    required String contactEmail,
    required String description,
  }) async {
    if (contactEmail.isEmpty || description.isEmpty) {
      return 'Todos los campos son requeridos.';
    }

    _isLoading = true;
    notifyListeners();

    try {
      final response = await _supabase.functions.invoke('send-contact-form', 
        body: {
          'contactEmail': contactEmail,
          'description': description,
        },
      );

      if (response.status != 200) {
        throw 'Error al contactar al servidor. Código: ${response.status}';
      }

      return null; // Éxito

    } catch (e) {
      return 'Ocurrió un error inesperado: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
