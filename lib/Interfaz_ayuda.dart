import 'package:fenix/Interfaz_Contactanos.dart';
import 'package:flutter/material.dart';

class InterfazAyuda extends StatelessWidget {
  const InterfazAyuda({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Soporte y Ayuda'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSupportOption(
            context: context,
            icon: Icons.quiz_outlined,
            title: 'Preguntas frecuentes',
            subtitle: 'Encuentra respuestas a las dudas más comunes.',
            onTap: () { /* TODO: Navegar a pantalla de FAQ */ },
          ),
          _buildSupportOption(
            context: context,
            icon: Icons.headset_mic_outlined,
            title: 'Contáctanos',
            subtitle: 'Habla con nuestro equipo de soporte.',
            onTap: () {
              // 2. Conectar el botón a la nueva pantalla
              Navigator.push(context, MaterialPageRoute(builder: (_) => const InterfazContactanos()));
            },
          ),
          _buildSupportOption(
            context: context,
            icon: Icons.note_add_outlined,
            title: 'Abrir un reporte',
            subtitle: 'Crea un nuevo ticket de soporte para un problema.',
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const InterfazCrearReporte()));
            },
          ),
          _buildSupportOption(
            context: context,
            icon: Icons.history_outlined,
            title: 'Ver mis reportes',
            subtitle: 'Consulta el estado de tus tickets anteriores.',
            onTap: () { /* TODO: Navegar a pantalla de historial de reportes */ },
          ),
        ],
      ),
    );
  }

  Widget _buildSupportOption({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      child: ListTile(
        leading: Icon(icon, size: 40, color: Theme.of(context).primaryColor),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}


class InterfazCrearReporte extends StatefulWidget {
  const InterfazCrearReporte({super.key});

  @override
  State<InterfazCrearReporte> createState() => _InterfazCrearReporteState();
}

class _InterfazCrearReporteState extends State<InterfazCrearReporte> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isLoading = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() => _isLoading = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Reporte enviado con éxito.'), backgroundColor: Colors.green),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Abrir un Reporte'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Tu Correo de Contacto'),
                validator: (v) => (v == null || !v.contains('@')) ? 'Correo inválido' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Describe tu problema'),
                maxLines: 5,
                validator: (v) => (v == null || v.isEmpty) ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 24),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton.icon(
                      onPressed: _submit,
                      icon: const Icon(Icons.send),
                      label: const Text('Enviar Reporte'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
