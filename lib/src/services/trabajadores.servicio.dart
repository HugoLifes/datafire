// cliente_network.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


Future<List<dynamic>> fetchTrabajadores() async {
  const url = "https://datafire-production.up.railway.app/api/v1/trabajadores";

  try {
    // Obtener el token almacenado en SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      print("Token no encontrado en SharedPreferences");
      return [];
    }

    // Configurar el encabezado de autorización con el token
    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
    };

    // Realizar la solicitud HTTP con el encabezado de autorización
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

Future<void> updateTrabajador(
  int id, String nombre, String last_name, int edad, String position, int salary) async {
  final url = "https://datafire-production.up.railway.app/api/v1/trabajadores/$id";

  try {
    final res = await http.patch(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": nombre,
        "last_name": last_name,
        "age": edad, 
        "position": position,
        "salary": salary,
      }),
    );

    if (res.statusCode == 200) {
      print("Trabajador actualizado exitosamente");
    } else if (res.statusCode == 404) {
      print("Error: Trabajador no encontrado. Status code: 404");
    } else {
      print("Error al actualizar el trabajador. Status code: ${res.statusCode}");
      print("Response body: ${res.body}");
    }
  } catch (err) {
    print("Error al realizar la solicitud http: $err");
  }
}




Future<void> deleteTrabajador(int id) async {
  final url =
      "https://datafire-production.up.railway.app/api/v1/trabajadores/$id";
  try {
    final res = await http.delete(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
    );
    if (res.statusCode == 200) {
      print("Trabajador eliminado exitosamente");
    } else {
      print("Error al eliminar el Cliente");
    }
  } catch (err) {
    print("Error al realizar la solicitud http: $err");
  }
}
