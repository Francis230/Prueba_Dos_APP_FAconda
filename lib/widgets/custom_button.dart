// lib/widgets/custom_button.dart

import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? textColor;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, // Ocupa todo el ancho disponible
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed, // Deshabilita el botón si está cargando
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? Colors.blue, // Color de fondo predeterminado o personalizado
          foregroundColor: textColor ?? Colors.white, // Color del texto predeterminado o personalizado
          padding: const EdgeInsets.symmetric(vertical: 15.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0), // Bordes redondeados
          ),
          elevation: 5, // Sombra para un efecto 3D
          shadowColor: Colors.blue.shade200, // Color de la sombra
        ),
        child: isLoading
            ? const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white), // Indicador de carga blanco
              )
            : Text(
                text,
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}
