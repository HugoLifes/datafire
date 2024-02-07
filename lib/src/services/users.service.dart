// cliente_network.dart
import 'dart:convert';
import 'package:datafire/src/services/AuthHeader.dart';
import 'package:http/http.dart' as http;

Future<List<dynamic>> fetchUsers() async {
  const url = "https://datafire-production.up.railway.app/Api/v1/users";
Map<String, String> headers = await getAuthHeaders();

  try {
    final res = await http.get(Uri.parse(url), headers: headers);
    if (res.statusCode == 200) {
      final List<dynamic> trabajadores = jsonDecode(res.body);
      return trabajadores;
    } else {
      print("Error al obtener la lista de proyectos");
      return [];
    }
  } catch (err) {
    print("Error al realizar la solicitud http: $err");
    return [];
  }
}

Future<void> postUser(String name, String email, String password, String role) async {
  const url = "https://datafire-production.up.railway.app/Api/v1/users";

Map<String, String> headers = await getAuthHeaders();

  try {
    final res = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json", ...headers},
      body: jsonEncode(
          {"name": name, "email": email, "password": password,"role": role}),
    );
    if (res.statusCode == 200) {
      print("Usuario Guardado Exitosamente");
    } else {
      print("Error al guardar el Abono ${res.statusCode}");
    }
  } catch (err) {
    print("Error al realizar la solicitud http: $err");
  }
}

Future<void> deleteUser(int id) async {
  final url =
      "https://datafire-production.up.railway.app/Api/v1/users/$id";
  try {
    final res = await http.delete(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
    );
    if (res.statusCode == 200) {
      print("Usuario eliminado exitosamente");
    } else {
      print("Error al eliminar el Usuario");
    }
  } catch (err) {
    print("Error al realizar la solicitud http: $err");
  }
}
