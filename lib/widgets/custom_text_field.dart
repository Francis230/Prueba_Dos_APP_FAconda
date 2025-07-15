// lib/widgets/custom_text_field.dart

import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final bool obscureText;
  final TextInputType keyboardType;
  final IconData? prefixIcon;
  final String? Function(String?)? validator; // Validador para el formulario

  const CustomTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0), // Bordes redondeados
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: Colors.blueAccent, width: 1.0), // Borde azul cuando está habilitado
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: Colors.blue, width: 2.0), // Borde azul más grueso cuando está enfocado
        ),
        filled: true,
        fillColor: Colors.blue.shade50, // Fondo ligeramente azulado
        contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      ),
      validator: validator,
    );
  }
}
