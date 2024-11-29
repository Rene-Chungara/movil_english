import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class DataBaseHelper {
  String serverUrl = "http://18.191.150.96/api";
  String serverUrlleccion = "http://18.191.150.96/api/leccion";

  var status;

  var token;

  loginData(String email, String password) async {
    String myUrl = "$serverUrl/login";
    final response = await http.post(
      Uri.parse(myUrl), // Usa Uri.parse para convertir el string a URI
      headers: {'Accept': 'application/json'},
      body: {
        "email": email,
        "password": password
      }, // No necesitas interpolación en los valores
    );
    status = response.body.contains('error');
    var data = json.decode(response.body);
    if (status) {
      print('data : ${data["error"]}');
    } else {
      print('data : ${data["token"]}');
      _save(data["token"]);
    }
  }

  void addDataNivel(String _nombre, String _descripcion) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;

    String myUrl = "$serverUrl/nivel";
    final response = await http.post(
      Uri.parse(myUrl), // Usa Uri.parse para convertir el string a URI
      headers: {'Accept': 'application/json'},
      body: {
        "nombre": _nombre,
        "descripcion": _descripcion
      }, // No necesitas interpolación en los valores
    );
    status = response.body.contains('error');
    status = response.body.contains('error');
    var data = json.decode(response.body);
    if (status) {
      print('data : ${data["error"]}');
    } else {
      print('data : ${data["token"]}');
      _save(data["token"]);
    }
  }

  void editarData(String id, String name, String price, String stock) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;
    String myUrl =
        "$serverUrl/nivel/$id"; // Incluye el `id` si es necesario en la URL
    await http.put(
      Uri.parse(myUrl), // Usa Uri.parse para convertir el String en Uri
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $value',
      },
      body: {
        "name": name, // No necesitas interpolación con "$variable"
        "price": price,
        "stock": stock,
      },
    ).then((response) {
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
    });
  }

  Future<List> getData() async {
  final prefs = await SharedPreferences.getInstance();
  final key = 'token';
  final value = prefs.get(key) ?? 0;

  String myUrl = "$serverUrlleccion";
  http.Response response = await http.get(
    Uri.parse(myUrl), // Usa Uri.parse para convertir el String en Uri
    headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $value',
    },
  );
  return json.decode(response.body);
}


  _save(String token) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = token;
    prefs.setString(key, value);
  }

  read() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;
    print('read : $value');
  }
}
