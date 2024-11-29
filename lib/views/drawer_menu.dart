import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_english/models/user_model.dart';
import 'home_view.dart';
import 'lecciones/leccion_view.dart';
import 'nivel/niveles_view.dart';  // Importamos la vista de LeccionesView

class DrawerMenu extends StatelessWidget {
  final User user;

  const DrawerMenu({super.key, required this.user});  // Pasar usuario como parámetro

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.lightBlue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            _buildDrawerHeader(context),
            _buildDrawerItem(context, FontAwesomeIcons.home, 'Inicio', () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeView(), // Reemplaza con tu clase HomeView
                ),
                    (Route<dynamic> route) => false, // Elimina todas las vistas anteriores en la pila
              );
            }),
            _buildDrawerItem(context, FontAwesomeIcons.bookOpen, 'Niveles', () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NivelesView(
                    user: User(
                      id: '0',
                      name: 'Cargando...',
                      email: 'cargando...'),
                  ),
                ),
              );
            }),

            _buildDrawerItem(context, FontAwesomeIcons.listAlt, 'Vocabulario', () {
              // Acción para Vocabulario
              Navigator.pop(context);
            }),
            _buildDrawerItem(context, FontAwesomeIcons.puzzlePiece, 'Exámenes', () {
              // Acción para Exámenes
              Navigator.pop(context);
            }),
            const Divider(),
            _buildDrawerItem(context, FontAwesomeIcons.cog, 'Configuración', () {
              // Acción para Configuración
              Navigator.pop(context);
            }),
          ],
        ),
      ),
    );
  }

  // encabezado
  Widget _buildDrawerHeader(BuildContext context) {
    return DrawerHeader(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.blue, Colors.blueAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        image: DecorationImage(
          image: AssetImage('assets/background.jpg'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(Colors.blue.withOpacity(0.2), BlendMode.dstATop),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: AssetImage('assets/user_avatar.png'),
          ),
          const SizedBox(height: 10),
          Text(
            user.name,
            style: GoogleFonts.poppins(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            user.email,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  // Método para construir elementos del Drawer con animación
  Widget _buildDrawerItem(BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: FaIcon(icon, color: Colors.white),
      title: Text(
        title,
        style: GoogleFonts.poppins(color: Colors.white, fontSize: 16),
      ),
      onTap: onTap,
      hoverColor: Colors.blueAccent.withOpacity(0.2),
      tileColor: Colors.transparent,
      splashColor: Colors.white54,
    );
  }
}
