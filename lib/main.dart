import 'package:fenix/Back_interfas_Principal.dart';
import 'package:flutter/material.dart';
import 'interfas_Principal.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => InterfazPrincipalLogic(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: InterfazPrincipal(),
      ),
    ),
  );
}
