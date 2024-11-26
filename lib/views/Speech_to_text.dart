import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';

class Speech1 extends StatefulWidget {
  const Speech1({super.key});

  @override
  State<Speech1> createState() => _Speech1State();
}

class _Speech1State extends State<Speech1> {
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  bool _isListening = false;
  String _recognizedText = "";

  @override
  void initState() {
    super.initState();
    _initializeSpeech();
  }

  void _initializeSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  void _startListening() async {
    if (_speechEnabled) {
      setState(() {
        _isListening = true;
        _recognizedText = ""; // Reiniciar texto al comenzar a escuchar
      });
      await _speechToText.listen(onResult: _onSpeechResult);
    }
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {
      _isListening = false;
    });
  }

  void _onSpeechResult(result) {
    setState(() {
      _recognizedText = result.recognizedWords;
    });

    // Llamar la función personalizada con el texto reconocido
    theFunction(_recognizedText);
  }

  void theFunction(String salidaString) {
    // Ejemplo de uso: El texto se guarda en una variable y ya está visible en pantalla
    print("Texto reconocido: $salidaString");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Speech Demo'),
        backgroundColor: Colors.red,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _isListening
                  ? "Escuchando..."
                  : _speechEnabled
                      ? "Presiona el micrófono para empezar a hablar"
                      : "Reconocimiento de voz no disponible",
              style: const TextStyle(fontSize: 18.0),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Text(
              _recognizedText.isEmpty
                  ? "Aquí aparecerá lo que digas"
                  : _recognizedText,
              style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _isListening ? _stopListening : _startListening,
        tooltip: 'Escuchar',
        backgroundColor: Colors.red,
        child: Icon(_isListening ? Icons.stop : Icons.mic),
      ),
    );
  }
}
