import 'package:flutter/material.dart';

// --- Modelo de Datos ---
class SupportTicket {
  final String email;
  final String description;

  SupportTicket({required this.email, required this.description});

  Map<String, dynamic> toJson() => {
        'email': email,
        'description': description,
      };
}

// --- Servicio de Backend ---
class SupportService {
  Future<bool> sendTicket(SupportTicket ticket) async {
    // Simula el envío a un backend. Retorna éxito después de 1s.
    debugPrint('Enviando ticket: ${ticket.toJson()}');
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }
}
