import 'package:flutter/material.dart';

class InterfazCredencial extends StatelessWidget {
  const InterfazCredencial({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Credencial Digital'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 1. Placeholder para el Visor de PDF
            Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.picture_as_pdf, size: 50, color: Colors.grey),
                      SizedBox(height: 8),
                      Text(
                        'Aquí se mostrará el PDF de la credencial',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 2. Placeholder para el Código QR
            const Text(
              'Código QR de Acceso',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.qr_code_2, 
                size: 150, 
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Escanea este código para registrar tu asistencia.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
