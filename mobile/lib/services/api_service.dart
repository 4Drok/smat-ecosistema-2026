import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart'; // Importante para obtener el token
import '../models/estacion.dart';

class ApiService {
  final String baseUrl = "http://10.0.2.2:8000";

  // 1. Obtener cabeceras con el Token (Requerido para el POST)
  Future<Map<String, String>> _getHeaders() async {
    String? token = await AuthService().getToken(); // Recupera el token guardado
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token', // Formato estándar JWT
    };
  }

  // 2. Método GET: Leer estaciones (Público o Privado)
  Future<List<Estacion>> fetchEstaciones() async {
    final response = await http.get(Uri.parse('$baseUrl/sensor/data'));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((item) => Estacion.fromJson(item)).toList();
    } else {
      throw Exception('Fallo al cargar estaciones');
    }
  }

  // 3. PASO 3: Método POST Protegido (Escritura en SMAT)
  Future<bool> crearEstacion(String nombre, String ubicacion) async {
    final url = Uri.parse('$baseUrl/sensor/data');
    final headers = await _getHeaders(); // Obtenemos cabeceras con el Token
    
    final body = jsonEncode({
      'nombre': nombre,
      'ubicacion': ubicacion,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Estación creada con éxito");
        return true;
      } else {
        print("Error de autenticación o validación: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("Error de red: $e");
      return false;
    }
  }
}