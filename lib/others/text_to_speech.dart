import 'package:flutter_tts/flutter_tts.dart';

class TextToSpeechService {
  // Instancia del FlutterTTS
  FlutterTts _flutterTts = FlutterTts();

  // Inicialización de TTS
  TextToSpeechService() {
    _flutterTts.setLanguage('en-US'); // Establecer el idioma a español
    _flutterTts.setSpeechRate(0.5); // Velocidad de la voz (0.0 a 1.0)
    _flutterTts.setVolume(1.0); // Volumen (0.0 a 1.0)
    _flutterTts.setPitch(1.0); // Tono de la voz (0.5 a 2.0)
  }

  // Función para pronunciar el texto
  Future<void> speak(String text) async {
    try {
      await _flutterTts.speak(text);
      print("SI esta saliendo audio");
    } catch (e) {
      print('Error al usar TTS: $e');
    }
  }

  // Función para detener el habla
  Future<void> stop() async {
    await _flutterTts.stop();
  }

  // Función para comprobar si TTS está habilitado
  Future<bool> isAvailable() async {
    //return await _flutterTts.isLanguageAvailable('es-ES');
    return await _flutterTts.isLanguageAvailable('en-US');
  }
}
