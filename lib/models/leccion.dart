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

  factory Leccion.fromJson(Map<String, dynamic> json) {
    return Leccion(
      id: json['id'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      nivelId: json['nivel_id'],
    );
  }
}
