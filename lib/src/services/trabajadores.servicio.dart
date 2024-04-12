// cliente_network.dart
import 'dart:convert';
import 'package:datafire/src/services/AuthHeader.dart';
import 'package:http/http.dart' as http;

Future<List<dynamic>> fetchTrabajadores() async {
  const url = "https://datafire-production.up.railway.app/Api/v1/trabajadores";

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

Future<void> updateTrabajador(int id, String nombre, String lastName, int edad,
    String position, int salary) async {
  final url =
      "https://datafire-production.up.railway.app/api/v1/trabajadores/SalaryUpdate/$id";
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
  final url =
      "https://datafire-production.up.railway.app/api/v1/trabajadores/$id";

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

Future<List<dynamic>> fetchWorkerCostsById(String projectId) async {
  const url =
      "https://datafire-production.up.railway.app/api/v1/trabajadores/WorkerCosts";

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
