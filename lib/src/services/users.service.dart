// cliente_network.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

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