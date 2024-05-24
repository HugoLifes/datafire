// cliente_network.dart
import 'dart:convert';
import 'package:datafire/src/services/AuthHeader.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<List<dynamic>> fetchUsers() async {
  const url = "https://data-fire-product.up.railway.app/Api/v1/users";
  Map<String, String> headers = await getAuthHeaders();

  try {
    final res = await http.get(Uri.parse(url), headers: headers);
    if (res.statusCode == 200) {
      final List<dynamic> trabajadores = jsonDecode(res.body);
      return trabajadores;
    } else {
      return [];
    }
  } catch (err) {
    return [];
  }
}

Future<void> postUser(String name, String email, String password, String role,
    dynamic context) async {
  const url = "https://data-fire-product.up.railway.app/Api/v1/users";

  Map<String, String> headers = await getAuthHeaders();

  try {
    final res = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json", ...headers},
      body: jsonEncode(
          {"name": name, "email": email, "password": password, "role": role}),
    );
    if (res.statusCode == 200) {
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('El dato ya existe o introdujo un dato incorrecto'),
          backgroundColor: Colors.red,
        ),
      );
    }
    // ignore: empty_catches
  } catch (err) {}
}

Future<void> deleteUser(int id, dynamic context) async {
  final url = "https://data-fire-product.up.railway.app/Api/v1/users/$id";
  try {
    final res = await http.delete(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
    );
    if (res.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('El usuario se ha borrado exitosamente'),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al borrar usuario'),
          backgroundColor: Colors.red,
        ),
      );
    }
    // ignore: empty_catches
  } catch (err) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Error al establecer conexion'),
        backgroundColor: Colors.red,
      ),
    );
  }
}
