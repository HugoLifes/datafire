import 'dart:ffi';

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
  int idCliente;
  String? nombreCliente;
  String? apellidoCliente;
  List<Proyecto>? proyectos;
  bool? linkProyecto = false;
  Deuda? deuda;

  Clientes(this.nombreCliente, this.idCliente,
      {this.proyectos, this.linkProyecto, this.apellidoCliente, this.deuda});

  void agregarProyecto(Proyecto proyecto) {
    proyectos!.toList().add(proyecto);
  }
}

    Future<List<dynamic>> obtenerClientes() async {
    return await fetchClientes();
  }

class Trabajadores {
  int idTrabajador;
  String? nombre;
  String? apellido;
  List<dynamic>? misionesEncargos = [];
  double? edad;
  String? position;
  double? salario;


  Trabajadores(
    this.idTrabajador, {
    this.nombre,
    this.apellido,
    this.misionesEncargos,
    this.edad,
    this.position,
    this.salario,
  });

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
