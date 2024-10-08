import 'package:datafire/src/model/nominas_semanales.dart';
import 'package:http/http.dart' as http;

Future<List<NominasSemanales>> loadNominas() async {
  final url = Uri.parse(
      'https://data-fire-product.up.railway.app/Api/v1/nominasSemanales/weeklyNominas');
  final response = await http.get(url);
  if (response.statusCode == 200) {
    return nominasSemanalesFromJson(response.body);
  } else if (response.statusCode == 405) {
    throw Exception('No hay nominas disponibles');
  } else {
    throw Exception('Failed to load nominas');
  }
}
