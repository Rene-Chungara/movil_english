import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EjercicioXPreguntaScreen extends StatefulWidget {
  @override
  _EjercicioXPreguntaScreenState createState() =>
      _EjercicioXPreguntaScreenState();
}

class _EjercicioXPreguntaScreenState extends State<EjercicioXPreguntaScreen> {
  String titulo = "Progreso: 1/10";
  String contenido = "Aquí el contenido del ejercicio.";
  List<String> opciones = ["Opción 1", "Opción 2", "Opción 3", "Opción 4"];
  Map<String, String> contextoBotones = {
    "Opción 1": "Este es el contexto de la Opción 1.",
    "Opción 2": "Este es el contexto de la Opción 2.",
    "Opción 3": "Este es el contexto de la Opción 3.",
    "Opción 4": "Este es el contexto de la Opción 4.",
  };

  String textoSeleccionado = "";

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          titulo,
          style: GoogleFonts.roboto(fontSize: screenWidth * 0.05),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent.withOpacity(0.1),
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              contenido,
              style: GoogleFonts.roboto(
                fontSize: screenWidth * 0.045,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            Spacer(), // Espacio antes de los botones
            Stack(
              children: [
                // Fondo con gradientes en los extremos
                Positioned.fill(
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.white,
                                Colors.white.withOpacity(0.5),
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.white.withOpacity(0.5),
                                Colors.white,
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Contenedor de botones desplazables
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: opciones.map((opcion) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.02),
                        child: Column(
                          children: [
                            TextButton(
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                  vertical: screenHeight * 0.0075, // Botón más pequeño
                                  horizontal: screenWidth * 0.02,
                                ),
                                backgroundColor:
                                    Colors.blueAccent.withOpacity(0.1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  textoSeleccionado =
                                      contextoBotones[opcion] ?? "";
                                });
                              },
                              child: Text(
                                opcion,
                                style: GoogleFonts.roboto(
                                  fontSize: screenWidth * 0.03,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.blueAccent,
                                ),
                              ),
                            ),
                            // Texto condicional debajo de cada botón
                            if (textoSeleccionado ==
                                contextoBotones[opcion])
                              Padding(
                                padding:
                                    EdgeInsets.only(top: screenHeight * 0.01),
                                child: Text(
                                  textoSeleccionado,
                                  style: GoogleFonts.roboto(
                                    fontSize: screenWidth * 0.035,
                                    color: Colors.black54,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            Spacer(), // Espacio después de los botones
            Text(
              "¡Sigue así, estás progresando!",
              style: GoogleFonts.roboto(
                fontSize: screenWidth * 0.04,
                fontStyle: FontStyle.italic,
                color: Colors.blueAccent,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
