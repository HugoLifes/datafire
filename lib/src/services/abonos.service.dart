// cliente_network.dart
import 'dart:convert';
import 'package:datafire/src/services/AuthHeader.dart';
import 'package:http/http.dart' as http;

Future<void> postAbono(String monto, String fechaAbono, String projectId, int customerId) async {
  const url = "https://datafire-production.up.railway.app/api/v1/proyectos/abonos";

Map<String, String> headers = await getAuthHeaders();

  try {
    final res = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json", ...headers},
      body: jsonEncode(
          {"monto": monto, "fecha_abono": fechaAbono, "projectId": projectId,"customerId": customerId}),
    );
    if (res.statusCode == 200) {
      print("Abono Guardado Exitosamente");
    } else {
      print("Error al guardar el Abono ${res.statusCode}");
    }
  } catch (err) {
    print("Error al realizar la solicitud http: $err");
  }
}

Future<List<dynamic>> fetchAbonos() async {
  const url = "https://datafire-production.up.railway.app/api/v1/proyectos/abonos";

  try {
    final res = await http.get(Uri.parse(url));
    if (res.statusCode == 200) {
      final List<dynamic> abonos = jsonDecode(res.body);
      return abonos; 
    } else {
      print("Error al obtener la lista de abonos");
      return [];
    }
  } catch (err) {
    print("Error al realizar la solicitud http: $err");
    return [];
  }
}

Future<List<dynamic>> fetchAbonosById(String projectId) async {
  const url = "https://datafire-production.up.railway.app/api/v1/proyectos/abonos";

  try {
    final res = await http.get(Uri.parse('$url?projecto_id=$projectId'));
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


Future<void> updateAbono(
    int id, String monto, String fechaAbono, String projectId, String customerId) async {
  final url = "https://datafire-production.up.railway.app/api/v1/proyectos/abonos/$id";
  Map<String, String> headers = await getAuthHeaders();
  try {
    final res = await http.patch(
      Uri.parse(url),
      headers: {"Content-Type": "application/json", ...headers},
      body: jsonEncode(
          {"monto": monto, "fecha_abono": fechaAbono, "projectId": projectId, "customerId": customerId}),
    );
    if (res.statusCode == 200) {
      print("abono actualizado exitosamente");
    }
  } catch (err) {
    print("Error al realizar la solicitud http: $err");
  }
}

Future<void> deleteAbono(int id) async {
  final url = "https://datafire-production.up.railway.app/api/v1/proyectos/abonos/$id";
  Map<String, String> headers = await getAuthHeaders();
  try {
    final res = await http.delete(
      Uri.parse(url),
      headers: {"Content-Type": "application/json", ...headers},
    );
    if (res.statusCode == 200) {
      print("Abono eliminado exitosamente");
    } else {
      print("Error al eliminar el Abono ${res.statusCode}");
    }
  } catch (err) {
    print("Error al realizar la solicitud http: $err");
  }
}
