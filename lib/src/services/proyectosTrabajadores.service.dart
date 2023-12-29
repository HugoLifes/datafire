import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<dynamic>> fetchProjectWorkers() async {
  const url = "https://datafire-production.up.railway.app/api/v1/proyectos/projectWorker";

  try {
    final res = await http.get(Uri.parse(url));
    if (res.statusCode == 200) {
      final List<dynamic> projectWorkers = jsonDecode(res.body);
      return projectWorkers;
    } else {
      print("Error al obtener la lista de proyectos");
      return [];
    }
  } catch (err) {
    print("Error al realizar la solicitud http: $err");
    return [];
  }
}

class postProjectWorker {
  Future<void> addProjectWorker(String projectId, String workerId) async {
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

Future<List<Map<String, dynamic>>> fetchProjectWorkersbyId(int workerId) async {
  const url = "https://datafire-production.up.railway.app/api/v1/proyectos/projectWorker";

  try {
    final res = await http.get(Uri.parse(url));
    if (res.statusCode == 200) {
      final List<Map<String, dynamic>> allProjects = List<Map<String, dynamic>>.from(jsonDecode(res.body));

      // Filter projects based on customer_id
      final List<Map<String, dynamic>> workerProjects = allProjects
          .where((project) => project['worker_id'] == workerId)
          .toList();

      return workerProjects;
    } else {
      print("Error al obtener la lista de proyectos");
      return [];
    }
  } catch (err) {
    print("Error al realizar la solicitud http: $err");
    return [];
  }
}

void deleteProjectWorkers(int projectWorkersId) async {
  final url =
      "https://datafire-production.up.railway.app/api/v1/proyectos/projectWorker/$projectWorkersId";

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