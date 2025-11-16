class AuthService {
  // Simulación de validación. Aquí puedes conectar API, Firebase, MySQL, etc.
  Future<bool> login(String user, String pass) async {
    await Future.delayed(const Duration(seconds: 1)); // simula red

    if (user == "admin" && pass == "1234") {
      return true;
    } else {
      return false;
    }
  }
}
