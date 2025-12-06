import 'package:fenix/Back_interfazRegistro.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InterfazRegistro extends StatelessWidget {
  const InterfazRegistro({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RegistroLogic(),
      child: const _InterfazRegistroView(),
    );
  }
}

class _InterfazRegistroView extends StatefulWidget {
  const _InterfazRegistroView();

  @override
  State<_InterfazRegistroView> createState() => _InterfazRegistroViewState();
}

class _InterfazRegistroViewState extends State<_InterfazRegistroView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _idController = TextEditingController();
  final _departmentController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _idController.dispose();
    _departmentController.dispose();
    super.dispose();
  }

  Future<void> _submit(RegistroLogic logic) async {
    if (!_formKey.currentState!.validate()) return;

    if (logic.pickedPdf == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, sube tu credencial en PDF.'), backgroundColor: Colors.red),
      );
      return;
    }

    final request = RegistrationRequest(
      fullName: _nameController.text,
      institutionalEmail: _emailController.text,
      uamId: _idController.text,
      department: _departmentController.text,
      pdfFile: logic.pickedPdf!,
    );

    final result = await logic.sendRequest(request);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result), backgroundColor: Colors.green),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final logic = context.watch<RegistroLogic>();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Solicitud de Registro UAM'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Sube tu credencial vigente para verificar tu identidad ante la Universidad',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nombre completo'),
                validator: (v) => v!.isEmpty ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Correo institucional',
                  helperText: '@alumnos.cua.uam.mx, @cua.uam.mx y correo.cua.uam.mx,'),
                keyboardType: TextInputType.emailAddress,
                validator: RegistroLogic.validateUamEmail,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _idController,
                decoration: const InputDecoration(labelText: 'Matrícula / Número de empleado'),
                validator: (v) => v!.isEmpty ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _departmentController,
                decoration: const InputDecoration(labelText: 'División o departamento'),
                validator: (v) => v!.isEmpty ? 'Campo requerido' : null,
              ),
              //funcion corregida solo para pdf sin espacios
              const SizedBox(height: 24),
              const Text('Adjuntar Credencial (PDF nombre sin espacios)', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              InkWell(
                onTap: logic.pickPdf,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: logic.pickedPdf == null
                      ? const Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.upload_file), SizedBox(width: 8), Text('Seleccionar archivo PDF')])
                      : Row(mainAxisAlignment: MainAxisAlignment.center, children: [const Icon(Icons.check_circle, color: Colors.green), const SizedBox(width: 8), Flexible(child: Text(logic.pickedPdf!.name, overflow: TextOverflow.ellipsis))]),
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: logic.isLoading ? null : () => _submit(logic),
                style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
                child: logic.isLoading ? const CircularProgressIndicator() : const Text('Enviar Solicitud'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
