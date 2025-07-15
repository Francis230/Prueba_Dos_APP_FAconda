// lib/main.dart

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:pruebados_fa_supa/config/supabase_config.dart';
import 'package:pruebados_fa_supa/screens/auth/login_screen.dart';
import 'package:pruebados_fa_supa/screens/home/home_screen.dart';
import 'package:pruebados_fa_supa/screens/splash_screen.dart';
import 'package:provider/provider.dart'; // Importa el paquete provider
import 'package:pruebados_fa_supa/services/auth_service.dart';
import 'package:pruebados_fa_supa/services/visitor_service.dart'; // Importa el VisitorService

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa Supabase antes de que la aplicación se ejecute
  await Supabase.initialize(
    url: SupabaseConfig.supabaseUrl,
    anonKey: SupabaseConfig.supabaseAnonKey,
  );

  runApp(
    // Provee el AuthService y el VisitorService a toda la aplicación
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthService()),
        ChangeNotifierProvider(create: (context) => VisitorService()), // Añade VisitorService aquí
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pruebados FA Supa',
      debugShowCheckedModeBanner: false, // Oculta el banner de depuración
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Inter', // Establece la fuente Inter como predeterminada
      ),
      initialRoute: '/', // Define la ruta inicial
      routes: {
        '/': (context) => const SplashScreen(), // Pantalla de carga inicial
        '/login': (context) => const LoginScreen(), // Pantalla de inicio de sesión
        '/home': (context) => const HomeScreen(), // Pantalla principal
      },
    );
  }
}