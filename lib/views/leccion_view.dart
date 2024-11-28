import 'package:flutter/material.dart';
import '../models/leccion.dart';
//import '../services/leccion_services.dart';

class LeccionView extends StatefulWidget {
  @override
  _LeccionViewState createState() => _LeccionViewState();
}

class _LeccionViewState extends State<LeccionView> {
  //final LeccionService _leccionService = LeccionService();
  late Future<List<Leccion>> _lecciones;

  @override
  void initState() {
    super.initState();
    //_lecciones = _leccionService.fetchLecciones();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lecciones'),
      ),
      body: FutureBuilder<List<Leccion>>(
        future: _lecciones,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
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
          } else {
            return Center(child: Text('No hay lecciones disponibles'));
          }
        },
      ),
    );
  }
}
