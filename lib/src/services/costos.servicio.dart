import 'dart:convert';
import 'package:datafire/src/services/AuthHeader.dart';
import 'package:http/http.dart' as http;

Future<List<dynamic>> fetchCosts() async {
  const url = "http://localhost:3000/Api/v1/proyectos/services";
  try {
    final res = await http.get(Uri.parse(url));
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

Future<String?> addCosto(String projectId, String amount, String description, String precio, String selecterDate) async {
  const urlCrearProyecto = "http://localhost:3000/Api/v1/proyectos/services";
  try {
    final resCrearCosto = await http.post(
      Uri.parse(urlCrearProyecto),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "project_id": projectId,
        "amount": amount,
        "service": description,
        "cost": precio,
        "fecha_costo": selecterDate
      }),
    );
    if (resCrearCosto.statusCode == 201) {
      return "Guardado exitosamente"; 
    } else {
      print("${resCrearCosto.statusCode} ${selecterDate} ");
      return null; 
    }
  } catch (err) {
    return null; 
  }
}



Future<List<dynamic>> fetchCostsByProjectId(String projectId) async {
  const url = "http://localhost:3000/Api/v1/proyectos/services";

  try {
    final res = await http.get(Uri.parse('$url?projectId=$projectId'));
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

Future<void> updateCostos(
    String id, String amount, String service, String cost) async {
  final url = "http://localhost:3000/Api/v1/proyectos/services/$id";
  Map<String, String> headers = await getAuthHeaders();
  try {
    final res = await http.patch(
      Uri.parse(url),
      headers: {"Content-Type": "application/json", ...headers},
      body: jsonEncode(
          {"amount": amount, "service": service, "cost": cost}),
    );
    if (res.statusCode == 200) {
    }
  // ignore: empty_catches
  } catch (err) {
    
  }
}



void deleteCost(int costId) async {
  final url =
      "http://localhost:3000/Api/v1/proyectos/services/$costId";
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