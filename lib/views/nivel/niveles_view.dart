import 'package:flutter/material.dart';
import 'package:flutter_english/models/user_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../services/api_service.dart';
import '../drawer_menu.dart'; // Asegúrate de tener el DrawerMenu importado

class NivelesView extends StatefulWidget {
  final User user;
  const NivelesView({Key? key, required this.user}) : super(key: key);

  @override
  _NivelesViewState createState() => _NivelesViewState();
}

class _NivelesViewState extends State<NivelesView> {
  late Future<List<dynamic>> _nivelesFuture;

  @override
  void initState() {
    super.initState();
    _nivelesFuture = ApiService().getNiveles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Niveles Disponibles'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      drawer: DrawerMenu(
        user: User(
          id: '0',
          name: 'Cargando...',
          email: 'cargando...'),
      ), // Incluye el DrawerMenu para la navegación
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.lightBlue],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            // Encabezado estilizado
            _buildHeader(),
            Expanded(
              child: FutureBuilder<List<dynamic>>(
                future: _nivelesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error al cargar los niveles: ${snapshot.error}',
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text(
                        'No hay niveles disponibles.',
                        style: TextStyle(fontSize: 18),
                      ),
                    );
                  } else {
                    final niveles = snapshot.data!;
                    return ListView.builder(
                      itemCount: niveles.length,
                      itemBuilder: (context, index) {
                        final nivel = niveles[index];
                        return _buildNivelCard(nivel);
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Método para construir el encabezado estilizado
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Explora los Niveles',
            style: GoogleFonts.poppins(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Selecciona un nivel para comenzar tu aprendizaje.',
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  // Método para construir cada tarjeta de nivel
  Widget _buildNivelCard(Map<String, dynamic> nivel) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 5,
      child: ListTile(
        leading: const FaIcon(
          FontAwesomeIcons.bookOpen,
          color: Colors.blueAccent,
        ),
        title: Text(
          nivel['nombre'] ?? 'Sin nombre',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          nivel['descripcion'] ?? 'Sin descripción',
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
          // Aquí puedes navegar a otra vista para mostrar detalles del nivel o lecciones
          print('Seleccionaste el nivel: ${nivel['nombre']}');
        },
      ),
    );
  }
}
