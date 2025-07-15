// lib/widgets/loading_indicator.dart

import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(), // Indicador de progreso circular
          SizedBox(height: 16),
          Text('Cargando...'), // Texto de carga
        ],
      ),
    );
  }
}
