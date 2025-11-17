import 'package:fenix/Back_login.dart';
import 'package:fenix/Interfaz_Principal.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController userController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final AuthService auth = AuthService();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Iniciar Sesión',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: TextField(
                controller: userController,
                decoration: InputDecoration(
                  labelText: 'Email', // El usuario ahora es el email
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
            ),
            SizedBox(height: 15),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: TextField(
                controller: passController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 25),
            ElevatedButton(
              onPressed: () async {
                final email = userController.text;
                final pass = passController.text;

                final errorMessage = await auth.login(email, pass);

                if (errorMessage == null) {
                  // Si no hay error, navega a la pantalla principal.
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const InterfazPrincipal(),
                    ),
                  );
                } else {
                  // Si hay un error, muéstralo en el SnackBar.
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(errorMessage), 
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: Text('Entrar'),
            ),
          ],
        ),
      ),
    );
  }
}
