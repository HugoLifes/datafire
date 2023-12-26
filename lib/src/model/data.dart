import 'dart:convert';
import 'dart:ffi';
import 'package:http/http.dart' as http;
import 'package:datafire/src/services/cliente.servicio.dart';
import 'package:datafire/src/services/proyectos.service.dart';
import 'package:datafire/src/services/trabajadores.servicio.dart';
import 'package:flutter/material.dart';

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


  Clientes({
    this.nombre,
    this.apellido,
    this.company
  });

  Future<void> nuevoCliente() async {
    if (nombre != null && apellido != null && company != null) {
      try {
        final res = await http.post(
          Uri.parse("https://datafire-production.up.railway.app/api/v1/clientes"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "name": nombre,
            "last_name": apellido,
             "company": company
          }),
        );
        if (res.statusCode == 201) {
          print("Cliente Guardado Exitosamente");
        } else {
          print("Error al guardar el cliente");
        }
      } catch (err) {
        print("Error al realizar la solicitud http: $err");
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
  double? salario;

  Trabajadores(
       {
        this.nombre,
        this.apellido,
        this.misionesEncargos,
        this.edad,
        this.position,
        this.salario,
      });

  Future<void> nuevoTrabajador(
      String nombre, String apellido, String edad, String position, String salario) async {
    try {
      final res = await http.post(
        Uri.parse("https://datafire-production.up.railway.app/api/v1/trabajadores"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "name": nombre,
          "last_name": apellido,
          "age": edad,
          "position": position,
          "salary": salario
        }),
      );
      if (res.statusCode == 201) {
        print("Trabajador Guardado Exitosamente");
      } else {
        print("Error al guardar el trabajador");
      }
    } catch (err) {
      print("Error al realizar la solicitud http: $err");
    }
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
