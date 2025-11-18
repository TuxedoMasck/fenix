import 'package:fenix/Back_interfazAyuda.dart';
import 'package:flutter/material.dart';

class InterfazAyuda extends StatefulWidget {
  const InterfazAyuda({super.key});

  @override
  State<InterfazAyuda> createState() => _InterfazAyudaState();
}

class _InterfazAyudaState extends State<InterfazAyuda> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _service = SupportService();
  bool _isLoading = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final ticket = SupportTicket(
      email: _emailController.text.trim(),
      description: _descriptionController.text.trim(),
    );

    setState(() => _isLoading = true);
    final success = await _service.sendTicket(ticket);
    setState(() => _isLoading = false);

    final snackBar = SnackBar(
      content: Text(success
          ? 'Mensaje enviado. Nos pondremos en contacto contigo.'
          : 'Error al enviar el mensaje.'),
      backgroundColor: success ? Colors.green : Colors.red,
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      if (success) {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Soporte y Ayuda'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '¿Necesitas ayuda? Déjanos un mensaje y te contactaremos a la brevedad.',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Tu Correo de Contacto',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || !value.contains('@')) {
                    return 'Ingresa un correo válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Describe tu problema o duda',
                  prefixIcon: Icon(Icons.description),
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor, describe tu problema.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton.icon(
                      onPressed: _submit,
                      icon: const Icon(Icons.send),
                      label: const Text('Enviar Mensaje'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
