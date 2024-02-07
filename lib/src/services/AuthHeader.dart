import 'package:shared_preferences/shared_preferences.dart';

Future<Map<String, String>> getAuthHeaders() async {
  // Obtener el token almacenado en SharedPreferences
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');

  if (token == null) {
    print("Token no encontrado en SharedPreferences");
    return {};
  }

  // Configurar el encabezado de autorización con el token
  return {'Authorization': 'Bearer $token'};
}

