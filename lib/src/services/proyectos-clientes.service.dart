import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<dynamic>> fetchCustomerProjects() async {
  const url = "https://datafire-production.up.railway.app/api/v1/proyectos/projectCustomer";

  try {
    final res = await http.get(Uri.parse(url));
    if (res.statusCode == 200) {
      final List<dynamic> customersProjects = jsonDecode(res.body);
      return customersProjects;
    } else {
      print("Error al obtener la lista de proyectos");
      return [];
    }
  } catch (err) {
    print("Error al realizar la solicitud http: $err");
    return [];
  }
}

Future<List<String>> fetchCustomerProjectsforcustomers() async {
  const url = "https://datafire-production.up.railway.app/api/v1/proyectos/projectCustomer";

  try {
    final res = await http.get(Uri.parse(url));
    if (res.statusCode == 200) {
      final List<String> customersProjects = jsonDecode(res.body);
      return customersProjects;
    } else {
      print("Error al obtener la lista de proyectos");
      return [];
    }
  } catch (err) {
    print("Error al realizar la solicitud http: $err");
    return [];
  }
}

class PostCustomerProject {
  Future<bool> addCustomerProject(String projectId, String customerId) async {
    final Map<String, dynamic> requestData = {
      "project_id": projectId,
      "customer_id": customerId,
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
        return true; // Indicar que la operación fue exitosa
      } else {
        print("Error al agregar el cliente: ${res.statusCode}");
        print("Respuesta del servidor: ${res.body}");
        return false; // Indicar que hubo un error en la operación
      }
    } catch (err) {
      print("Error al realizar la solicitud http: $err");
      return false; // Indicar que hubo un error en la solicitud HTTP
    }
  }
}


Future<bool> deleteCustomerProjectRelation(int customerProjectId) async {
  final url =
      "https://datafire-production.up.railway.app/api/v1/proyectos/projectCustomer/$customerProjectId";

  try {
    final res = await http.delete(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
    );

    if (res.statusCode == 200) {
      print("Relación eliminada exitosamente");
      return true; // Indicar que la eliminación fue exitosa
    } else {
      print("Error al eliminar la relación");
      return false; // Indicar que hubo un error en la eliminación
    }
  } catch (err) {
    print("Error al realizar la solicitud http: $err");
    return false; 
  }
}


Future<List<Map<String, dynamic>>> fetchCustomerProjectsbyId(int customerId) async {
  const url = "https://datafire-production.up.railway.app/api/v1/proyectos/projectCustomer";

  try {
    final res = await http.get(Uri.parse(url));
    if (res.statusCode == 200) {
      final List<Map<String, dynamic>> allProjects = List<Map<String, dynamic>>.from(jsonDecode(res.body));

      final List<Map<String, dynamic>> customerProjects = allProjects
          .where((project) => project['customer_id'] == customerId)
          .toList();

      return customerProjects;
    } else {
      print("Error al obtener la lista de proyectos");
      return [];
    }
  } catch (err) {
    print("Error al realizar la solicitud http: $err");
    return [];
  }
}