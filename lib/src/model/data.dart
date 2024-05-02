import 'dart:convert';
import 'package:datafire/src/services/AuthHeader.dart';
import 'package:http/http.dart' as http;
import 'package:datafire/src/services/cliente.servicio.dart';
import 'package:datafire/src/services/proyectos.service.dart';
import 'package:datafire/src/services/trabajadores.servicio.dart';

// Clase Deuda para representar la deuda
class Deuda {
  double monto;

  Deuda({required this.monto});
}

// Clase Proyecto con la relación de deuda
class Proyecto {
  int? id;
  String? nombreProyecto;
  Clientes? cliente;
  bool? variosClientes = false;
  List<Trabajadores>? trabajadores;
  double? costoProyecto;
  DateTime? fechaInicio;
  DateTime? fechaFinal;
  bool? divisionPago = false;
  Deuda? deuda; // Relación con la clase Deuda

  Proyecto({
    this.id,
    this.nombreProyecto,
    this.costoProyecto,
    this.cliente,
    this.variosClientes,
    this.fechaFinal,
    this.fechaInicio,
    this.divisionPago,
    this.deuda,
  });

  buscaClienteProyecto() {}

  crearId() async {}
}

Future<List<dynamic>> obtenerProyectos() async {
  return await fetchProjects();
}

class Clientes {
  String? nombre;
  String? apellido;
  String? company;

  Clientes({this.nombre, this.apellido, this.company});

  Future<void> actualizarCliente({
    required int id,
    required String nombre,
    required String apellido,
    required String company,
  }) async {
    // Llama al método en el servicio correspondiente
    await updateCliente(
      id,
      nombre,
      apellido,
      company,
    );
  }

  Future<void> eliminarCliente(int id) async {
    await deleteCliente(id);
  }

  Future<void> nuevoCliente() async {
    Map<String, String> headers = await getAuthHeaders();
    if (nombre != null && apellido != null && company != null) {
      try {
        final res = await http.post(
          Uri.parse(
              "https://datafire-production.up.railway.app/api/v1/clientes"),
          headers: {"Content-Type": "application/json", ...headers},
          body: jsonEncode(
              {"name": nombre, "last_name": apellido, "company": company}),
        );
        if (res.statusCode == 201) {
          print(res.body);
        } else {
          print(res.body);
        }
        // ignore: empty_catches
      } catch (err) {
        print(err);
      }
    }
  }
}

Future<List<dynamic>> obtenerClientes() async {
  return await fetchClientes();
}

class Trabajadores {
  String? nombre;
  String? apellido;
  List<dynamic>? misionesEncargos = [];
  double? edad;
  String? position;
  int? salario;
  double? semanalHours;

  Trabajadores(
      {this.nombre,
      this.apellido,
      this.misionesEncargos,
      this.edad,
      this.position,
      this.salario,
      this.semanalHours});

  Future<void> actualizarTrabajador({
    required int id,
    required String nombre,
    required String apellido,
    required int edad,
    required String position,
    required int salario,
  }) async {
    // Llama al método en el servicio correspondiente
    await updateTrabajador(
      id,
      nombre,
      apellido,
      edad,
      position,
      salario,
    );
  }

  Future<void> eliminarTrabajador(int id) async {
    // Llama al método en el servicio correspondiente
    await deleteTrabajador(id);
  }

  Future<void> nuevoTrabajador(String nombre, String apellido, String edad,
      String position, String salario, String semanalHours) async {
    Map<String, String> headers = await getAuthHeaders();
    try {
      final res = await http.post(
        Uri.parse("http://localhost:3000/api/v1/trabajadores"),
        headers: {"Content-Type": "application/json", ...headers},
        body: jsonEncode({
          "name": nombre,
          "last_name": apellido,
          "age": edad,
          "position": position,
          "salary": salario,
          "semanal_hours": semanalHours
        }),
      );
      if (res.statusCode == 201) {
      } else {
        print("${res.statusCode}");
      }
      // ignore: empty_catches
    } catch (err) {}
  }
}

Future<List<dynamic>> obtenerTrabajadores() async {
  return await fetchTrabajadores();
}

//Las Metas que hay que llevar acerca del proyecto
class MetasProyecto {
  DateTime? fechaInicio;
  DateTime? fechaFinal;
  String? descripcion;
  String? titulo;
  List<Trabajadores>? encargados;

  MetasProyecto(
      {this.descripcion,
      this.encargados,
      this.fechaFinal,
      this.fechaInicio,
      this.titulo});
}
