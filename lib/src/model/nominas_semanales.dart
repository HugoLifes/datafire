import 'dart:convert';

List<NominasSemanales> nominasSemanalesFromJson(String str) =>
    List<NominasSemanales>.from(
        json.decode(str).map((x) => NominasSemanales.fromJson(x)));

String nominasSemanalesToJson(List<NominasSemanales> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class NominasSemanales {
  DateTime? startDate;
  DateTime? endDate;
  List<Nomina>? nominas;
  int? totalWeeklySalary;

  NominasSemanales({
    this.startDate,
    this.endDate,
    this.nominas,
    this.totalWeeklySalary,
  });

  factory NominasSemanales.fromJson(Map<String, dynamic> json) =>
      NominasSemanales(
        startDate: json["startDate"] == null
            ? null
            : DateTime.parse(json["startDate"]),
        endDate:
            json["endDate"] == null ? null : DateTime.parse(json["endDate"]),
        nominas: json["nominas"] == null
            ? []
            : List<Nomina>.from(
                json["nominas"]!.map((x) => Nomina.fromJson(x))),
        totalWeeklySalary: json["totalWeeklySalary"],
      );

  Map<String, dynamic> toJson() => {
        "startDate": startDate?.toIso8601String(),
        "endDate": endDate?.toIso8601String(),
        "nominas": nominas == null
            ? []
            : List<dynamic>.from(nominas!.map((x) => x.toJson())),
        "totalWeeklySalary": totalWeeklySalary,
      };
}

class Nomina {
  int? workerId;
  String? workerName;
  double? salaryHour;
  int? horasTrabajadas;
  int? horasExtra;
  int? salary;
  int? isr;
  int? seguroSocial;
  int? salarioFinal;
  DateTime? startDate;
  DateTime? endDate;

  Nomina({
    this.workerId,
    this.workerName,
    this.salaryHour,
    this.horasTrabajadas,
    this.horasExtra,
    this.salary,
    this.isr,
    this.seguroSocial,
    this.salarioFinal,
    this.startDate,
    this.endDate,
  });

  factory Nomina.fromJson(Map<String, dynamic> json) => Nomina(
        workerId: json["workerId"],
        workerName: json["workerName"],
        salaryHour: json["salary_hour"]?.toDouble(),
        horasTrabajadas: json["horas_trabajadas"],
        horasExtra: json["horas_extra"],
        salary: json["salary"],
        isr: json["isr"],
        seguroSocial: json["seguro_social"],
        salarioFinal: json["salario_final"],
        startDate: json["startDate"] == null
            ? null
            : DateTime.parse(json["startDate"]),
        endDate:
            json["endDate"] == null ? null : DateTime.parse(json["endDate"]),
      );

  Map<String, dynamic> toJson() => {
        "workerId": workerId,
        "workerName": workerName,
        "salary_hour": salaryHour,
        "horas_trabajadas": horasTrabajadas,
        "horas_extra": horasExtra,
        "salary": salary,
        "isr": isr,
        "seguro_social": seguroSocial,
        "salario_final": salarioFinal,
        "startDate": startDate?.toIso8601String(),
        "endDate": endDate?.toIso8601String(),
      };
}
