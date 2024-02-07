// cliente_network.dart
import 'dart:convert';
import 'package:datafire/src/services/AuthHeader.dart';
import 'package:http/http.dart' as http;

Future<void> postCliente(String nombre, String apellido, String company) async {
  const url = "https://datafire-production.up.railway.app/api/v1/clientes";

  try {
    final res = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(
          {"name": nombre, "last_name": apellido, "company": company}),
    );
    if (res.statusCode == 200) {
      print("Cliente Guardado Exitosamente");
    } else {
      print("Error al guardar el cliente");
    }
  } catch (err) {
    print("Error al realizar la solicitud http: $err");
  }
}

Future<List<dynamic>> fetchClientes() async {
  const url = "https://datafire-production.up.railway.app/api/v1/clientes";
Map<String, String> headers = await getAuthHeaders();

  try {
    final res = await http.get(Uri.parse(url), headers: headers);
    if (res.statusCode == 200) {
      final List<dynamic> clientes = jsonDecode(res.body);
      return clientes; // Asegúrate de manejar el caso de nulo
    } else {
      print("Error al obtener la lista de clientes");
      return [];
    }
  } catch (err) {
    print("Error al realizar la solicitud http: $err");
    return [];
  }
}


Future<void> updateCliente(
    int id, String nombre, String lastName, String company) async {
  final url = "https://datafire-production.up.railway.app/api/v1/clientes/$id";
  try {
    final res = await http.patch(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(
          {"name": nombre, "last_name": lastName, "company": company}),
    );
    if (res.statusCode == 200) {
      print("cliente actualizado exitosamente");
    }
  } catch (err) {
    print("Error al realizar la solicitud http: $err");
  }
}

Future<void> deleteCliente(int id) async {
  final url = "https://datafire-production.up.railway.app/api/v1/clientes/$id";
  try {
    final res = await http.delete(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
    );
    if (res.statusCode == 200) {
      print("Cliente eliminado exitosamente");
    } else {
      print("Error al eliminar el Cliente");
    }
  } catch (err) {
    print("Error al realizar la solicitud http: $err");
  }
}
