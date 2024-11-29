import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../views/nivel/aniadir_nivel_view.dart';

class NivelesScreen extends StatefulWidget {
  final String token;

  NivelesScreen({required this.token});

  @override
  _NivelesScreenState createState() => _NivelesScreenState();
}

class _NivelesScreenState extends State<NivelesScreen> {
  final ApiService _apiService = ApiService();
  List<dynamic> niveles = [];

  @override
  void initState() {
    super.initState();
    //_fetchNiveles();
  }
/*
  // Método para obtener los niveles desde la API
  void _fetchNiveles() async {
    final data = await _apiService.getNiveles(widget.token);
    setState(() {
      niveles = data;
    });
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Niveles')),
      body: niveles.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: niveles.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Nivel: ${niveles[index]['nombre']}'),
                  subtitle:
                      Text('Descripción: ${niveles[index]['descripcion']}'),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Esperar la respuesta de la pantalla de añadir nivel
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  AniadirNivelScreen(token: widget.token),
            ),
          );

          // Si la respuesta es true, significa que el nivel se guardó
          if (result == true) {
            // Actualizar la lista de niveles
            //_fetchNiveles();
          }
        },
        child: Icon(Icons.add),
        tooltip: 'Añadir Nivel',
      ),
    );
  }
}

