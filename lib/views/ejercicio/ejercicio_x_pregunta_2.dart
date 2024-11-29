import 'package:flutter_english/others/imports.dart';


class EjercicioXPreguntaScreen2 extends StatefulWidget {
  final String token;
  final int progreso;
  final int ejercicioId;

  // Constructor
  EjercicioXPreguntaScreen2({
    required this.token,
    required this.progreso,
    required this.ejercicioId,
  });

  @override
  _EjercicioXPreguntaScreen2State createState() =>
      _EjercicioXPreguntaScreen2State();
}

class _EjercicioXPreguntaScreen2State extends State<EjercicioXPreguntaScreen2> {
  late ApiService apiService;
  late Future<dynamic> ejercicio;

  @override
  void initState() {
    super.initState();
    apiService = ApiService();
    ejercicio = apiService.getEjercicioShow(widget.token, widget.ejercicioId);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Progreso: ${widget.progreso}/10", // Utilizar la variable 'progreso'
          style: GoogleFonts.roboto(fontSize: screenWidth * 0.05),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent.withOpacity(0.1),
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.05, vertical: screenHeight * 0.02),
        child: FutureBuilder<dynamic>(
          future: ejercicio,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            }

            if (!snapshot.hasData) {
              return Center(child: Text("No data found"));
            }

            var ejercicioData = snapshot.data;
            String pregunta = ejercicioData['pregunta_texto']; // Asumiendo que 'pregunta_texto' es la clave

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Mostrar la pregunta del ejercicio
                Text(
                  pregunta,
                  style: GoogleFonts.roboto(
                    fontSize: screenWidth * 0.045,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                Spacer(), // Espaciador para mover elementos hacia abajo

                // Input y botón de avance
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Input de texto
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Escribe aquí tu respuesta",
                          hintStyle: GoogleFonts.roboto(
                            color: Colors.grey,
                            fontSize: screenWidth * 0.04,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.blueAccent),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                                color: Colors.blueAccent, width: 1.5),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            vertical: screenHeight * 0.015,
                            horizontal: screenWidth * 0.04,
                          ),
                        ),
                        style: GoogleFonts.roboto(
                          fontSize: screenWidth * 0.045,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.03),
                    // Botón de avance
                    ElevatedButton(
                      onPressed: () {
                        // Acción del botón
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Respuesta enviada"),
                              content: Text(
                                  "Gracias por tu respuesta. Procede al siguiente paso."),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: Text("Cerrar"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: screenHeight * 0.02,
                          horizontal: screenWidth * 0.04,
                        ),
                      ),
                      child: Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                        size: screenWidth * 0.06,
                      ),
                    ),
                  ],
                ),
                Spacer(), // Espaciador adicional

                // Texto motivacional o de ayuda
                Text(
                  "¡Escribe tu respuesta y presiona avanzar para continuar!",
                  style: GoogleFonts.roboto(
                    fontSize: screenWidth * 0.04,
                    color: Colors.blueAccent,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
