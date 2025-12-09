import 'package:fenix/Back_interfas_Principal.dart';
import 'package:fenix/Back_interfazRegistro.dart';
import 'package:fenix/login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseConfig.initialize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => InterfazPrincipalLogic()),
        ChangeNotifierProvider(create: (_) => RegistroLogic()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: LoginPage(),
      ),
    ),
  );//concre es puñal
}
