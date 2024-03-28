import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<dynamic>> fetchProjectWorkers() async {
  const url = "https://datafire-production.up.railway.app/Api/v1/proyectos/projectWorker";

  try {
    final res = await http.get(Uri.parse(url));
    if (res.statusCode == 200) {
      final List<dynamic> projectWorkers = jsonDecode(res.body);
      return projectWorkers;
    } else {
      return [];
    }
  } catch (err) {
    return [];
  }
}

class postProjectWorker {
  Future<void> addProjectWorker(String projectId, String workerId) async {
    final Map<String, dynamic> requestData = {
      "project_id": projectId,
      "worker_id": workerId,
    };

    const url = "https://datafire-production.up.railway.app/Api/v1/proyectos/projectWorker";

    try {
      final res = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestData),
      );

      if (res.statusCode == 201) {
      } else {
      }
    // ignore: empty_catches
    } catch (err) {
    }
  }
}

Future<List<Map<String, dynamic>>> fetchProjectWorkersbyId(int workerId) async {
  const url = "https://datafire-production.up.railway.app/Api/v1/proyectos/projectWorker";

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
      return [];
    }
  } catch (err) {
    return [];
  }
}

Future<bool> deleteProjectWorkers(int projectWorkersId) async {
  final url = "https://datafire-production.up.railway.app/Api/v1/proyectos/projectWorker/$projectWorkersId";

  try {
    final response = await http.delete(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  } catch (error) {
    return false;
  }
}