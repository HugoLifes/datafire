// To parse this JSON data, do
//
//     final egresos = egresosFromJson(jsonString);

import 'dart:convert';

List<Egresos> egresosFromJson(String str) =>
    List<Egresos>.from(json.decode(str).map((x) => Egresos.fromJson(x)));

String egresosToJson(List<Egresos> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Egresos {
  DateTime startDate;
  DateTime endDate;
  List<WeeklyCost> weeklyCost;
  int totalWeeklyCost;

  Egresos({
    required this.startDate,
    required this.endDate,
    required this.weeklyCost,
    required this.totalWeeklyCost,
  });

  factory Egresos.fromJson(Map<String, dynamic> json) => Egresos(
        startDate: DateTime.parse(json["startDate"]),
        endDate: DateTime.parse(json["endDate"]),
        weeklyCost: List<WeeklyCost>.from(
            json["weeklyCost"].map((x) => WeeklyCost.fromJson(x))),
        totalWeeklyCost: json["totalWeeklyCost"],
      );

  Map<String, dynamic> toJson() => {
        "startDate": startDate.toIso8601String(),
        "endDate": endDate.toIso8601String(),
        "weeklyCost": List<dynamic>.from(weeklyCost.map((x) => x.toJson())),
        "totalWeeklyCost": totalWeeklyCost,
      };
}

class WeeklyCost {
  int projectId;
  String projectName;
  int weeklyCost;

  WeeklyCost({
    required this.projectId,
    required this.projectName,
    required this.weeklyCost,
  });

  factory WeeklyCost.fromJson(Map<String, dynamic> json) => WeeklyCost(
        projectId: json["projectId"],
        projectName: json["projectName"],
        weeklyCost: json["weeklyCost"],
      );

  Map<String, dynamic> toJson() => {
        "projectId": projectId,
        "projectName": projectName,
        "weeklyCost": weeklyCost,
      };
}
