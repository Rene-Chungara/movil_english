import 'package:flutter/material.dart';
import 'package:flutter_english/controllers/home_controllers.dart';
import 'package:flutter_english/models/user_model.dart';

class HomeView extends StatelessWidget {
  final HomeController controller = HomeController();

  HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        title: const Text(
          'Bienvenido de nuevo!',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              // Navegar a la configuración del perfil
            },
          ),
        ],
      ),
      body: Padding(
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
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      '¡Continúa aprendiendo inglés con tus lecciones personalizadas!',
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                    const SizedBox(height: 30),

                    // Barra de progreso de aprendizaje
                    const Text(
                      'Progreso del Curso',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    LinearProgressIndicator(
                      value: 0.6, // Simula el progreso del usuario
                      backgroundColor: Colors.grey[300],
                      color: Colors.blueAccent,
                      minHeight: 8,
                    ),
                    const SizedBox(height: 20),

                    // Sección de lecciones recomendadas
                    const Text(
                      'Lecciones Recomendadas',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    _buildLessonCard('Vocabulario Básico', 'Aprende las palabras esenciales', 'assets/lesson1.png'),
                    _buildLessonCard('Gramática Avanzada', 'Domina la estructura del idioma', 'assets/lesson2.png'),
                    const SizedBox(height: 30),

                    // Botones de acción rápida
                    const Text(
                      'Explora Más',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildActionButton(Icons.book, 'Mis Lecciones'),
                        _buildActionButton(Icons.list_alt, 'Vocabulario'),
                        _buildActionButton(Icons.quiz, 'Exámenes'),
                      ],
                    ),

                    // Llamada a la acción para continuar la lección
                    const SizedBox(height: 30),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          // Navegar a la próxima lección
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blueAccent,
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        child: const Text('Continuar Lección'),
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
    );
  }

  // Método para construir una tarjeta de lección
  Widget _buildLessonCard(String title, String description, String imagePath) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: Image.asset(imagePath, width: 50, height: 50, fit: BoxFit.cover),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(description),
        trailing: const Icon(Icons.arrow_forward, color: Colors.blueAccent),
        onTap: () {
          // Acción al tocar la tarjeta
        },
      ),
    );
  }

  // Método para construir botones de acción rápida
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
            primary: Colors.blueAccent,
          ),
          child: Icon(icon, color: Colors.white, size: 30),
        ),
        const SizedBox(height: 5),
        Text(label, style: const TextStyle(fontSize: 14)),
      ],
    );
  }
}