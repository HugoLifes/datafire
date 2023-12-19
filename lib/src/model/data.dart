import 'dart:ffi';

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
  String? descProyecto;
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
    this.descProyecto,
    this.costoProyecto,
    this.cliente,
    this.variosClientes,
    this.fechaFinal,
    this.fechaInicio,
    this.divisionPago,
    this.deuda, // Añadir la deuda al constructor
  });

  buscaClienteProyecto() {}

  crearId() async {}
}

// Clase Clientes con la relación de deuda
class Clientes {
  int idCliente;
  String? nombreCliente;
  String? apellidoCliente;
  List<Proyecto>? proyectos;
  bool? linkProyecto = false;
  Deuda? deuda; // Relación con la clase Deuda

  Clientes(this.nombreCliente, this.idCliente,
      {this.proyectos, this.linkProyecto, this.apellidoCliente, this.deuda});

  void agregarProyecto(Proyecto proyecto) {
    proyectos!.toList().add(proyecto);
  }
}

//Tiene todas las caracteristicas de los trabajadores
class Trabajadores {
  int idTrabajador;
  String? nombre;
  String? apellido;
  String? detalles;
  List<dynamic>? misionesEncargos = [];
  double? pago;
  DateTime? fechaPago;
  double? pagoMensual;

  Trabajadores(
    this.idTrabajador, {
    this.nombre,
    this.apellido,
    this.detalles,
    this.misionesEncargos,
    this.pago,
    this.pagoMensual,
    this.fechaPago,
  });
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
