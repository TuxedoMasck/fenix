import 'package:fenix/Back_interfazContactanos.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InterfazContactanos extends StatelessWidget {
  const InterfazContactanos({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ContactanosLogic(),
      child: const _InterfazContactanosView(),
    );
  }
}

class _InterfazContactanosView extends StatefulWidget {
  const _InterfazContactanosView();

  @override
  State<_InterfazContactanosView> createState() => _InterfazContactanosViewState();
}

class _InterfazContactanosViewState extends State<_InterfazContactanosView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submit(ContactanosLogic logic) async {
    if (!_formKey.currentState!.validate()) return;

    final error = await logic.sendMessage(
      contactEmail: _emailController.text,
      description: _descriptionController.text,
    );

    if (mounted) {
      if (error == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Mensaje enviado con éxito. Te contactaremos a la brevedad.'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final logic = context.watch<ContactanosLogic>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Contáctanos'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                '¿Necesitas ayuda? Déjanos un mensaje y te contactaremos a la brevedad.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Tu Correo de Contacto',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (v) => (v == null || !v.contains('@')) ? 'Ingresa un correo válido' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Describe tu problema o duda',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
                validator: (v) => (v == null || v.isEmpty) ? 'Este campo no puede estar vacío' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
                onPressed: logic.isLoading ? null : () => _submit(logic),
                child: logic.isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Enviar Mensaje'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
