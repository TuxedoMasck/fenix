import 'package:fenix/Back_Olvidecontrase%C3%B1a.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InterfazOlvideContrasena extends StatelessWidget {
  const InterfazOlvideContrasena({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OlvideContrasenaLogic(),
      child: const _InterfazOlvideContrasenaView(),
    );
  }
}

class _InterfazOlvideContrasenaView extends StatefulWidget {
  const _InterfazOlvideContrasenaView();

  @override
  State<_InterfazOlvideContrasenaView> createState() =>
      _InterfazOlvideContrasenaViewState();
}

class _InterfazOlvideContrasenaViewState
    extends State<_InterfazOlvideContrasenaView> {
  final _emailController = TextEditingController();
  final _codeController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _codeController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleLogic(BuildContext context, String? error) {
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: Colors.red),
      );
    }
  }
  
  void _handleSuccess(BuildContext context, String message) {
     ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.green),
      );
  }

  @override
  Widget build(BuildContext context) {
    final logic = context.watch<OlvideContrasenaLogic>();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Reestablecer Contraseña'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _buildStep(logic),
        ),
      ),
    );
  }

  Widget _buildStep(OlvideContrasenaLogic logic) {
    switch (logic.currentStep) {
      case ResetStep.enterEmail:
        return _buildEnterEmailStep(logic);
      case ResetStep.enterCode:
        return _buildEnterCodeStep(logic);
      case ResetStep.createPassword:
        return _buildCreatePasswordStep(logic);
    }
  }

  Widget _buildEnterEmailStep(OlvideContrasenaLogic logic) {
    return Column(
      key: const ValueKey('step1'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('Paso 1: Identificación', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        TextField(
          controller: _emailController,
          decoration: const InputDecoration(labelText: 'Ingresa tu correo electrónico'),
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: logic.isLoading ? null : () async {
            final error = await logic.sendResetEmail(_emailController.text);
             if (error == null) {
                _handleSuccess(context, 'Correo enviado. Revisa tu bandeja de entrada.');
            } else {
                _handleLogic(context, error);
            }
          },
          style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
          child: logic.isLoading ? const CircularProgressIndicator() : const Text('Enviar código de confirmación'),
        ),
      ],
    );
  }

  Widget _buildEnterCodeStep(OlvideContrasenaLogic logic) {
    return Column(
      key: const ValueKey('step2'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('Paso 2: Verificación', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        TextField(
          controller: _codeController,
          decoration: const InputDecoration(labelText: 'Inserta el código de confirmación'),
          keyboardType: TextInputType.number,
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: logic.isLoading ? null : () async {
               final error = await logic.resendCode();
                 if (error == null) {
                    _handleSuccess(context, 'Se ha reenviado el código.');
                } else {
                    _handleLogic(context, error);
                }
            },
            child: const Text('Reenviar código'),
          ),
        ),
        const SizedBox(height: 24),
         ElevatedButton(
          onPressed: logic.isLoading ? null : () async {
            final error = await logic.verifyCode(_codeController.text);
            _handleLogic(context, error);
          },
          style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
          child: logic.isLoading ? const CircularProgressIndicator() : const Text('Verificar código'),
        ),
      ],
    );
  }

  Widget _buildCreatePasswordStep(OlvideContrasenaLogic logic) {
    return Column(
      key: const ValueKey('step3'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('Paso 3: Nueva Contraseña', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        TextField(
          controller: _newPasswordController,
          obscureText: logic.isNewPasswordHidden,
          decoration: InputDecoration(
            labelText: 'Nueva contraseña',
            suffixIcon: IconButton(
              icon: Icon(logic.isNewPasswordHidden ? Icons.visibility_off : Icons.visibility),
              onPressed: logic.toggleNewPasswordVisibility,
            ),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _confirmPasswordController,
          obscureText: logic.isConfirmPasswordHidden,
          decoration: InputDecoration(
            labelText: 'Confirmar nueva contraseña',
             suffixIcon: IconButton(
              icon: Icon(logic.isConfirmPasswordHidden ? Icons.visibility_off : Icons.visibility),
              onPressed: logic.toggleConfirmPasswordVisibility,
            ),
          ),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
           onPressed: logic.isLoading ? null : () async {
            if (_newPasswordController.text != _confirmPasswordController.text) {
              _handleLogic(context, 'Las contraseñas no coinciden.');
              return;
            }
             if (_newPasswordController.text.length < 6) {
              _handleLogic(context, 'La contraseña debe tener al menos 6 caracteres.');
              return;
            }
            final error = await logic.setNewPassword(_newPasswordController.text);
             if (error == null) {
                _handleSuccess(context, '¡Contraseña actualizada con éxito! Ya puedes iniciar sesión.');
                Navigator.of(context).pop();
            } else {
                _handleLogic(context, error);
            }
          },
          style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
          child: logic.isLoading ? const CircularProgressIndicator() : const Text('Confirmar cambios'),
        ),
      ],
    );
  }
}
