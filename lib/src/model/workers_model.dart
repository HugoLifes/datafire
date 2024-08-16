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
  dynamic salaryHour;
  int semanalHours;
  int salary;
  int workerCost;
  int yearsWorked;
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
    required this.yearsWorked,
  });

  factory Trabajadores.fromJson(Map<String, dynamic> json) => Trabajadores(
        id: json["id"],
        name: json["name"],
        lastName: json["last_name"],
        age: json["age"],
        position: json["position"],
        salaryHour: json["salary_hour"],
        semanalHours: json["semanal_hours"],
        yearsWorked: json["years_worked"],
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
        "years_worked": yearsWorked,
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
  dynamic salaryHour;
  dynamic semanalHours;
  int? salary;
  int? workerCost;
  int? monthCosts;
  int? yearsWorked;
  double? payxDay;
  double? payxhr;
  dynamic salarioBrutoAnual;
  DateTime? createdAt;
  dynamic seguroSocial;
  dynamic isr;
  List<double> isrBrackets = [
    0,
    6000,
    14999,
    35499,
    57499,
    80000,
    108000,
    175000,
    300000,
    400000,
    500000,
    600000,
    800000,
    1000000,
    2000000,
    3000000,
    4000000,
    5000000,
    6000000,
    7000000,
    8000000,
    9000000,
    10000000,
    11000000,
    12000000,
    13000000,
    14000000,
    15000000,
    16000000,
    17000000,
    18000000,
    19000000,
    20000000,
    21000000,
    22000000,
    23000000,
    24000000,
    25000000,
    26000000,
    27000000,
    28000000,
    29000000,
    30000000
  ];
  List<double> isrRates = [
    0.0,
    0.16,
    0.24,
    0.3,
    0.32,
    0.34,
    0.35,
    0.38,
    30.0,
    32.0,
    34.0,
    35.0,
    36.0,
    37.0,
    38.0,
    39.2,
    40.8,
    42.3,
    43.8,
    45.3,
    46.8,
    48.3,
    49.8,
    51.3,
    52.8,
    54.3,
    55.8,
    57.3,
    58.8,
    60.3,
    61.8,
    63.3,
    64.8,
    66.3,
    67.8,
    69.3,
    70.8,
    72.3,
    73.8,
    75.3,
    76.8,
    78.3,
    79.8,
    81.3
  ];

  WorkerScheme(
      {this.id,
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
      this.yearsWorked,
      this.payxDay,
      this.payxhr,
      this.salarioBrutoAnual,
      this.seguroSocial,
      this.isr});

  int pagomensual(int salary) {
    return salary * 4;
  }

  double pagohora(int salary) {
    double diario = salary / 7;

    return diario / 8;
  }

  pagoAnual(dynamic salary, int yearsTrabajados) {
    var salarioDiario = salary;
    var aguinaldo = calcularAguinaldo(salary);
    var vacaciones = calcularVacaciones(salary, yearsTrabajados);
    var isr = salarioDiario;
    var salarioanual = (salary + 52) + aguinaldo + (vacaciones * 0.25) - isr;

    return salarioanual;
  }

  dynamic calcularAguinaldo(dynamic salarioSemanal) {
    // Calculate the number of weeks worked in a year
    int semanasTrabajadas = 12;

    // Calculate the total amount of aguinaldo
    double aguinaldo = (salarioSemanal * semanasTrabajadas) / 90;

    return aguinaldo;
  }

  dynamic calcularVacaciones(dynamic salarioSemanal, int yearsTrabajados) {
    // Calculate the minimum number of vacation days
    int diasVacacionesMinimas = 6;

    // Calculate the maximum number of vacation days
    int diasVacacionesMaximas = 22;

    // Calculate the number of vacation days based on years worked
    int diasVacaciones = diasVacacionesMinimas + yearsTrabajados;

    // Calculate the vacation pay per day
    dynamic pagoVacacionesPorDia = salarioSemanal * 2;

    // Calculate the total vacation pay
    dynamic pagoVacacionesTotal = pagoVacacionesPorDia * diasVacaciones;

    return pagoVacacionesTotal;
  }

  dynamic calcularImss(dynamic salary) {
    dynamic salarioDiario = salary * 8;
    double cuotaPatronal = 3.075;
    double cuotaObrero = 7.0;
    double cuotaPatronalDiaria;

    if (salarioDiario >= 857.142) {
      cuotaPatronalDiaria = salarioDiario * cuotaPatronal / 100;
    } else {
      cuotaPatronalDiaria = salarioDiario * cuotaPatronal / 100;
    }

    double cuotaObreraDiaria = salarioDiario * cuotaObrero / 100;

    double imss = cuotaPatronalDiaria + cuotaObreraDiaria;

    return imss;
  }

  dynamic calcularISR(dynamic salary) {
    double ingresoGravableDiario = salary - 107.8;

    // Initialize ISR amount
    double isrDiario = 0;

    // Iterate through ISR brackets and rates
    for (int i = 0; i < isrBrackets.length; i++) {
      // Check if income falls within the current bracket
      if (ingresoGravableDiario <= isrBrackets[i]) {
        // Calculate ISR for the current bracket
        if (i == 0) {
          isrDiario = ingresoGravableDiario * isrRates[i];
        } else {
          // Calculate ISR for the remaining income within the bracket
          double ingresoEnRango = ingresoGravableDiario - isrBrackets[i - 1];
          isrDiario += ingresoEnRango * isrRates[i];
        }
        break; // Exit the loop once the appropriate bracket is found
      }
    }

    return isrDiario;
  }
}
