import 'package:datafire/src/model/flujo_caja_model.dart';
import 'package:http/http.dart' as http;

Future<List<FlujoCaja>> fetchFlujoData() async {
  final response =
      await http.get(Uri.parse('http://localhost:3000/Api/v1/proyectos/flujo'));

  if (response.statusCode == 200) {
    return flujoCajaFromJson(response.body);
  } else {
    throw Exception('Error al cargar datos de Ingresos');
  }
}
