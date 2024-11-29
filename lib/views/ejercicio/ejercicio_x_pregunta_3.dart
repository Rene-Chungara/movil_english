import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_english/others/imports.dart';

class EjercicioXPreguntaScreen3 extends StatefulWidget {
  final String token;
  final int progreso;
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
  EjercicioNavigator? navigator;

  bool _speechEnabled = false;
  bool _isListening = false;
  String _recognizedText = "";
  String pregunta = "";
  int leccion_id = 0;
  double _confidenceLevel = 0.0;

  @override
  void initState() {
    super.initState();
    _initializeSpeechToText();
    _initializeTextToSpeech();
    _fetchPregunta();
  }

  Future<void> _fetchPregunta() async {
    try {
      var response =
          await _api.getEjercicioShow(widget.token, widget.ejercicioId);
      setState(() {
        pregunta = response['pregunta_texto'] ?? "Pregunta no disponible.";
        leccion_id = response['leccion_id'] ?? "id no disponible.";
      });
    } catch (e) {
      print("Error al obtener la pregunta: $e");
    }
  }

  void _initializeSpeechToText() async {
    _speechEnabled = await _speechToText.initialize();
  }

  void _initializeTextToSpeech() async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setPitch(1.0);
    await _flutterTts.setSpeechRate(0.5);
  }

  void _startListening() async {
    if (_speechEnabled) {
      setState(() => _isListening = true);
      await _speechToText.listen(onResult: (result) {
        setState(() {
          _recognizedText = result.recognizedWords;
          _confidenceLevel = result.confidence;
        });
      });
    }
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() => _isListening = false);
  }

  void _speakQuestion() async {
    try {
      // Detener cualquier reproducción en curso antes de iniciar una nueva
      await _flutterTts.stop();

      if (pregunta.isNotEmpty) {
        // Verifica que el idioma esté configurado correctamente
        await _flutterTts.setLanguage(
            "es-ES"); // Cambia a "es-ES" si la pregunta está en español
        await _flutterTts.setPitch(1.0);
        await _flutterTts.setSpeechRate(0.5);

        // Iniciar la síntesis de texto a voz
        await _flutterTts.speak(pregunta);
      } else {
        print("No hay pregunta para reproducir.");
      }
    } catch (e) {
      print("Error al intentar reproducir la pregunta: $e");
    }
  }

  void _navigateToNextExercise() {
    if (_confidenceLevel >= 0.7) {
      // Si la precisión es del 70% o más
      double similarity = _calculateSimilarity(
        _recognizedText.toLowerCase().trim(),
        pregunta.toLowerCase().trim(),
      );

      if (similarity >= 0.65) {
        // Acepta respuestas con un 70% de similitud
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  "¡Correcto! La respuesta está dentro del margen permitido.")),
        );
        // EjercicioNavigator(
        //   token: widget.token,
        //   leccId: 1,
        //   progreso: widget.progreso,
        //   api: _api,
        // ).navegarAlSiguienteEjercicio(context);
      } else {
        // Si la precisión es alta pero la similitud no alcanza el 70%
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Respuesta incorrecta. Intenta nuevamente.")),
        );
      }
    } else {
      // Si la precisión es menor al 70%
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              "Confianza insuficiente en la respuesta. Intenta hablar más claro."),
        ),
      );
    }
  }

  double _calculateSimilarity(String text1, String text2) {
    int distance = _levenshteinDistance(text1, text2);
    int maxLength = text1.length > text2.length ? text1.length : text2.length;

    if (maxLength == 0)
      return 1.0; // Si ambas cadenas están vacías, son idénticas.

    return 1.0 - (distance / maxLength);
  }

  int _levenshteinDistance(String s, String t) {
    int m = s.length;
    int n = t.length;
    List<List<int>> dp = List.generate(m + 1, (_) => List.filled(n + 1, 0));

    for (int i = 0; i <= m; i++) {
      for (int j = 0; j <= n; j++) {
        if (i == 0) {
          dp[i][j] = j;
        } else if (j == 0) {
          dp[i][j] = i;
        } else if (s[i - 1] == t[j - 1]) {
          dp[i][j] = dp[i - 1][j - 1];
        } else {
          dp[i][j] = 1 +
              [dp[i - 1][j], dp[i][j - 1], dp[i - 1][j - 1]]
                  .reduce((a, b) => a < b ? a : b);
        }
      }
    }

    return dp[m][n];
  }

  void _goToInstancedClass() {
    navigator = EjercicioNavigator(
        token: widget.token,
        leccId: leccion_id,
        progreso: widget.progreso,
        api: ApiService());

    if (navigator != null) {
      navigator!.navegarAlSiguienteEjercicio(context);
    } else {
      // Manejo del caso cuando navigator es null
      print("El objeto navigator no está inicializado.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ejercicio de Pronunciación"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Pregunta:", style: TextStyle(fontSize: 24)),
            Text(
              pregunta,
              style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
              textAlign: TextAlign.center,
            ),
            ElevatedButton(
              onPressed: _speakQuestion,
              child: Text("Escuchar Pregunta"),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _isListening ? _stopListening : _startListening,
              icon: Icon(_isListening ? Icons.stop : Icons.mic),
              label: Text(_isListening ? "Detener" : "Escuchar"),
            ),
            SizedBox(height: 20),
            Text(
              "Texto reconocido: $_recognizedText",
              style: TextStyle(fontSize: 16),
            ),
            ElevatedButton(
              onPressed: _navigateToNextExercise,
              child: Text("Verificar Respuesta"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _goToInstancedClass,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: Text("Ir a Otra Clase"),
            ),
          ],
        ),
      ),
    );
  }
}
