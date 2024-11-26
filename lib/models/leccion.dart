import 'package:flutter/material.dart';

class Leccion {
  final int id;
  final String nombre;
  final String? descripcion;
  final int nivelId;

  Leccion({
    required this.id,
    required this.nombre,
    this.descripcion,
    required this.nivelId,
  });
// Método para convertir un JSON a una instancia de Leccion
  factory Leccion.fromJson(Map<String, dynamic> json) {
    return Leccion(
      id: json['id'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      nivelId: json['nivel_id'],
    );
  }
  // Método para convertir una instancia de Leccion a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
      'nivel_id': nivelId,
    };
  }
}
