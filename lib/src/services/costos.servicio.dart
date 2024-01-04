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
  Future<void> addCost(String projectId, String workerId) async {
    final Map<String, dynamic> requestData = {
      "project_id": projectId,
      "worker_id": workerId,
    };

    print("Data enviada a addCustomerProject: $requestData");

    const url = "https://datafire-production.up.railway.app/api/v1/proyectos/projectWorker";

    try {
      final res = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestData),
      );

      if (res.statusCode == 201) {
        print("Cliente agregado exitosamente");
      } else {
        print("Error al agregar el cliente: ${res.statusCode}");
        print("Respuesta del servidor: ${res.body}");
      }
    } catch (err) {
      print("Error al realizar la solicitud http: $err");
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