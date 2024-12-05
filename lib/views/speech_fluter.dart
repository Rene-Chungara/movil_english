import 'dart:async'; // Importa dart:async para usar Timer
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechFlutter extends StatefulWidget {
  const SpeechFlutter({super.key});

  @override
  State<SpeechFlutter> createState() => _SpeechFlutterState();
}

class _SpeechFlutterState extends State<SpeechFlutter> {
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  bool _isListening = false;
  String _wordsSpoken = "";
  double _confidenceLevel = 0; // Timer para manejar el tiempo de escucha

  // Texto estático que el usuario debe repetir
  final String _staticText =
      "Last weekend, I went to the beach with my family. The weather was perfect, with clear skies and a gentle breeze. We arrived early in the morning to find a good spot. My brother and I built a sandcastle while my parents relaxed under an umbrella. Around noon, we had a picnic with sandwiches, fruit, and cold drinks. After lunch, we played volleyball and swam in the sea. The water was refreshing, and we had a lot of fun splashing around. In the afternoon, we took a walk along the shore, collecting seashells and taking pictures. As the sun began to set, we packed up our things and headed home, tired but happy. It was a wonderful day, and I can’t wait to go back to the beach again";

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  Future<void> _initSpeech() async {
    _speechEnabled = await _speechToText.initialize(
      onStatus: (status) => _onSpeechStatus(status),
      onError: (error) => _onSpeechError(error),
    );
    setState(() {});
  }

  void _onSpeechStatus(String status) {
    setState(() {
      _isListening = _speechToText.isListening;
    });
  }

  void _onSpeechError(SpeechRecognitionError error) {
    setState(() {
      _isListening = false;
    });
  }

  void _startListening() async {
    if (_speechEnabled && !_isListening) {
      await _speechToText.listen(onResult: _onSpeechResult);
      setState(() {
        _wordsSpoken = "";
        _confidenceLevel = 0;
      });
    }
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _wordsSpoken = result.recognizedWords;
      _confidenceLevel = result.confidence;
    });
  }

  void _stopListening() async {
    if (_isListening) {
      await _speechToText.stop();
      setState(() {
        _isListening = false;
      });
    }
  }

  // Método para comparar las palabras habladas con el texto estático
  List<TextSpan> _compareWords() {
    List<String> staticWords = _staticText.split(' ');
    List<String> spokenWords = _wordsSpoken.split(' ');

    List<TextSpan> textSpans = [];
    for (int i = 0; i < staticWords.length; i++) {
      if (i < spokenWords.length &&
          staticWords[i].toLowerCase() == spokenWords[i].toLowerCase()) {
        textSpans.add(TextSpan(
          text: '${staticWords[i]} ',
          style: const TextStyle(color: Color.fromARGB(255, 43, 207, 2)),
        ));
      } else {
        textSpans.add(TextSpan(
          text: '${staticWords[i]} ',
          style: const TextStyle(color: Colors.red),
        ));
      }
    }
    return textSpans;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: _buildAppBar(screenWidth),
      body: _buildBody(screenWidth),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  AppBar _buildAppBar(double screenWidth) {
    return AppBar(
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
          children: [
            const Icon(Icons.school, color: Colors.blueAccent),
            const SizedBox(width: 4),
            Text(
              '¡Practica tu speech!',
              style: TextStyle(
                color: Colors.blueAccent,
                fontSize: screenWidth * 0.05,
                fontWeight: FontWeight.bold,
              ),
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
    );
  }

  Widget _buildBody(double screenWidth) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Lesson 1',
              style: TextStyle(
                color: Colors.blueAccent,
                fontSize: screenWidth * 0.08,
                fontWeight: FontWeight.bold,
              ),
            ),
            Card(
              elevation: 5,
              shadowColor: Colors.blueAccent.withOpacity(0.3),
              margin: const EdgeInsets.symmetric(vertical: 16.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  _staticText,
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: screenWidth * 0.05,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              _isListening
                  ? 'Listening...'
                  : _speechEnabled
                      ? 'Tap the microphone to start speaking'
                      : 'Speech not available',
              style: TextStyle(
                color: Colors.blueAccent,
                fontSize: screenWidth * 0.045,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            // Mostrar resultados solo cuando se detiene la escucha
            if (!_isListening && _wordsSpoken.isNotEmpty)
              Text('You said:',
                  style: TextStyle(
                    color: Colors.blueAccent,
                    fontSize: screenWidth * 0.045,
                    fontWeight: FontWeight.bold,
                  )),
            if (!_isListening && _wordsSpoken.isNotEmpty)
              Container(
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: Colors.blueAccent.withOpacity(0.1),
                    ),
                  ),
                  child: Text(_wordsSpoken)),
            if (!_isListening && _wordsSpoken.isNotEmpty)
              Text('Your Result:',
                  style: TextStyle(
                    color: Colors.blueAccent,
                    fontSize: screenWidth * 0.045,
                    fontWeight: FontWeight.bold,
                  )),
            if (!_isListening && _wordsSpoken.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.blueAccent.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: Colors.blueAccent.withOpacity(0.1),
                  ),
                ),
                child: RichText(
                  text: TextSpan(
                    children: _compareWords(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            if (!_isListening && _wordsSpoken.isNotEmpty)
              Text(
                'Confidence: ${_confidenceLevel.toStringAsFixed(2)}',
                style: TextStyle(
                  color: Colors.blueAccent,
                  fontSize: screenWidth * 0.045,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ),
    );
  }

  FloatingActionButton _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: _isListening ? _stopListening : _startListening,
      tooltip: 'Listen',
      backgroundColor: Colors.blueAccent,
      child: Icon(
        _isListening ? Icons.stop : Icons.mic,
        color: Colors.white,
      ),
    );
  }
}
