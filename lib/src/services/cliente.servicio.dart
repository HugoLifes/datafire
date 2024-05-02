// cliente_network.dart
import 'dart:convert';
import 'package:datafire/src/services/AuthHeader.dart';
import 'package:http/http.dart' as http;

Future<void> postCliente(String nombre, String apellido, String company) async {
  const url = "http://localhost:3000/api/v1/clientes";

  try {
    final res = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(
          {"name": nombre, "last_name": apellido, "company": company}),
    );
    if (res.statusCode == 200) {
    } else {}
    // ignore: empty_catches
  } catch (err) {}
}

Future<List<dynamic>> fetchClientes() async {
  const url = "http://localhost:3000/Api/v1/clientes";
  Map<String, String> headers = await getAuthHeaders();

  try {
    final res = await http.get(Uri.parse(url), headers: headers);
    if (res.statusCode == 200) {
      final List<dynamic> clientes = jsonDecode(res.body);
      return clientes;
    } else {
      return [];
    }
  } catch (err) {
    return [];
  }
}

Future<void> updateCliente(
    int id, String nombre, String lastName, String company) async {
  final url = "http://localhost:3000/api/v1/clientes/$id";
  try {
    final res = await http.patch(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(
          {"name": nombre, "last_name": lastName, "company": company}),
    );
    if (res.statusCode == 200) {}
    // ignore: empty_catches
  } catch (err) {}
}

Future<void> deleteCliente(int id) async {
  final url = "http://localhost:3000/api/v1/clientes/$id";
  try {
    final res = await http.delete(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
    );
    if (res.statusCode == 200) {
    } else {}
    // ignore: empty_catches
  } catch (err) {}
}
