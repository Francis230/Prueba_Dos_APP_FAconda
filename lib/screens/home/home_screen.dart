// lib/screens/home/home_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pruebados_fa_supa/screens/auth/login_screen.dart';
import 'package:pruebados_fa_supa/services/auth_service.dart';
import 'package:pruebados_fa_supa/services/visitor_service.dart';
import 'package:pruebados_fa_supa/models/visitor.dart';
import 'package:pruebados_fa_supa/screens/home/add_visitor_screen.dart';
import 'package:pruebados_fa_supa/widgets/loading_indicator.dart';
import 'package:intl/intl.dart'; // Para formatear la fecha y hora

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Inicia la carga de visitantes cuando la pantalla se inicializa
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<VisitorService>(context, listen: false).fetchVisitors();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Escucha los cambios en VisitorService y AuthService
    final visitorService = Provider.of<VisitorService>(context);
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Visitantes de la Oficina'),
        centerTitle: true,
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authService.signOut(); // Cierra la sesión del usuario
              // Navega a la pantalla de inicio de sesión y elimina todas las rutas anteriores
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (Route<dynamic> route) => false,
              );
            },
          ),
        ],
      ),
      body: visitorService.isLoading
          ? const LoadingIndicator() // Muestra el indicador de carga si los datos están cargando
          : visitorService.visitors.isEmpty
              ? const Center(
                  child: Text(
                    'No hay visitantes registrados aún.',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: visitorService.visitors.length,
                  itemBuilder: (context, index) {
                    final visitor = visitorService.visitors[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 15.0),
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0), // Bordes redondeados
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Row(
                          children: [
                            // Muestra la foto del visitante si está disponible
                            if (visitor.photoUrl != null && visitor.photoUrl!.isNotEmpty)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: Image.network(
                                  visitor.photoUrl!,
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: 80,
                                      height: 80,
                                      color: Colors.grey.shade200,
                                      child: const Icon(Icons.person, size: 50, color: Colors.grey),
                                    );
                                  },
                                ),
                              )
                            else
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade100,
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: const Icon(Icons.person, size: 50, color: Colors.blue),
                              ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    visitor.name,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blueAccent,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    'Motivo: ${visitor.reason}',
                                    style: const TextStyle(fontSize: 16, color: Colors.black87),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    'Hora: ${DateFormat('dd/MM/yyyy HH:mm').format(visitor.visitTime)}',
                                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Navega a la pantalla para agregar un nuevo visitante
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const AddVisitorScreen()),
          );
        },
        label: const Text('Agregar Visitante'),
        icon: const Icon(Icons.person_add),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat, // Centra el botón flotante
    );
  }
}