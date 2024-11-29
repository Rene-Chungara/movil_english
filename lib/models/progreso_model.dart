import 'package:flutter/material.dart';

class ProgresoModel extends ChangeNotifier {
  int _progreso = 3;  // Valor inicial del progreso

  int get progreso => _progreso;

  void reducirProgreso() {
    if (_progreso > 0) {
      _progreso--;
      notifyListeners();  // Notifica a los widgets que dependen de este valor
    }
  }
}
