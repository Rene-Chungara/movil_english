import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/leccion.dart';

class LeccionService {
  final String baseUrl = 'http://127.0.0.1:8000/api';

  // Obtener todas las lecciones
  Future<List<Leccion>> fetchLecciones() async {
    final response = await http.get(Uri.parse('$baseUrl/leccion'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Leccion.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar las lecciones');
    }
  }

  // Crear una nueva lección
  Future<Leccion> createLeccion(Leccion leccion) async {
    final response = await http.post(
      Uri.parse('$baseUrl/leccion'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(leccion.toJson()),
    );

    if (response.statusCode == 201) {
      return Leccion.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al crear la lección');
    }
  }

  // Actualizar una lección existente
  Future<Leccion> updateLeccion(int id, Leccion leccion) async {
    final response = await http.put(
      Uri.parse('$baseUrl/leccion/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(leccion.toJson()),
    );

    if (response.statusCode == 200) {
      return Leccion.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al actualizar la lección');
    }
  }

  // Eliminar una lección
  Future<void> deleteLeccion(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/leccion/$id'));

    if (response.statusCode != 200) {
      throw Exception('Error al eliminar la lección');
    }
  }
}
