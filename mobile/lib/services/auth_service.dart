//Este archivo maneja la lógica de pedir el token al Backend y 
//guardarlo en la memoria del celular.

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final String baseUrl = "http://10.0.2.2:8000"; // IP para emulador Android

  // Guardar Token
  Future<void> saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwt_token', token);
  }

  // Obtener Token (Usado en el Reto 6.3)
  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }

  // Borrar Token (Logout)
  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
  }

  // Login
  Future<bool> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/token'),
      body: {'username': username, 'password': password},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      await saveToken(data['access_token']);
      return true;
    }
    return false;
  }
}