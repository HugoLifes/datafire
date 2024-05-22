// To parse this JSON data, do
//
//     final prestamos = prestamosFromJson(jsonString);

import 'dart:convert';

List<Prestamos> prestamosFromJson(String str) =>
    List<Prestamos>.from(json.decode(str).map((x) => Prestamos.fromJson(x)));

String prestamosToJson(List<Prestamos> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Prestamos {
  int? id;
  DateTime? datePrestamo;
  int? amountPaid;
  DateTime? createdAt;

  Prestamos({
    this.id,
    this.datePrestamo,
    this.amountPaid,
    this.createdAt,
  });

  factory Prestamos.fromJson(Map<String, dynamic> json) => Prestamos(
        id: json["id"],
        datePrestamo: json["date_prestamo"] == null
            ? null
            : DateTime.parse(json["date_prestamo"]),
        amountPaid: json["amount_paid"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "date_prestamo": datePrestamo?.toIso8601String(),
        "amount_paid": amountPaid,
        "createdAt": createdAt?.toIso8601String(),
      };
}
