import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
    _initializeLecciones();
  }

  Future<void> _initializeLecciones() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token != null) {
      setState(() {
        _leccionesFuture = ApiService().getLeccionesByNivelId(token, widget.nivelId);
      });
    } else {
      setState(() {
        _leccionesFuture = Future.error('No se encontró el token.');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lecciones de ${widget.nivelNombre}'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.lightBlue],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: FutureBuilder<List<dynamic>>(
          future: _leccionesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error al cargar las lecciones: ${snapshot.error}',
                  style: const TextStyle(color: Colors.red),
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text(
                  'No hay lecciones disponibles.',
                  style: TextStyle(fontSize: 18),
                ),
              );
            } else {
              final lecciones = snapshot.data!;
              return ListView.builder(
                itemCount: lecciones.length,
                itemBuilder: (context, index) {
                  final leccion = lecciones[index];
                  return _buildLeccionCard(leccion);
                },
              );
            }
          },
        ),
      ),
    );
  }

  // Construye cada tarjeta de lección
  Widget _buildLeccionCard(Map<String, dynamic> leccion) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 5,
      child: ListTile(
        leading: const FaIcon(
          FontAwesomeIcons.book,
          color: Colors.blueAccent,
        ),
        title: Text(
          leccion['nombre'] ?? 'Sin nombre',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          leccion['descripcion'] ?? 'Sin descripción',
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward,
          color: Colors.blueAccent,
        ),
        onTap: () {
          // Aquí puedes agregar lógica para ir a detalles de la lección
          print('Seleccionaste la lección: ${leccion['nombre']}');
        },
      ),
    );
  }
}
