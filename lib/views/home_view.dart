import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_english/controllers/home_controllers.dart';
import 'package:flutter_english/models/user_model.dart';
import 'package:flutter_english/views/drawer_menu.dart';

import 'package:flutter_english/views/Speech_to_text.dart';
import 'package:flutter_english/views/home_page.dart';
import '../views/leccion_screen.dart';

class HomeView extends StatelessWidget {
  final HomeController controller = HomeController();

  HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.blueAccent.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: const [
              Icon(Icons.school,
                  color: Colors.blueAccent), // Icono para la app de aprendizaje
              SizedBox(width: 8),
              Text(
                '¡Bienvenido de nuevo!',
                style: TextStyle(
                    color: Colors.blueAccent,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.blueAccent),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.blueAccent),
            onPressed: () {
              // Acción para notificaciones
            },
          ),
        ],
      ),
      drawer: FutureBuilder<User>(
        future: controller.fetchUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            return DrawerMenu(
                user: snapshot.data!); // Pasar usuario al DrawerMenu
          } else {
            return DrawerMenu(
              // Eliminar 'const' aquí
              user: User(
                  id: '0',
                  name: 'Cargando...',
                  email: 'cargando...'), // Placeholder
            );
          }
        },
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.lightBlue],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder<User>(
            future: controller.fetchUser(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.hasData) {
                User user = snapshot.data!;
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Saludo al usuario
                      Text(
                        'Hola, ${user.name}!',
                        style: GoogleFonts.poppins(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '¡Continúa aprendiendo inglés con tus lecciones personalizadas!',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Barra de progreso de aprendizaje con animación
                      const Text(
                        'Progreso del Curso',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      const SizedBox(height: 10),
                      TweenAnimationBuilder<double>(
                        tween: Tween<double>(begin: 0, end: 0.6),
                        duration: const Duration(seconds: 2),
                        builder: (context, value, _) => LinearProgressIndicator(
                          value: value,
                          backgroundColor: Colors.white.withOpacity(0.3),
                          color: Colors.white,
                          minHeight: 8,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Sección de lecciones recomendadas con diseño atractivo
                      const Text(
                        'Lecciones Recomendadas',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      const SizedBox(height: 10),
                      _buildLessonCard(
                          'Vocabulario Básico',
                          'Aprende las palabras esenciales',
                          'assets/ingles.png'),
                      _buildLessonCard(
                          'Gramática Avanzada',
                          'Domina la estructura del idioma',
                          'assets/grammar.jpg'),
                      const SizedBox(height: 30),

                      // Botones de acción rápida con diseño amigable
                      const Text(
                        'Explora Más',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildActionButton(
                              FontAwesomeIcons.bookOpen, 'Mis Lecciones'),
                          _buildActionButton(
                              FontAwesomeIcons.listAlt, 'Vocabulario'),
                          _buildActionButton(
                              FontAwesomeIcons.puzzlePiece, 'Exámenes'),
                        ],
                      ),

                      // Llamada a la acción para continuar la lección con diseño llamativo
                      const SizedBox(height: 30),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            // Navegar a la próxima lección
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orangeAccent,
                            //onPrimary: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 15),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            elevation: 5,
                          ),
                          child: const Text('Continuar Lección',
                              style: TextStyle(fontSize: 18)),
                        ),
                      ),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LeccionScreen()));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orangeAccent,
                            // onPrimary: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 15),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            elevation: 5,
                          ),
                          child: const Text('audio a texto',
                              style: TextStyle(fontSize: 18)),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return const Center(child: Text('No hay datos del usuario'));
              }
            },
          ),
        ),
      ),
    );
  }

  // Método para construir una tarjeta de lección con diseño atractivo
  Widget _buildLessonCard(String title, String description, String imagePath) {
    return Card(
      elevation: 6,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.blue.shade100],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(10),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(imagePath,
                width: 50, height: 50, fit: BoxFit.cover),
          ),
          title: Text(title,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.black)),
          subtitle:
              Text(description, style: const TextStyle(color: Colors.black54)),
          trailing: const Icon(Icons.arrow_forward, color: Colors.blueAccent),
          onTap: () {
            // Acción al tocar la tarjeta
          },
        ),
      ),
    );
  }

  // Método para construir botones de acción rápida con diseño amigable
  Widget _buildActionButton(IconData icon, String label) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            // Acción rápida
          },
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(20),
            backgroundColor: Colors.white,
            // onPrimary: Colors.blueAccent,
            elevation: 5,
          ),
          child: FaIcon(icon,
              color: Colors.blueAccent,
              size: 30), // Usamos FaIcon para FontAwesome
        ),
        const SizedBox(height: 5),
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.white)),
      ],
    );
  }
}
