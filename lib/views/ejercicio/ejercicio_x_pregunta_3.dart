import 'package:flutter/material.dart';
import 'package:flutter_english/others/text_to_speech.dart'; // Importa tu servicio de TTS

class EjercicioXPreguntaScreen3 extends StatelessWidget {
  // Instancia del servicio TTS
  final TextToSpeechService _textToSpeechService = TextToSpeechService();

  // Texto a pronunciar
  final String texto = "How do you say 'Hello' in English?";

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Progreso: 2/10",
          style: TextStyle(fontSize: screenWidth * 0.05),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent.withOpacity(0.1),
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.05, vertical: screenHeight * 0.02),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Texto a mostrar
              Expanded(
                child: Text(
                  texto,
                  style: TextStyle(
                    fontSize: screenWidth * 0.045,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(width: screenWidth * 0.05),
              // Botón de escuchar
              ElevatedButton(
                onPressed: () {
                  _textToSpeechService.speak(texto);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: CircleBorder(),
                  padding: EdgeInsets.all(screenWidth * 0.04),
                ),
                child: Icon(
                  Icons.volume_up,
                  color: Colors.white,
                  size: screenWidth * 0.06,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
