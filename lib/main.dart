import 'package:fenix/Back_interfas_Principal.dart';
import 'package:fenix/login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => InterfazPrincipalLogic(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: LoginPage(),
      ),
    ),
  );
}
