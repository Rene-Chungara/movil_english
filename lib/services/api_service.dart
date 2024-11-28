import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = "http://192.168.0.16:8000/api"; // Cambia esta URL


  Future<String?> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['accessToken'];
      } else {
        throw Exception('Error al iniciar sesión');
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<List<dynamic>> getNiveles(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/nivel'),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Error al obtener los niveles');
      }
    } catch (e) {
      print(e);
      return [];
    }
  }

  // Nuevo método para guardar un nivel
  Future<bool> guardarNivel(String nombre, String descripcion, String token) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/nivel'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",  // Pasar el token aquí
        },
        body: jsonEncode({"nombre": nombre, "descripcion": descripcion}),
      );

      if (response.statusCode == 201) {
        return true; // Nivel guardado exitosamente
      } else {
        print('Error al guardar nivel response: ${response.statusCode} - ${response.body}');
        return false; // Hubo un error al guardar el nivel
      }
    } catch (e) {
      print('Error al guardar nivel catch: $e');
      return false; // Error en la conexión o en la petición
    }
  }
}
