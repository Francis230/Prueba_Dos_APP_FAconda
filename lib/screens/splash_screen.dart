import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';
import 'package:pruebados_fa_supa/services/auth_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _redirect(); // Llama a la función de redirección al inicializar la pantalla
  }

  Future<void> _redirect() async {
    // Espera un pequeño retraso para que la inicialización de Supabase se complete
    await Future.delayed(Duration.zero);
    final session = Supabase.instance.client.auth.currentSession;
    if (session == null) {
      // Si no hay sesión activa, navega a la pantalla de inicio de sesión
      Navigator.of(context).pushReplacementNamed('/login');
    } else {
      // Si hay una sesión activa, navega a la pantalla principal
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(), // Muestra un indicador de carga mientras se redirige
      ),
    );
  }
}
