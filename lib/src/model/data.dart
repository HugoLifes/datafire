//Tiene todas las caracteristicas a tomar en cuenta en un proyecto
class Proyecto {
  int? id;
  String? nombreProyecto;
  String? descProyecto;
  Clientes? cliente;
  bool? variosClienter = false;
  List<Trabajadores>? trabajadores;
  double? costoProyecto;
  DateTime? fechaInicio;
  DateTime? fechaFinal;
  bool? divisionPago = false;

  Proyecto({
    this.id,
    this.nombreProyecto,
    this.descProyecto,
    this.costoProyecto,
    this.cliente,
    this.trabajadores,
    this.variosClienter,
    this.fechaFinal,
    this.fechaInicio,
    this.divisionPago,
  });

  buscaClienteProyecto() {}

  crearId() async {}
}

//Tiene todas las caracteristicas de los clientes
class Clientes {
  int idCliente;
  String? nombreCliente;
  String? apellidoCliente;
  List<Proyecto>? proyectos;
  bool? linkProyecto = false;
  double? deuda;

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
