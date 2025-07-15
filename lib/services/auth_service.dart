
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AuthService extends ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;
  User? _currentUser; // Almacena el usuario actualmente autenticado

  User? get currentUser => _currentUser;

  AuthService() {
    // Escucha los cambios en el estado de autenticación de Supabase
    _supabase.auth.onAuthStateChange.listen((data) {
      _currentUser = data.session?.user; // Actualiza el usuario actual
      notifyListeners(); // Notifica a los widgets que escuchan sobre el cambio
    });
  }

  // Método para registrar un nuevo usuario
  Future<String?> signUp(String email, String password) async {
    try {
      final AuthResponse response = await _supabase.auth.signUp(
        email: email,
        password: password,
      );
      if (response.user != null) {
        _currentUser = response.user;
        Fluttertoast.showToast(msg: 'Registro exitoso. Por favor, verifica tu correo electrónico.');
        return null; // Éxito
      } else {
        return 'Error al registrar usuario.';
      }
    } on AuthException catch (e) {
      Fluttertoast.showToast(msg: e.message);
      return e.message;
    } catch (e) {
      Fluttertoast.showToast(msg: 'Ocurrió un error inesperado: $e');
      return 'Ocurrió un error inesperado.';
    }
  }

  // Método para iniciar sesión de un usuario existente
  Future<String?> signIn(String email, String password) async {
    try {
      final AuthResponse response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (response.user != null) {
        _currentUser = response.user;
        Fluttertoast.showToast(msg: 'Inicio de sesión exitoso.');
        return null; // Éxito
      } else {
        return 'Error al iniciar sesión.';
      }
    } on AuthException catch (e) {
      Fluttertoast.showToast(msg: e.message);
      return e.message;
    } catch (e) {
      Fluttertoast.showToast(msg: 'Ocurrió un error inesperado: $e');
      return 'Ocurrió un error inesperado.';
    }
  }

  // Método para cerrar la sesión del usuario
  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
      _currentUser = null;
      Fluttertoast.showToast(msg: 'Sesión cerrada.');
    } on AuthException catch (e) {
      Fluttertoast.showToast(msg: e.message);
    } catch (e) {
      Fluttertoast.showToast(msg: 'Ocurrió un error inesperado: $e');
    }
  }
}
