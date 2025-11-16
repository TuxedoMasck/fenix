
import 'package:fenix/Back_interfas_Principal.dart';
import 'package:fenix/Back_menu_opciones.dart';
import 'package:fenix/login.dart'; // Importa la pantalla de login
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => InterfazPrincipalLogic()),
        ChangeNotifierProvider(create: (context) => MenuOpcionesLogic()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        // Se restaura la página de inicio a la pantalla de login
        home: LoginPage(),
      ),
    ),
  );
}
