// lib/screens/auth/register_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pruebados_fa_supa/services/auth_service.dart';
import 'package:pruebados_fa_supa/widgets/custom_text_field.dart';
import 'package:pruebados_fa_supa/widgets/custom_button.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // Clave para el formulario
  bool _isLoading = false; // Estado de carga para el botón

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      final authService = Provider.of<AuthService>(context, listen: false);
      final String? error = await authService.signUp(
        _emailController.text,
        _passwordController.text,
      );
      setState(() {
        _isLoading = false;
      });
      if (error == null) {
        // Si el registro es exitoso, regresa a la pantalla de inicio de sesión
        Navigator.of(context).pop();
      }
      // Los mensajes de error se manejan dentro de AuthService con Fluttertoast
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrarse'),
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
                    Icons.person_add,
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
                  const SizedBox(height: 20),
                  CustomTextField(
                    controller: _confirmPasswordController,
                    labelText: 'Confirmar Contraseña',
                    obscureText: true,
                    prefixIcon: Icons.lock_reset,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, confirma tu contraseña';
                      }
                      if (value != _passwordController.text) {
                        return 'Las contraseñas no coinciden';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),
                  CustomButton(
                    text: 'Registrarse',
                    onPressed: _signUp,
                    isLoading: _isLoading,
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Regresa a la pantalla de inicio de sesión
                    },
                    child: Text(
                      '¿Ya tienes una cuenta? Inicia sesión',
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
