import 'package:flutter/material.dart';
import 'package:flutter_english/views/speech_fluter.dart';
import 'views/home_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Learning English',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeView(), // Pantalla inicial
      routes: {
        '/home': (context) => HomeView(),
        '/speech': (context) =>
            const SpeechFlutter(), // Otra vista que quieras añadir
        // Puedes añadir más rutas aquí
      },
    );
  }
}
