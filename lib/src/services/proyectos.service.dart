// cliente_network.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
Future<String?> obtenerIdProyecto(String nombre, String fechaInicio, String fechaFinalizada, String costo) async {
  const urlCrearProyecto = "https://datafire-production.up.railway.app/api/v1/proyectos";

  try {
    final resCrearProyecto = await http.post(
      Uri.parse(urlCrearProyecto),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": nombre,
        "fecha_inicio": fechaInicio,
        "fecha_fin": fechaFinalizada,
        "costo": costo,
      }),
    );

    if (resCrearProyecto.statusCode == 201) {
      //  buscamos su ID por el nombre
      String? projectId = await buscarIdProyectoPorNombre(nombre);

      if (projectId != null) {
        return projectId;
      } else {
        print('Error al obtener el ID del proyecto por nombre');
        return null;
      }
    } else {
      print("Error al guardar el proyecto - Código: ${resCrearProyecto.statusCode}");
      print("Respuesta del servidor: ${resCrearProyecto.body}");
      return null;
    }
  } catch (err) {
    print("Error al realizar la solicitud http para crear proyecto: $err");
    return null;
  }
}

Future<String?> buscarIdProyectoPorNombre(String nombre) async {
  const urlBuscarProyecto = "https://datafire-production.up.railway.app/api/v1/proyectos";

  try {
    final resBuscarProyecto = await http.get(Uri.parse(urlBuscarProyecto));
    if (resBuscarProyecto.statusCode == 200) {
      final List<dynamic> proyectos = jsonDecode(resBuscarProyecto.body);
      // Buscamos el ID del proyecto por el nombre
      for (var proyecto in proyectos) {
        if (proyecto["name"] == nombre) {
          return proyecto["id"]?.toString();
        }
      }
      print("No se encontró el proyecto con nombre: $nombre");
      return null;
    } 
  } catch (err) {
    print("Error al realizar la solicitud http para buscar proyecto por nombre: $err");
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
    int id, String nombre, String fechaInicio, String fechaFinalizada, String costo) async {
  final url = "https://datafire-production.up.railway.app/api/v1/proyectos/$id";

  try {
    final res = await http.patch(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": nombre,
        "fecha_inicio": fechaInicio,
        "fecha_fin": fechaFinalizada,
        "costo": costo
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
