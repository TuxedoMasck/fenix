import 'package:fenix/Back_interfas_Principal.dart';
import 'package:fenix/Back_menu_opciones.dart';
import 'package:fenix/login.dart';
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
        home: LoginPage(),
      ),
    ),
  );
}
