import 'dart:convert';
import 'package:http/http.dart' as http;

class postCustomerWorker {
  Future<void> addProjectCustomer(String projectId, String customerId) async {
    final Map<String, dynamic> requestData = {
      "project_id": projectId,
      "worker_id": customerId,
    };

    print("Data enviada a addCustomerProject: $requestData");

    const url = "https://datafire-production.up.railway.app/api/v1/proyectos/projectCustomer";

    try {
      final res = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestData),
      );

      if (res.statusCode == 201) {
        print("Cliente agregado exitosamente");
      } else {
        print("Error al agregar el cliente: ${res.statusCode}");
        print("Respuesta del servidor: ${res.body}");
      }
    } catch (err) {
      print("Error al realizar la solicitud http: $err");
    }
  }
}