// cliente_network.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> postProyecto(String nombre, String fecha_inicio, String,
    String fecha_fin, String costo) async {
  final url = "https://datafire-production.up.railway.app/api/v1/proyectos";

  try {
    final res = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": nombre,
        "fecha_inicio": fecha_fin,
        "fecha_fin": fecha_fin,
        "costo": costo
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

Future<void> updateProyecto(
    int id, String nombre, String fechaInicio, String fechaFinalizada) async {
  final url = "https://datafire-production.up.railway.app/api/v1/proyectos/$id";

  try {
    final res = await http.put(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": nombre,
        "fecha_inicio": fechaInicio,
        "fecha_fin": fechaFinalizada
      }),
    );
    if (res.statusCode == 200) {
      print("Proyecto actualizado exitosamente");
    } else {
      print("Error al actualizar el proyecto");
    }
  } catch (err) {
    print("Error al realizar la solicitud http: $err");
  }
}

Future<void> deleteProyecto(int id) async {
  final url = "https://datafire-production.up.railway.app/api/v1/proyectos/$id";

  try {
    final res = await http.delete(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
    );
    if (res.statusCode == 200) {
      print("Proyecto eliminado exitosamente");
    } else {
      print("Error al eliminar el proyecto");
    }
  } catch (err) {
    print("Error al realizar la solicitud http: $err");
  }
}
