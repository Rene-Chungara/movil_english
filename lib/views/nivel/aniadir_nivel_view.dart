import 'package:flutter/material.dart';
import 'package:flutter_english/services/api_service.dart';

class AniadirNivelScreen extends StatefulWidget {
  final String token; // Recibir el token como parámetro

  AniadirNivelScreen({required this.token});

  @override
  _AniadirNivelScreenState createState() => _AniadirNivelScreenState();
}

class _AniadirNivelScreenState extends State<AniadirNivelScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();

  late final ApiService apiService;

  @override
  void initState() {
    super.initState();
    apiService = ApiService(); // Instanciamos el ApiService
  }

  Future<void> _guardarNivel() async {
    if (_formKey.currentState!.validate()) {
      final nombre = _nombreController.text;
      final descripcion = _descripcionController.text;
      final token = widget.token; // Obtener el token

      // Llamamos al método de ApiService
      final success = await apiService.guardarNivel(nombre, descripcion, token);

      if (success) {
        // Si el nivel se guarda con éxito, regresamos a la lista con 'true'
        Navigator.pop(context, true);
      } else {
        // Mostrar un error si algo falla
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar el nivel')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Añadir Nivel'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: InputDecoration(labelText: 'Nombre del Nivel'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingrese un nombre';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descripcionController,
                decoration: InputDecoration(labelText: 'Descripción'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingrese una descripción';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _guardarNivel,
                child: Text('Guardar Nivel'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
