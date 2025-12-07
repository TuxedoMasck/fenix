import 'package:flutter/material.dart';

// datos
class SupportTicket {
  final String email;
  final String description;

  SupportTicket({required this.email, required this.description});
}

//backend
class AyudaLogic extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<bool> sendSupportTicket(SupportTicket ticket) async {
    _isLoading = true;
    notifyListeners();

    debugPrint('Enviando ticket para: ${ticket.email}');
    // Simula el envío a un backend real
    await Future.delayed(const Duration(seconds: 2));

    _isLoading = false;
    notifyListeners();

    // Simula una respuesta exitosa
    return true;
  }
}
