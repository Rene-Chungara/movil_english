import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechToTextView extends StatefulWidget {
  @override
  _SpeechToTextViewState createState() => _SpeechToTextViewState();
}

class _SpeechToTextViewState extends State<SpeechToTextView> {
  // Instancia de SpeechToText
  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false; // Indicador si el reconocimiento está habilitado
  String _lastWords = ''; // Últimas palabras reconocidas

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  // Inicializa el reconocimiento de voz
  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {}); // Actualiza el estado después de la inicialización
  }

  // Inicia la escucha del reconocimiento de voz
  void _startListening() async {
    await _speechToText.listen(onResult: (result) {
      setState(() {
        _lastWords = result.recognizedWords; // Actualiza las palabras reconocidas
      });
    });
    setState(() {});
  }

  // Detiene la escucha del reconocimiento de voz
  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Speech to Text Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(16),
              child: Text(
                'Recognized words:',
                style: TextStyle(fontSize: 20.0),
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(16),
                child: Text(
                  // Si se está escuchando, muestra las palabras reconocidas
                  _speechToText.isListening
                      ? '$_lastWords'
                      // Si no se está escuchando pero el reconocimiento está disponible, muestra mensaje
                      : _speechEnabled
                          ? 'Tap the microphone to start listening...'
                          : 'Speech not available',
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _speechToText.isNotListening ? _startListening : _stopListening,
        tooltip: 'Listen',
        child: Icon(_speechToText.isNotListening ? Icons.mic_off : Icons.mic),
      ),
    );
  }
}
