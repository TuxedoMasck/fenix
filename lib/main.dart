import 'package:fenix/Back_interfas_Principal.dart';
import 'package:fenix/Back_interfazRegistro.dart';
import 'package:fenix/Back_Theme.dart';
import 'package:fenix/SplashPage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fenix/supabase_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseConfig.initialize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeLogic()), 
        ChangeNotifierProvider(create: (_) => InterfazPrincipalLogic()),
        ChangeNotifierProvider(create: (_) => RegistroLogic()),
      ],
      child: const FenixApp(),
    ),
  );
}

class FenixApp extends StatelessWidget {
  const FenixApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeLogic = context.watch<ThemeLogic>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: themeLogic.themeMode,
      // La pantalla de inicio ahora es SplashPage
      home: const SplashPage(),
    );
  }
}
