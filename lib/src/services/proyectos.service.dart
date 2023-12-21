// cliente_network.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
Future<String?> postProyecto(String nombre, String fechaInicio, String fechaFinalizada, String costo) async {
  const url = "https://datafire-production.up.railway.app/api/v1/proyectos";

  try {
    final res = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": nombre,
        "fecha_inicio": fechaInicio,
        "fecha_fin": fechaFinalizada,
        "costo": costo,
      }),
    );

    if (res.statusCode == 200) {
      print("Proyecto dado de alta exitosamente");
      final Map<String, dynamic> responseData = jsonDecode(res.body);
      return responseData['id'].toString(); // Devuelve el ID del proyecto
    } else {
      print("Error al guardar el proyecto");
      return null;
    }
  } catch (err) {
    print("Error al realizar la solicitud http: $err");
    return null;
  }
}

class postCustomerProject {
  Future<void> addCustomerProject(String projectId, String customerId) async {
    final Map<String, dynamic> requestData = {
      "project_id": projectId,
      "customer_id": customerId,
    };

    print("Data enviada a addCustomerProject: $requestData");

    const url = "https://datafire-production.up.railway.app/api/v1/proyectos/add-customer";

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
        // Puedes manejar el error de acuerdo a tus necesidades
      }
    } catch (err) {
      print("Error al realizar la solicitud http: $err");
      // Puedes manejar el error de acuerdo a tus necesidades
    }
  }
}


Future<List<dynamic>> fetchProjects() async {
  const url = "https://datafire-production.up.railway.app/api/v1/proyectos";

  try {
    final res = await http.get(Uri.parse(url));
    if (res.statusCode == 200) {
      final List<dynamic> proyectos = jsonDecode(res.body);
      return proyectos;
    } else {
      print("Error al obtener la lista de proyectos");
      return [];
    }
  } catch (err) {
    print("Error al realizar la solicitud http: $err");
    return [];
  }
}

Future<void> updateProyecto(
    int id, String nombre, String fechaInicio, String fechaFinalizada) async {
  final url = "https://datafire-production.up.railway.app/api/v1/proyectos/$id";

  try {
    final res = await http.put(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": nombre,
        "fecha_inicio": fechaInicio,
        "fecha_fin": fechaFinalizada
      }),
    );
    if (res.statusCode == 200) {
      print("Proyecto actualizado exitosamente");
    } else {
      print("Error al actualizar el proyecto");
    }
  } catch (err) {
    print("Error al realizar la solicitud http: $err");
  }
}

Future<void> deleteProyecto(int id) async {
  final url = "https://datafire-production.up.railway.app/api/v1/proyectos/$id";

  try {
    final res = await http.delete(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
    );
    if (res.statusCode == 200) {
      print("Proyecto eliminado exitosamente");
    } else {
      print("Error al eliminar el proyecto");
    }
  } catch (err) {
    print("Error al realizar la solicitud http: $err");
  }
}
