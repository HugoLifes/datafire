import 'dart:convert';
import 'package:datafire/src/services/AuthHeader.dart';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> fetchProjectById(String projectId) async {
  const url = "http://localhost:3000/Api/v1/proyectos";
  Map<String, String> headers = await getAuthHeaders();

  try {
    final res = await http.get(Uri.parse('$url/$projectId'), headers: headers);

    if (res.statusCode == 200) {
      final Map<String, dynamic> proyecto = jsonDecode(res.body);
      return proyecto;
    } else {
      return {};
    }
  } catch (err) {
    return {};
  }
}


Future<String?> obtenerIdProyecto(String nombre, String fechaInicio, String fechaFinalizada, String costo) async {
  const urlCrearProyecto = "http://localhost:3000/Api/v1/proyectos";

  try {
    Map<String, String> headers = await getAuthHeaders();
    final resCrearProyecto = await http.post(
      Uri.parse(urlCrearProyecto),
      headers: {"Content-Type": "application/json", ...headers},
      body: jsonEncode({
        "name": nombre,
        "fecha_inicio": fechaInicio,
        "fecha_fin": fechaFinalizada,
        "costo_inicial": costo,
      }),
    );

    if (resCrearProyecto.statusCode == 201) {
      //  buscamos su ID por el nombre
      String? projectId = await buscarIdProyectoPorNombre(nombre);

      if (projectId != null) {
        return projectId;
      } else {
        return null;
      }
    } else {
      return null;
    }
  } catch (err) {
    return null;
  }
}

Future<String?> buscarIdProyectoPorNombre(String nombre) async {
  const urlBuscarProyecto = "http://localhost:3000/Api/v1/proyectos";
      Map<String, String> headers = await getAuthHeaders();
  try {
    final resBuscarProyecto = await http.get(Uri.parse(urlBuscarProyecto), headers: headers);
    if (resBuscarProyecto.statusCode == 200) {
      final List<dynamic> proyectos = jsonDecode(resBuscarProyecto.body);
      // Buscamos el ID del proyecto por el nombre
      for (var proyecto in proyectos) {
        if (proyecto["name"] == nombre) {
          return proyecto["id"]?.toString();
        }
      }
      return null;
    } 
  } catch (err) {
    return null;
  }
  return null;
}




Future<List<dynamic>> fetchProjects() async {
  const url = "http://localhost:3000/Api/v1/proyectos";
Map<String, String> headers = await getAuthHeaders();
  try {
    final res = await http.get(Uri.parse(url), headers: headers);
    if (res.statusCode == 200) {
      final List<dynamic> proyectos = jsonDecode(res.body);
      return proyectos;
    } else {
      return []  ;
    }
  } catch (err) {
    return [];
  }
}

Future<void> updateProyecto(
    int id, String nombre, String fechaInicio, String fechaFinalizada) async {
  final url = "https://datafire-production.up.railway.app/api/v1/proyectos/$id";
 Map<String, String> headers = await getAuthHeaders();
  try {
    final res = await http.patch(
      Uri.parse(url),
      headers: {"Content-Type": "application/json", ...headers},
      body: jsonEncode({
        "name": nombre,
        "fecha_inicio": fechaInicio,
        "fecha_fin": fechaFinalizada,
      }),
    );
    if (res.statusCode == 200) {
    } else {
    }
  // ignore: empty_catches
  } catch (err) {
    
  }
}

Future<void> deleteProyecto(int id) async {
  final url = "https://datafire-production.up.railway.app/api/v1/proyectos/$id";
 Map<String, String> headers = await getAuthHeaders();
  try {
    final res = await http.delete(
      Uri.parse(url),
      headers: {"Content-Type": "application/json", ...headers},
    );
    if (res.statusCode == 200) {
    } else {
    }
  // ignore: empty_catches
  } catch (err) {
  }
}

