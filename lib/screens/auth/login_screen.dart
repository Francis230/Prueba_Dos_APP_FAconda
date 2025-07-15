// lib/screens/auth/login_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pruebados_fa_supa/screens/auth/register_screen.dart';
import 'package:pruebados_fa_supa/services/auth_service.dart';
import 'package:pruebados_fa_supa/widgets/custom_text_field.dart';
import 'package:pruebados_fa_supa/widgets/custom_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // Clave para el formulario
  bool _isLoading = false; // Estado de carga para el botón

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      final authService = Provider.of<AuthService>(context, listen: false);
      final String? error = await authService.signIn(
        _emailController.text,
        _passwordController.text,
      );
      setState(() {
        _isLoading = false;
      });
      if (error == null) {
        // Navega a la pantalla principal si el inicio de sesión es exitoso
        Navigator.of(context).pushReplacementNamed('/home');
      }
      // Los mensajes de error se manejan dentro de AuthService con Fluttertoast
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Iniciar Sesión'),
        centerTitle: true,
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 
                  Icon(
                    Icons.login,
                    size: 100,
                    color: Colors.blue.shade700,
                  ),
                  const SizedBox(height: 30),
                  CustomTextField(
                    controller: _emailController,
                    labelText: 'Correo Electrónico',
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icons.email,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, ingresa tu correo electrónico';
                      }
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'Por favor, ingresa un correo electrónico válido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    controller: _passwordController,
                    labelText: 'Contraseña',
                    obscureText: true,
                    prefixIcon: Icons.lock,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, ingresa tu contraseña';
                      }
                      if (value.length < 6) {
                        return 'La contraseña debe tener al menos 6 caracteres';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),
                  CustomButton(
                    text: 'Iniciar Sesión',
                    onPressed: _signIn,
                    isLoading: _isLoading,
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      // Navega a la pantalla de registro
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const RegisterScreen()),
                      );
                    },
                    child: Text(
                      '¿No tienes una cuenta? Regístrate aquí',
                      style: TextStyle(color: Colors.blue.shade700),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}