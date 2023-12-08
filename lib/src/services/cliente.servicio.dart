// cliente_network.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> postCliente(String nombre, String apellido, String company) async {
  final url = "https://datafire-production.up.railway.app/api/v1/clientes";

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
