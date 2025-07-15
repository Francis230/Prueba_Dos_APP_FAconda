// lib/services/visitor_service.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:pruebados_fa_supa/models/visitor.dart';
import 'package:fluttertoast/fluttertoast.dart';

class VisitorService extends ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;
  List<Visitor> _visitors = []; // Lista de visitantes
  bool _isLoading = false; // Estado de carga

  List<Visitor> get visitors => _visitors;
  bool get isLoading => _isLoading;

  // Constructor: Inicializa la escucha de cambios en tiempo real
  VisitorService() {
    _listenToVisitors();
  }

  // Escucha los cambios en tiempo real en la tabla 'visitors' de Supabase
  void _listenToVisitors() {
    _supabase
        .from('visitors')
        .stream(primaryKey: ['id']) // Escucha cambios en la tabla 'visitors'
        .order('visit_time', ascending: false) // Ordena por hora de visita descendente
        .listen((List<Map<String, dynamic>> data) {
          _visitors = data.map((map) => Visitor.fromMap(map)).toList();
          notifyListeners(); // Notifica a los oyentes para reconstruir la UI
        }, onError: (error) {
          Fluttertoast.showToast(msg: 'Error en tiempo real: $error');
          print('Error en tiempo real: $error');
        });
  }

  // Obtiene todos los visitantes (inicial o para refrescar)
  Future<void> fetchVisitors() async {
    _isLoading = true;
    notifyListeners();
    try {
      final List<Map<String, dynamic>> response = await _supabase
          .from('visitors')
          .select()
          .order('visit_time', ascending: false); // Ordena por hora de visita descendente

      _visitors = response.map((map) => Visitor.fromMap(map)).toList();
      Fluttertoast.showToast(msg: 'Visitantes cargados exitosamente.');
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error al cargar visitantes: $e');
      print('Error al cargar visitantes: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Agrega un nuevo visitante a Supabase
  Future<String?> addVisitor(String name, String reason, DateTime visitTime, File? photo) async {
    _isLoading = true;
    notifyListeners();

    String? photoUrl;
    final user = _supabase.auth.currentUser;

    if (user == null) {
      Fluttertoast.showToast(msg: 'Usuario no autenticado', backgroundColor: Colors.red);
      _isLoading = false;
      notifyListeners();
      return 'Usuario no autenticado';
    }

    try {
      // Subir imagen si existe
      if (photo != null) {
        try {
          final bytes = await photo.readAsBytes();
          final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';

          await _supabase.storage
              .from('visitorphotos')
              .uploadBinary(fileName, bytes, fileOptions: const FileOptions(upsert: true));

          photoUrl = _supabase.storage.from('visitorphotos').getPublicUrl(fileName);
        } catch (e) {
          Fluttertoast.showToast(msg: 'Error al subir imagen: $e', backgroundColor: Colors.red);
          return 'Error al subir imagen: $e';
        }
      }

      // Insertar visitante en la tabla con user_id
      await _supabase.from('visitors').insert({
        'name': name,
        'reason': reason,
        'visit_time': visitTime.toIso8601String(),
        'photo_url': photoUrl,
        'user_id': user.id, // Necesario para las políticas RLS
      });

      Fluttertoast.showToast(msg: 'Visitante agregado exitosamente.', backgroundColor: Colors.green);
      return null;
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error inesperado: $e', backgroundColor: Colors.red);
      return 'Error inesperado: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}