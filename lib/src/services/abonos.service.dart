// cliente_network.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> postAbono(String monto, String fecha_abono, String projectId, int customerId) async {
  final url = "https://datafire-production.up.railway.app/api/v1/proyectos/abonos";

  try {
    final res = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(
          {"monto": monto, "fecha_abono": fecha_abono, "projectId": projectId,"customerId": customerId}),
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
      return abonos ?? []; // Asegúrate de manejar el caso de nulo
    } else {
      print("Error al obtener la lista de abonos");
      return [];
    }
  } catch (err) {
    print("Error al realizar la solicitud http: $err");
    return [];
  }
}


Future<void> updateAbono(
    int id, String monto, String fecha_abono, String projectId, String customerId) async {
  final url = "https://datafire-production.up.railway.app/api/v1/proyectos/abonos/$id";
  try {
    final res = await http.patch(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(
          {"monto": monto, "fecha_abono": fecha_abono, "projectId": projectId, "customerId": customerId}),
    );
    if (res.statusCode == 200) {
      print("abono actualizado exitosamente");
    }
  } catch (err) {
    print("Error al realizar la solicitud http: $err");
  }
}

Future<void> deleteCliente(int id) async {
  final url = "https://datafire-production.up.railway.app/api/v1/proyectos/abonos/$id";
  try {
    final res = await http.delete(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
    );
    if (res.statusCode == 200) {
      print("Abono eliminado exitosamente");
    } else {
      print("Error al eliminar el Abono");
    }
  } catch (err) {
    print("Error al realizar la solicitud http: $err");
  }
}
