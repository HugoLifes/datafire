// To parse this JSON data, do
//
//     final proyectos = proyectosFromJson(jsonString);

import 'dart:convert';

List<Proyectos> proyectosFromJson(String str) =>
    List<Proyectos>.from(json.decode(str).map((x) => Proyectos.fromJson(x)));

String proyectosToJson(List<Proyectos> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Proyectos {
  int? id;
  String? name;
  DateTime? fechaInicio;
  DateTime? fechaFin;
  int? duracion;
  int? costoInicial;
  int? anticipo;
  int? presupuesto;
  int? costo;
  int? abonado;
  int? remaining;
  int? ganancia;
  bool? status;
  int? customerId;
  DateTime? createdAt;

  Proyectos({
    this.id,
    this.name,
    this.fechaInicio,
    this.fechaFin,
    this.duracion,
    this.costoInicial,
    this.anticipo,
    this.presupuesto,
    this.costo,
    this.abonado,
    this.remaining,
    this.ganancia,
    this.status,
    this.customerId,
    this.createdAt,
  });

  factory Proyectos.fromJson(Map<String, dynamic> json) => Proyectos(
        id: json["id"],
        name: json["name"],
        fechaInicio: json["fecha_inicio"] == null
            ? null
            : DateTime.parse(json["fecha_inicio"]),
        fechaFin: json["fecha_fin"] == null
            ? null
            : DateTime.parse(json["fecha_fin"]),
        duracion: json["duracion"],
        costoInicial: json["costo_inicial"],
        anticipo: json["anticipo"],
        presupuesto: json["presupuesto"],
        costo: json["costo"],
        abonado: json["abonado"],
        remaining: json["remaining"],
        ganancia: json["ganancia"],
        status: json["status"],
        customerId: json["customerId"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "fecha_inicio": fechaInicio?.toIso8601String(),
        "fecha_fin": fechaFin?.toIso8601String(),
        "duracion": duracion,
        "costo_inicial": costoInicial,
        "anticipo": anticipo,
        "presupuesto": presupuesto,
        "costo": costo,
        "abonado": abonado,
        "remaining": remaining,
        "ganancia": ganancia,
        "status": status,
        "customerId": customerId,
        "createdAt": createdAt?.toIso8601String(),
      };
}
