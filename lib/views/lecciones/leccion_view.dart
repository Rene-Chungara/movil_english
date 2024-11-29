import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class LeccionesView extends StatefulWidget {
  final int nivelId;
  final String nivelNombre;

  const LeccionesView({
    Key? key,
    required this.nivelId,
    required this.nivelNombre,
  }) : super(key: key);

  @override
  _LeccionesViewState createState() => _LeccionesViewState();
}

class _LeccionesViewState extends State<LeccionesView> {
  late Future<List<dynamic>> _leccionesFuture;

  @override
  void initState() {
    super.initState();
    print('Cargando lecciones para nivelId: ${widget.nivelId}, nombre: ${widget.nivelNombre}');
    // Llamada a la API para obtener las lecciones del nivel seleccionado
    _leccionesFuture = ApiService().getLeccionesByNivelId(widget.nivelId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lecciones de ${widget.nivelNombre}'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _leccionesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay lecciones disponibles.'));
          } else {
            final lecciones = snapshot.data!;
            return ListView.builder(
              itemCount: lecciones.length,
              itemBuilder: (context, index) {
                final leccion = lecciones[index];
                return Card(
                  child: ListTile(
                    title: Text(leccion['nombre'] ?? 'Sin nombre'),
                    subtitle: Text(leccion['descripcion'] ?? 'Sin descripción'),
                    onTap: () {
                      // Aquí puedes agregar la lógica para navegar a la vista de detalles de la lección
                      print('Seleccionaste la lección: ${leccion['nombre']}');
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
