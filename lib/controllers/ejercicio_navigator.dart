import 'package:flutter_english/others/imports.dart';
import 'dart:math'; // Asegúrate de importar esta librería para usar Random

class EjercicioNavigator {
  late final String token;
  int leccId;
  int progreso; // El progreso está aquí, y es manejado desde el exterior

  late ApiService
      _api; // Asegúrate de que el _api sea inicializado correctamente
  late List<dynamic> ejercicios = [];
  int cantEjercicio = 0;

  EjercicioNavigator({
    required this.token,
    required this.leccId,
    required this.progreso,
    required ApiService api, // Pasamos ApiService como parámetro
  }) {
    _api = api; // Inicializamos _api
  }

  // Método para actualizar el ejercicio actual según el progreso
  void _actualizarEjercicio() {
    if (ejercicios.isEmpty) {
      print("La lista de ejercicios está vacía.");
      return;
    }

    if (progreso < 0 || progreso > ejercicios.length) {
      print("Progreso fuera de rango: $progreso");
      return;
    }

    // Aquí asignamos el ejercicio actual a la variable 'ejercicio' si es necesario
    var ejercicio = ejercicios[progreso];
    print("Ejercicio actualizado, el id es: ${ejercicio['id']}");
  }

  // Función para obtener los ejercicios de la lección
  Future<void> _fetchEjercicios() async {
    print("leccion : ${leccId}");
    try {
      final data = await _api.getEjerciciosXLeccion(token, leccId);

      ejercicios = data;
      print("ejercicios ${ejercicios}");
      print("Ejercicios cargados: ${ejercicios.length}");
      cantEjercicio = ejercicios.length;

      // Llamamos a la función que actualiza el ejercicio solo si hay ejercicios
      if (ejercicios.isNotEmpty) {
        _actualizarEjercicio();
      } else {
        print("No hay ejercicios disponibles");
      }
    } catch (e) {
      print("Error al obtener los ejercicios: $e");
    }
  }

  // Función para navegar al siguiente ejercicio según el progreso
  Future<void> navegarAlSiguienteEjercicio(BuildContext context) async {
    // Asegúrate de que los ejercicios estén cargados antes de navegar
    await _fetchEjercicios(); // Aseguramos que los ejercicios se hayan cargado antes de proceder
    print("longitud de los ejercicios: ${ejercicios.length}");

    if (ejercicios.isEmpty) {
      print("No se han cargado los ejercicios.");
      return;
    }
    // Generar un valor aleatorio entre 1 y 3
    Random random = Random();
    int tipoVista = random.nextInt(3) + 1; // Esto generará 1, 2 o 3

    // Asegúrate de que el progreso no exceda el límite de los ejercicios
    if (progreso < ejercicios.length) {
      // Incrementamos el progreso
      progreso++;
      tipoVista = 3;
    } else {
      progreso = 0;
      tipoVista = 0;
      print("No hay más ejercicios");
      return;
    }
    print("progreso = ${progreso}");

    // Usamos un switch para manejar qué vista cargar dependiendo del tipo de ejercicio
    switch (3) {
      // Aquí se puede modificar dependiendo de tu lógica de "tipoVista"
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EjercicioXPreguntaScreen3(
              token: token,
              progreso: progreso,
              ejercicioId: ejercicios[progreso - 1]['id'],
            ),
          ),
        );
      case 2: //caso 2 no está terminado
        print("caso 2");
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EjercicioXPreguntaScreen2(
              token: token,
              progreso: progreso,
              ejercicioId: ejercicios[progreso - 1]['id'],
            ),
          ),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EjercicioXPreguntaScreen(
              token: token,
              progreso: progreso,
              ejercicio_id: ejercicios[progreso - 1]['id'],
            ),
          ),
        );
        break;
      default:
        print("aqui me dirije a la ultima Vista donde ira a la pregunta con Ia si el caso tien un fallo crea el ejercicio IA");
        break;
    }
  }
}
