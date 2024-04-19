// To parse this JSON data, do
//
//     final ingesos = ingesosFromJson(jsonString);

import 'dart:convert';

List<Ingresos> ingesosFromJson(String str) =>
    List<Ingresos>.from(json.decode(str).map((x) => Ingresos.fromJson(x)));

String ingesosToJson(List<Ingresos> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Ingresos {
  DateTime startDate;
  DateTime endDate;
  List<Abono> abonos;
  int totalWeeklyAbonos;

  Ingresos({
    required this.startDate,
    required this.endDate,
    required this.abonos,
    required this.totalWeeklyAbonos,
  });

  factory Ingresos.fromJson(Map<String, dynamic> json) => Ingresos(
        startDate: DateTime.parse(json["startDate"]),
        endDate: DateTime.parse(json["endDate"]),
        abonos: List<Abono>.from(json["abonos"].map((x) => Abono.fromJson(x))),
        totalWeeklyAbonos: json["totalWeeklyAbonos"],
      );

  Map<String, dynamic> toJson() => {
        "startDate": startDate.toIso8601String(),
        "endDate": endDate.toIso8601String(),
        "abonos": List<dynamic>.from(abonos.map((x) => x.toJson())),
        "totalWeeklyAbonos": totalWeeklyAbonos,
      };
}

class Abono {
  int amount;
  String projectName;
  DateTime date;

  Abono({
    required this.amount,
    required this.projectName,
    required this.date,
  });

  factory Abono.fromJson(Map<String, dynamic> json) => Abono(
        amount: json["amount"],
        projectName: json["projectName"],
        date: DateTime.parse(json["date"]),
      );

  Map<String, dynamic> toJson() => {
        "amount": amount,
        "projectName": projectName,
        "date": date.toIso8601String(),
      };
}

class IngresosScheme {
  DateTime startDate;
  DateTime endDate;
  List<AbonoScheme> abonos;
  int totalWeeklyAbonos;

  IngresosScheme({
    required this.startDate,
    required this.endDate,
    required this.abonos,
    required this.totalWeeklyAbonos,
  });
}

class AbonoScheme {
  int amount;
  String projectName;
  DateTime date;

  AbonoScheme({
    required this.amount,
    required this.projectName,
    required this.date,
  });
}
