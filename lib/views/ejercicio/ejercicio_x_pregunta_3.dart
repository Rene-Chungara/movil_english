import 'package:flutter/material.dart';
import 'package:flutter_english/services/api_service.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_english/controllers/ejercicio_navigator.dart';

class EjercicioXPreguntaScreen3 extends StatefulWidget {
  final String token;
  int progreso;
  final int ejercicioId;

  EjercicioXPreguntaScreen3({
    required this.token,
    required this.progreso,
    required this.ejercicioId,
  });

  @override
  State<EjercicioXPreguntaScreen3> createState() =>
      _EjercicioXPreguntaScreen3State();
}

class _EjercicioXPreguntaScreen3State extends State<EjercicioXPreguntaScreen3> {
  final SpeechToText _speechToText = SpeechToText();
  final FlutterTts _flutterTts = FlutterTts();
  final ApiService _api = ApiService();
  bool _speechEnabled = false;
  bool _isListening = false;
  bool isAnswerCorrect = false;
  String _recognizedText = "";
  double _confidenceLevel = 0.0;
  var ej;
  // La pregunta asignada directamente
  String pregunta = "";

  @override
  void initState() {
    super.initState();
    _initializeSpeech();
    _initializeTextToSpeech();
    _preguntaEjercicio();
  }

  Future<void> _preguntaEjercicio() async {
    try {
      // Espera a que la llamada a la API se resuelva
      ej = await _api.getEjercicioShow(widget.token, widget.ejercicioId);

      // Verifica si se recibió una respuesta válida
      if (ej != null && ej is Map<String, dynamic>) {
        setState(() {
          pregunta = ej['pregunta_texto']; // Accede al valor 'pregunta_texto'
          ej = ej;
        });
      } else {
        // Maneja el caso cuando no se recibe un resultado válido
        print('No se pudo obtener el ejercicio');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  // Inicializar Speech-to-Text
  void _initializeSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  // Inicializar Text-to-Speech
  void _initializeTextToSpeech() async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setPitch(1.0);
  }

  // Iniciar la escucha del Speech-to-Text
  void _startListening() async {
    if (_speechEnabled) {
      setState(() {
        _isListening = true;
        _recognizedText = "";
        isAnswerCorrect = false;
      });
      await _speechToText.listen(onResult: _onSpeechResult);
    }
  }

  // Detener la escucha del Speech-to-Text
  void _stopListening() async {
    await _speechToText.stop();
    setState(() {
      _isListening = false;
    });
  }

  // Resultado del Speech-to-Text
  void _onSpeechResult(result) {
    setState(() {
      _recognizedText = result.recognizedWords;
      _confidenceLevel = result.confidence;

      // Comparar la precisión
      double precision = _calculatePrecision(_recognizedText, pregunta);

      // Actualizar la variable isAnswerCorrect con base en la precisión
      if (precision >= 70) {
        isAnswerCorrect = true;
      } else {
        isAnswerCorrect = false;
      }
    });
  }

  // Función para calcular la precisión
  double _calculatePrecision(String recognizedText, String pregunta) {
    // Convertir ambos textos a minúsculas
    String normalizedRecognizedText = recognizedText.toLowerCase();
    String normalizedPregunta = pregunta.toLowerCase();

    // Calcular la distancia de Levenshtein
    int distance =
        _levenshteinDistance(normalizedRecognizedText, normalizedPregunta);

    // Calcular similitud
    int maxLength = normalizedRecognizedText.length > normalizedPregunta.length
        ? normalizedRecognizedText.length
        : normalizedPregunta.length;

    double similarity = (1 - (distance / maxLength)) * 100;

    return similarity;
  }

  // Función de Levenshtein para calcular la distancia entre dos cadenas
  int _levenshteinDistance(String s1, String s2) {
    int len1 = s1.length;
    int len2 = s2.length;

    List<List<int>> dp = List.generate(
        len1 + 1, (i) => List<int>.filled(len2 + 1, 0, growable: false),
        growable: false);

    for (int i = 0; i <= len1; i++) {
      for (int j = 0; j <= len2; j++) {
        if (i == 0) {
          dp[i][j] = j;
        } else if (j == 0) {
          dp[i][j] = i;
        } else if (s1[i - 1] == s2[j - 1]) {
          dp[i][j] = dp[i - 1][j - 1];
        } else {
          dp[i][j] = 1 +
              [dp[i - 1][j], dp[i][j - 1], dp[i - 1][j - 1]]
                  .reduce((a, b) => a < b ? a : b);
        }
      }
    }

    return dp[len1][len2];
  }

  // Leer la pregunta utilizando Text-to-Speech
  void _speakQuestion() async {
    await _flutterTts.speak(pregunta);
  }

  // Redirigir a la siguiente pantalla si la respuesta es correcta
  void _navigateToNextExercise() {
  if (isAnswerCorrect) {
    // Crear una instancia del navegador, pasando los parámetros necesarios
    EjercicioNavigator navegator = EjercicioNavigator(
      token: widget.token,
      leccId: ej['leccion_id'],
      progreso: widget.progreso,
      api: ApiService(),
    );
    
    // Navegar al siguiente ejercicio
    navegator.navegarAlSiguienteEjercicio(context);
  } else {
    // Mostrar mensaje de error si la respuesta es incorrecta
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Respuesta incorrecta. Intenta de nuevo.")),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ejercicio de Pronunciación",
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 20.0),
              alignment: Alignment.center,
              child: Column(
                children: [
                  Text(
                    "Pregunta:",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    pregunta,
                    style: TextStyle(fontSize: 22, fontStyle: FontStyle.italic),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: _speakQuestion,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent),
                    child: Text("Escuchar la pregunta",
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
            SizedBox(height: 50),
            ElevatedButton.icon(
              onPressed: _isListening ? _stopListening : _startListening,
              icon: Icon(_isListening ? Icons.stop : Icons.mic,
                  color: Colors.white),
              label: Text(_isListening ? "Detener" : "Escuchar",
                  style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            ),
            SizedBox(height: 20),
            Text(
              "Texto reconocido: $_recognizedText",
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            if (_recognizedText.isNotEmpty)
              Text(
                "Confianza: ${_confidenceLevel.toStringAsFixed(2)}",
                style: TextStyle(fontSize: 18),
              ),
            SizedBox(height: 10),
            if (_recognizedText.isNotEmpty)
              Text(
                "Precisión: ${_calculatePrecision(_recognizedText, pregunta).toStringAsFixed(2)}%",
                style: TextStyle(fontSize: 18),
              ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
