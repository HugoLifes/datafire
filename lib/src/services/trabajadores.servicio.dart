// cliente_network.dart
import 'dart:convert';
import 'package:datafire/src/model/workers_model.dart';
import 'package:datafire/src/services/AuthHeader.dart';
import 'package:http/http.dart' as http;

Future<List<dynamic>> fetchTrabajadores() async {
  const url = "http://localhost:3000/Api/v1/trabajadores";

  Map<String, String> headers = await getAuthHeaders();

  try {
    final res = await http.get(Uri.parse(url), headers: headers);
    if (res.statusCode == 200) {
      final List<dynamic> trabajadores = jsonDecode(res.body);
      return trabajadores;
    } else {
      return [];
    }
  } catch (err) {
    return [];
  }
}

Future<List<Trabajadores>> newFetchWorkers() async {
  const url = "http://localhost:3000/Api/v1/trabajadores";

  Map<String, String> headers = await getAuthHeaders();

  try {
    final res = await http.get(Uri.parse(url), headers: headers);
    if (res.statusCode == 200) {
      return trabajadoresFromJson(res.body);
    } else {
      return [];
    }
  } catch (err) {
    print(err);
    return [];
  }
}

Future<void> updateTrabajador(int id, String nombre, String lastName, int edad,
    String position, int salary) async {
  final url = "http://localhost:3000/api/v1/trabajadores/SalaryUpdate/$id";
  Map<String, String> headers = await getAuthHeaders();
  try {
    final res = await http.patch(
      Uri.parse(url),
      headers: {"Content-Type": "application/json", ...headers},
      body: jsonEncode({
        "name": nombre,
        "last_name": lastName,
        "age": edad,
        "position": position,
        "salary": salary,
      }),
    );

    if (res.statusCode == 200) {
      print(res.statusCode);
      print(res.body);
    } else if (res.statusCode == 404) {
    } else {
      print(res.statusCode);
      print(res.body);
    }
    // ignore: empty_catches
  } catch (err) {
    print(err);
  }
}

Future<void> deleteTrabajador(int id) async {
  final url = "http://localhost:3000/api/v1/trabajadores/$id";

  Map<String, String> headers = await getAuthHeaders();

  try {
    final res = await http.delete(
      Uri.parse(url),
      headers: {"Content-Type": "application/json", ...headers},
    );
    if (res.statusCode == 200) {
    } else {
      print(res.statusCode);
    }
    // ignore: empty_catches
  } catch (err) {}
}

Future<List<dynamic>> fetchWorkerCostsById(String projectId) async {
  const url = "http://localhost:3000/api/v1/trabajadores/WorkerCosts";

  try {
    final res = await http.get(Uri.parse('$url?projecto_id=$projectId'));
    if (res.statusCode == 200) {
      final List<dynamic> costs = jsonDecode(res.body);
      return costs;
    } else {
      return [];
    }
  } catch (err) {
    return [];
  }
}

//tools service
Future<List<dynamic>> fetchWorkerToolsById(String projectId) async {
  const url = "http://localhost:30000/Api/v1/trabajadores/tools";

  try {
    final res = await http.get(Uri.parse('$url?projecto_id=$projectId'));
    if (res.statusCode == 200) {
      final List<dynamic> costs = jsonDecode(res.body);
      return costs;
    } else {
      return [];
    }
  } catch (err) {
    return [];
  }
}

Future<void> postTools(String tool_name, String cost, String workerId,
    String fecha_adquisicion) async {
  const url = "http://localhost:3000/Api/v1/trabajadores/tools";

  Map<String, String> headers = await getAuthHeaders();

  try {
    final res = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json", ...headers},
      body: jsonEncode({
        "tool_name": tool_name,
        "cost": cost,
        "worker_id": workerId,
        "fecha_adquisicion": fecha_adquisicion
      }),
    );
    if (res.statusCode == 200) {
    } else {}
    // ignore: empty_catches
  } catch (err) {}
}

Future<void> deleteTool(int id) async {
  final url = "http://localhost:3000/Api/v1/trabajadores/tools/$id";

  Map<String, String> headers = await getAuthHeaders();

  try {
    final res = await http.delete(
      Uri.parse(url),
      headers: {"Content-Type": "application/json", ...headers},
    );
    if (res.statusCode == 200) {
    } else {}
    // ignore: empty_catches
  } catch (err) {}
}
