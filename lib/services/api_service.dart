import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class ApiService {
  final String baseUrl = "http://18.191.150.96/api"; // Cambia esta URL


  Future<String?> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['accessToken'];
        // Guarda el token en SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);
        return token;
      } else {
        throw Exception('Error al iniciar sesión');
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  // Recupera el token de SharedPreferences
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token'); // Cambia 'auth_token' según tu clave
  }
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  // Recupera los niveles desde la API
  Future<List<dynamic>> getNiveles() async {
    try {
      final token = await _getToken();
      if (token == null) {
        throw Exception('No se encontró un token válido');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/nivel'),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Error al obtener los niveles: ${response.statusCode}');
      }
    } catch (e) {
      print('Error en getNiveles: $e');
      return [];
    }
  }

  Future<List<dynamic>> getLecciones(String token, int nivel_id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/nivel/$nivel_id/lecciones'),
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

  Future<List<dynamic>> getLeccionesByNivelId(String token, int nivelId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/nivel/$nivelId/lecciones'),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body); // Decodifica la respuesta JSON
      } else {
        print('Error al obtener las lecciones: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error al conectar con la API: $e');
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
