import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Enum para controlar el paso actual
enum ResetStep {
  enterEmail,
  enterCode,
  createPassword,
}

class OlvideContrasenaLogic extends ChangeNotifier {
  final _supabase = Supabase.instance.client;

  bool _isLoading = false;
  ResetStep _currentStep = ResetStep.enterEmail;

  // Variables para la visibilidad de las contraseñas
  bool _isNewPasswordHidden = true;
  bool _isConfirmPasswordHidden = true;

  // Getters para que la UI
  bool get isLoading => _isLoading;
  ResetStep get currentStep => _currentStep;
  bool get isNewPasswordHidden => _isNewPasswordHidden;
  bool get isConfirmPasswordHidden => _isConfirmPasswordHidden;

  String _email = '';
  String _token = '';

  /// Paso 1:
  Future<String?> sendResetEmail(String email) async {
    if (email.isEmpty || !email.contains('@')) {
      return 'Por favor, ingresa un correo válido.';
    }
    _isLoading = true;
    notifyListeners();

    try {
      await _supabase.auth.resetPasswordForEmail(email);
      _email = email; // Guarda el email para el siguiente paso
      _currentStep = ResetStep.enterCode; // Avanza al siguiente paso
      return null; // Sin errores
    } on AuthException catch (e) {
      return e.message;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Reenvía el correo
  Future<String?> resendCode() async {
    return await sendResetEmail(_email);
  }

  /// Paso 2
  Future<String?> verifyCode(String token) async {
    if (token.isEmpty) return "El código no puede estar vacío.";

    _isLoading = true;
    notifyListeners();

    try {
      final response = await _supabase.auth.verifyOTP(
        token: token,
        type: OtpType.recovery,
        email: _email,
      );

      if (response.session != null) {
        _token = token; // Guarda el token para el paso final
        _currentStep = ResetStep.createPassword; // Avanza al paso final
        return null;
      }
      return "Código inválido o expirado. Intenta de nuevo.";
    } on AuthException catch (e) {
      return e.message;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Paso 3
  Future<String?> setNewPassword(String newPassword) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _supabase.auth.updateUser(
        UserAttributes(password: newPassword),
      );
      return null;
    } on AuthException catch (e) {
      return e.message;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  //

  void toggleNewPasswordVisibility() {
    _isNewPasswordHidden = !_isNewPasswordHidden;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    _isConfirmPasswordHidden = !_isConfirmPasswordHidden;
    notifyListeners();
  }
}
