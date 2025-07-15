// lib/screens/home/add_visitor_screen.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart'; // Mantener la importación por si se usa en otro lugar o para futura expansión
import 'package:provider/provider.dart';
import 'package:pruebados_fa_supa/services/visitor_service.dart';
import 'package:pruebados_fa_supa/widgets/custom_text_field.dart';
import 'package:pruebados_fa_supa/widgets/custom_button.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class AddVisitorScreen extends StatefulWidget {
  const AddVisitorScreen({super.key});

  @override
  State<AddVisitorScreen> createState() => _AddVisitorScreenState();
}

class _AddVisitorScreenState extends State<AddVisitorScreen> {
  final _nameController = TextEditingController();
  final _reasonController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  DateTime _selectedDateTime = DateTime.now();
  File? _imageFile;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  // Función simplificada para "solicitar" permisos.
  // Ahora siempre devuelve true, asumiendo que los permisos ya fueron concedidos
  // por el usuario a través de la configuración del sistema operativo.
  Future<bool> _requestPermissions() async {
    // No se realizan verificaciones ni solicitudes en tiempo de ejecución aquí.
    // Se asume que el usuario ha gestionado los permisos previamente.
    return true;
  }

  // Función para seleccionar una imagen de la galería o tomar una foto
  Future<void> _pickImage(ImageSource source) async {
    // La llamada a _requestPermissions() ahora siempre devolverá true.
    // Si los permisos no están realmente concedidos, image_picker fallará.
    if (!await _requestPermissions()) {
      // Este bloque de código ya no se ejecutará con la implementación actual de _requestPermissions()
      // a menos que la lógica de _requestPermissions() sea modificada en el futuro.
      return;
    }

    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      } else {
        Fluttertoast.showToast(msg: 'No se seleccionó ninguna imagen.');
      }
    });
  }

  // Función para seleccionar la fecha y hora
  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
      );
      if (pickedTime != null) {
        setState(() {
          _selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  // Función para guardar el nuevo visitante
  Future<void> _saveVisitor() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      final visitorService = Provider.of<VisitorService>(context, listen: false);
      final String? error = await visitorService.addVisitor(
        _nameController.text,
        _reasonController.text,
        _selectedDateTime,
        _imageFile,
      );
      setState(() {
        _isLoading = false;
      });
      if (error == null) {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Nuevo Visitante'),
        centerTitle: true,
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomTextField(
                  controller: _nameController,
                  labelText: 'Nombre del Visitante',
                  prefixIcon: Icons.person,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingresa el nombre del visitante';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: _reasonController,
                  labelText: 'Motivo de la Visita',
                  prefixIcon: Icons.info,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingresa el motivo de la visita';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () => _selectDateTime(context),
                  child: AbsorbPointer(
                    child: CustomTextField(
                      controller: TextEditingController(
                        text: DateFormat('dd/MM/yyyy HH:mm').format(_selectedDateTime),
                      ),
                      labelText: 'Hora de la Visita',
                      prefixIcon: Icons.calendar_today,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Column(
                    children: [
                      _imageFile == null
                          ? Container(
                              width: 150,
                              height: 150,
                              decoration: BoxDecoration(
                                color: Colors.blue.shade100,
                                borderRadius: BorderRadius.circular(10.0),
                                border: Border.all(color: Colors.blueAccent, width: 2),
                              ),
                              child: Icon(
                                Icons.camera_alt,
                                size: 80,
                                color: Colors.blue.shade700,
                              ),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Image.file(
                                _imageFile!,
                                width: 150,
                                height: 150,
                                fit: BoxFit.cover,
                              ),
                            ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () => _pickImage(ImageSource.camera),
                            icon: const Icon(Icons.camera),
                            label: const Text('Tomar Foto'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.shade600,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton.icon(
                            onPressed: () => _pickImage(ImageSource.gallery),
                            icon: const Icon(Icons.image),
                            label: const Text('Seleccionar de Galería'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.shade600,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                CustomButton(
                  text: 'Guardar Visitante',
                  onPressed: _saveVisitor,
                  isLoading: _isLoading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}