// cliente_network.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> postCliente(
    String nombre, String fecha_inicio, String, String fecha_fin) async {
  final url = "https://datafire-production.up.railway.app/api/v1/proyectos";

  try {
    final res = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(
          {"name": nombre, "fecha_inicio": fecha_fin, "fecha_fin": fecha_fin}),
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

Future<List<dynamic>> fetchProjects() async {
  const url = "https://datafire-production.up.railway.app/api/v1/proyectos";

  try {
    final res = await http.get(Uri.parse(url));
    if (res.statusCode == 200) {
      final List<dynamic> proyectos = jsonDecode(res.body);
      return proyectos;
    } else {
      print("Error al obtener la lista de proyectos");
      return [];
    }
  } catch (err) {
    print("Error al realizar la solicitud http: $err");
    return [];
  }
}
