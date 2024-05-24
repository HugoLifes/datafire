import 'package:datafire/src/model/prestamos_model.dart';
import 'package:http/http.dart' as http;

Future<List<Prestamos>> loadprestamos() async {
  final url = Uri.parse(
      'https://data-fire-product.up.railway.app/Api/v1/nominasSemanales/weeklyNominas');
  final response = await http.get(url);
  if (response.statusCode == 200) {
    return prestamosFromJson(response.body);
  } else {
    throw Exception('Failed to load nominas');
  }
}
