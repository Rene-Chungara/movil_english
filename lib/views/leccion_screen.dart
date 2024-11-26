import 'package:flutter/material.dart';
import '../models/leccion.dart';
import '../services/leccion_service.dart';

class LeccionScreen extends StatefulWidget {
  @override
  _LeccionScreenState createState() => _LeccionScreenState();
}

class _LeccionScreenState extends State<LeccionScreen> {
  final LeccionService _leccionService = LeccionService();
  late Future<List<Leccion>> _leccionesFuture;

  @override
  void initState() {
    super.initState();
    _leccionesFuture = _leccionService.fetchLecciones();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lecciones'),
      ),
      body: FutureBuilder<List<Leccion>>(
        future: _leccionesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay lecciones disponibles'));
          }

          final lecciones = snapshot.data!;

          return ListView.builder(
            itemCount: lecciones.length,
            itemBuilder: (context, index) {
              final leccion = lecciones[index];
              return ListTile(
                title: Text(leccion.nombre),
                subtitle: Text(leccion.descripcion ?? 'Sin descripción'),
              );
            },
          );
        },
      ),
    );
  }
}
