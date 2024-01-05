import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<dynamic>> fetchCosts() async {
  const url = "https://datafire-production.up.railway.app/api/v1/proyectos/services";

  try {
    final res = await http.get(Uri.parse(url));
    if (res.statusCode == 200) {
      final List<dynamic> costs = jsonDecode(res.body);
      return costs;
    } else {
      print("Error al obtener la lista de costos");
      return [];
    }
  } catch (err) {
    print("Error al realizar la solicitud http: $err");
    return [];
  }
}

class postCosts {
Future<String?> addCosto(String projectId, String amount, String description, String precio) async {
  const urlCrearProyecto = "https://datafire-production.up.railway.app/api/v1/proyectos/services";

  try {
    final resCrearCosto = await http.post(
      Uri.parse(urlCrearProyecto),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "project_id": projectId,
        "amount": amount,
        "service": description,
        "cost": precio,
      }),
    );
  
    if (resCrearCosto.statusCode == 201) {
      print("Guardado exxitosamente");
    }
  } catch (err) {
    print("Error al realizar la solicitud http para crear proyecto: $err");
    return null;
  }
}
}

Future<List<dynamic>> fetchCostsByProjectId(String projectId) async {
  const url = "https://datafire-production.up.railway.app/api/v1/proyectos/services";

  try {
    final res = await http.get(Uri.parse('$url?projectId=$projectId'));
    if (res.statusCode == 200) {
      final List<dynamic> costs = jsonDecode(res.body);
      return costs;
    } else {
      print("Error al obtener la lista de costos");
      return [];
    }
  } catch (err) {
    print("Error al realizar la solicitud http: $err");
    return [];
  }
}

Future<void> updateCostos(
    String id, String amount, String service, String cost) async {
  final url = "https://datafire-production.up.railway.app/api/v1/proyectos/services/$id";
  try {
    final res = await http.patch(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(
          {"amount": amount, "service": service, "cost": cost}),
    );
    if (res.statusCode == 200) {
      print("cliente actualizado exitosamente");
    }
  } catch (err) {
    print("Error al realizar la solicitud http: $err");
  }
}



void deleteCost(int costId) async {
  final url =
      "https://datafire-production.up.railway.app/api/v1/proyectos/services/$costId";

  try {
    final res = await http.delete(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
    );
    if (res.statusCode == 200) {
      print("Relación eliminada exitosamente");
    } else {
      print("Error al eliminar la relación");
    }
  } catch (err) {
    print("Error al realizar la solicitud http: $err");
  }
}