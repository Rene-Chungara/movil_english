import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_english/others/imports.dart';

class EjercicioXPreguntaScreen extends StatefulWidget {
  final String token;
  int progreso;
  final int ejercicio_id;
  EjercicioXPreguntaScreen(
      {required this.token,
      required this.progreso,
      required this.ejercicio_id});

  @override
  _EjercicioXPreguntaScreenState createState() =>
      _EjercicioXPreguntaScreenState();
}

class _EjercicioXPreguntaScreenState extends State<EjercicioXPreguntaScreen> {
  late final ApiService _api;

  String titulo = "";
  String contenido = "Aquí el contenido del ejercicio.";
  List<String> opciones = [];
  Map<String, String> contextoBotones = {};
  var ejercicio;
  String textoSeleccionado = "";

  late EjercicioNavigator ejercicioNavigator;

  @override
  void initState() {
    super.initState();
    _api = ApiService();
    _llenarOpciones();
  }

  void _llenarOpciones() async {
    try {
      dynamic ejercicio1 =
          await _api.getEjercicioShow(widget.token, widget.ejercicio_id);
      print("Ejercicio: $ejercicio1");

      if (ejercicio1 != null &&
          ejercicio1['opciones'] != null &&
          ejercicio1['opciones'] is List &&
          ejercicio1['opciones'].isNotEmpty) {
        setState(() {
          ejercicio = ejercicio1;
          opciones = ejercicio1['opciones'][0].split(',');
        });
        print("Opciones: $opciones");
      } else {
        setState(() {
          opciones = [];
        });
        print("No se encontró una lista válida en 'opciones'");
      }

      contextoBotones = {};
      for (var opcion in opciones) {
        contextoBotones[opcion] = "Texto relacionado con $opcion";
      }

      // Obtener el contenido dinámicamente
      setState(() {
        contenido = ejercicio1['pregunta_texto'] ?? "Contenido no disponible";
      });
    } catch (e) {
      print("Error al obtener las opciones: $e");
      setState(() {
        opciones = [];
      });
    }
  }

  // Función para manejar la selección de una opción
  void _manejarSeleccion(
      String opcionSeleccionada, BuildContext context) async {
    setState(() {
      textoSeleccionado = contextoBotones[opcionSeleccionada] ?? "";
    });

    // Obtener la opción correcta desde la API
    try {
      //String opcionCorrecta = await _api.getSubmit(widget.token, opcionSeleccionada);
      String opcionCorrecta = "vacio";
      // Verificar si la opción seleccionada es la correcta
      if (opcionSeleccionada == opcionCorrecta) {
        print("¡La opción seleccionada es correcta!");

        // Crear un objeto EjercicioNavigator y navegar al siguiente ejercicio
        ejercicioNavigator = EjercicioNavigator(
          token: widget.token,
          leccId:
              widget.ejercicio_id, // Suponiendo que leccId es el ejercicio_id
          progreso: widget.progreso,
          api: ApiService(),
        );

        // Navegar al siguiente ejercicio
        ejercicioNavigator.navegarAlSiguienteEjercicio(context);
      } else {
        print("Opción incorrecta. Intenta nuevamente.");
      }
    } catch (e) {
      print("Error al obtener la respuesta correcta: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Modificar el título para que incluya el progreso
    titulo = "Progreso: ${widget.progreso} / 10";

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
            Spacer(),
            Stack(
              children: [
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
                                  vertical: screenHeight * 0.0075,
                                  horizontal: screenWidth * 0.02,
                                ),
                                backgroundColor:
                                    Colors.blueAccent.withOpacity(0.1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () {
                                _manejarSeleccion(opcion, context);
                                ejercicioNavigator
                                    .navegarAlSiguienteEjercicio(context);
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
                            if (textoSeleccionado == contextoBotones[opcion])
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
            Spacer(),
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
