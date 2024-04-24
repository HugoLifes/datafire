import 'dart:convert';

List<Trabajadores> trabajadoresFromJson(String str) => List<Trabajadores>.from(
    json.decode(str).map((x) => Trabajadores.fromJson(x)));

String trabajadoresToJson(List<Trabajadores> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Trabajadores {
  int id;
  String name;
  String lastName;
  int age;
  String position;
  int salaryHour;
  int semanalHours;
  int salary;
  int workerCost;
  DateTime createdAt;

  Trabajadores({
    required this.id,
    required this.name,
    required this.lastName,
    required this.age,
    required this.position,
    required this.salaryHour,
    required this.semanalHours,
    required this.salary,
    required this.workerCost,
    required this.createdAt,
  });

  factory Trabajadores.fromJson(Map<String, dynamic> json) => Trabajadores(
        id: json["id"],
        name: json["name"],
        lastName: json["last_name"],
        age: json["age"],
        position: json["position"],
        salaryHour: json["salary_hour"],
        semanalHours: json["semanal_hours"],
        salary: json["salary"],
        workerCost: json["WorkerCost"],
        createdAt: DateTime.parse(json["createdAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "last_name": lastName,
        "age": age,
        "position": position,
        "salary_hour": salaryHour,
        "semanal_hours": semanalHours,
        "salary": salary,
        "WorkerCost": workerCost,
        "createdAt": createdAt.toIso8601String(),
      };
}

class WorkerScheme {
  int? id;
  String? name;
  String? lastName;
  int? age;
  String? position;
  int? salaryHour;
  int? semanalHours;
  int? salary;
  int? workerCost;
  int? monthCosts;
  double? payxDay;
  double? payxhr;
  DateTime? createdAt;

  WorkerScheme({
    this.id,
    this.name,
    this.lastName,
    this.age,
    this.position,
    this.salaryHour,
    this.semanalHours,
    this.salary,
    this.workerCost,
    this.createdAt,
    this.monthCosts,
    this.payxDay,
    this.payxhr,
  });

  int pagomensual(int salary) {
    return salary * 4;
  }

  double pagodiario(int salary) {
    return salary / 7;
  }

  double pagohora(int salary) {
    double diario = salary / 7;

    return diario / 8;
  }
}
