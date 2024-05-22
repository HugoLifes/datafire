// To parse this JSON data, do
//
//     final flujoCaja = flujoCajaFromJson(jsonString);

import 'dart:convert';

List<FlujoCaja> flujoCajaFromJson(String str) =>
    List<FlujoCaja>.from(json.decode(str).map((x) => FlujoCaja.fromJson(x)));

String flujoCajaToJson(List<FlujoCaja> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FlujoCaja {
  DateTime? startDate;
  DateTime? endDate;
  dynamic? caja;
  dynamic? ingresos;
  dynamic? egresos;
  dynamic? nomina;
  dynamic? impuestos;
  dynamic? balanceDeFlujo;
  dynamic? prestamo;
  dynamic? balanceTotal;

  FlujoCaja({
    this.startDate,
    this.endDate,
    this.caja,
    this.ingresos,
    this.egresos,
    this.nomina,
    this.impuestos,
    this.balanceDeFlujo,
    this.prestamo,
    this.balanceTotal,
  });

  factory FlujoCaja.fromJson(Map<String, dynamic> json) => FlujoCaja(
        startDate: json["startDate"] == null
            ? null
            : DateTime.parse(json["startDate"]),
        endDate:
            json["endDate"] == null ? null : DateTime.parse(json["endDate"]),
        caja: json["caja"],
        ingresos: json["ingresos"],
        egresos: json["egresos"],
        nomina: json["nomina"],
        impuestos: json["impuestos"],
        balanceDeFlujo: json["balance de flujo"],
        prestamo: json["prestamo"],
        balanceTotal: json["Balance total"],
      );

  Map<String, dynamic> toJson() => {
        "startDate": startDate?.toIso8601String(),
        "endDate": endDate?.toIso8601String(),
        "caja": caja,
        "ingresos": ingresos,
        "egresos": egresos,
        "nomina": nomina,
        "impuestos": impuestos,
        "balance de flujo": balanceDeFlujo,
        "prestamo": prestamo,
        "Balance total": balanceTotal,
      };
}
