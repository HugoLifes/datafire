// cliente_network.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> postTrabajador(String nombre, String last_name, String age,
    String position, String salary) async {
  final url = "https://datafire-production.up.railway.app/api/v1/trabajadores";

  try {
    final res = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": nombre,
        "last_name": last_name,
        "age": age,
        "position": position,
        "salary": salary
      }),
    );
    if (res.statusCode == 200) {
      print("Cliente Guardado Exitosamente");
    } else {
      print("Error al guardar el cliente");
    }
  } catch (err) {
    print("Error al realizar la solicitud http: $err");
  }
}

Future<List<dynamic>> fetchTrabajadores() async {
  const url = "https://datafire-production.up.railway.app/api/v1/trabajadores";

  try {
    final res = await http.get(Uri.parse(url));
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
