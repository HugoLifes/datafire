import 'dart:convert';
import 'package:datafire/src/model/ingresos_model.dart';
import 'package:datafire/src/model/nominas_semanales.dart';
import 'package:datafire/src/model/workers_model.dart';
import 'package:datafire/src/services/nominas_semanales_service.dart';
import 'package:datafire/src/services/trabajadores.servicio.dart';
import 'package:datafire/src/view/finances/menu/Egresos.dart' as Egresos;
import 'package:datafire/src/view/finances/menu/Flujo.dart';
import 'package:datafire/src/view/finances/menu/cuentasPorCobrar.dart';
import 'package:datafire/src/view/finances/menu/ingresos.dart'
    hide OrderInfoDataSource;
import 'package:datafire/src/view/finances/menu/new_egresos.dart';
import 'package:datafire/src/view/finances/menu/new_ingresos.dart';
import 'package:datafire/src/widgets/appBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class FinancesView extends StatefulWidget {
  const FinancesView({Key? key}) : super(key: key);

  @override
  _FinancesViewState createState() => _FinancesViewState();
}

Future<List<Ingresos>> fetchingresos() async {
  final response = await http
      .get(Uri.parse('http://localhost:3000/Api/v1/proyectos/ingresos'));

  if (response.statusCode == 200) {
    debugPrint("cargado con éxito");
    return ingesosFromJson(response.body);
  } else {
    throw Exception('Error al cargar datos de Ingresos');
  }
}

class _FinancesViewState extends State<FinancesView> {
  late Future<List<Map<String, dynamic>>> fetchDataFuture;
  late Future<List<Map<String, dynamic>>> fetchIngresosFuture;
  late Future<List<Map<String, dynamic>>> fetchCobrarData;
  late Future<List<Map<String, dynamic>>> fetchFlujData;
  late Egresos.OrderInfoDataSource dataSource;
  late dynamic ingresos;
  List<IngresosScheme> ingresoScheme = [];
  List<AbonoScheme> abonoScheme = [];
  List<WorkerScheme> workersScheme = [];
  bool isLoading = true;
  List<NominasSemanales> nominasWeek = [];
  List<Nomina> nominasPay = [];

  @override
  void initState() {
    super.initState();

    //fetchIngresosFuture = fetchingresos();
    dataEgresos().then((value) => {
          setState(() {
            isLoading = false;
          })
        });
    dataIngresos();
    fetchCobrarData = fetchCuentasCobrarData();
    fetchFlujData = fetchFlujoData();
  }

  //nueva funcion ingresos
  Future dataIngresos() async {
    await fetchingresos().then((value) => {
          for (int i = 0; i < value.length; i++)
            {
              for (int j = 0; j < value[i].abonos.length; j++)
                {
                  abonoScheme.add(AbonoScheme(
                      amount: value[i].abonos[j].amount,
                      projectName: value[i].abonos[j].projectName,
                      date: value[i].abonos[j].date))
                },
              ingresoScheme.add(IngresosScheme(
                  startDate: value[i].startDate,
                  endDate: value[i].endDate,
                  abonos: abonoScheme,
                  totalWeeklyAbonos: value[i].totalWeeklyAbonos))
            }
        });
  }

  //funcion que llama a los egresos
  Future dataEgresos() async {
    var data = await newFetchWorkers();

    for (int i = 0; i < data.length; i++) {
      workersScheme.add(WorkerScheme(
          id: data[i].id,
          name: data[i].name,
          lastName: data[i].lastName,
          age: data[i].age,
          position: data[i].position,
          semanalHours: data[i].semanalHours,
          yearsWorked: data[i].yearsWorked,
          salary: data[i].salary,
          workerCost: data[i].workerCost,
          createdAt: data[i].createdAt,
          salarioBrutoAnual:
              WorkerScheme().pagoAnual(data[i].salaryHour, data[i].yearsWorked),
          seguroSocial: WorkerScheme().calcularImss(
            data[i].salary,
          ),
          isr: WorkerScheme().calcularISR(data[i].salary)));
    }
  }

  // funcion que carga las nominas
  Future dataNominas() async {
    await loadNominas().then((value) {
      for (int i = 0; i < value.length; i++) {
        for (int j = 0; j < value[i].nominas!.length; j++) {
          nominasPay.add(Nomina(
              workerId: value[i].nominas![j].workerId,
              workerName: value[i].nominas![j].workerName,
              salaryHour: value[i].nominas![j].salaryHour,
              salary: value[i].nominas![j].salary,
              horasTrabajadas: value[i].nominas![j].horasTrabajadas,
              isr: WorkerScheme().calcularISR(value[i].nominas![j].salary),
              seguroSocial:
                  WorkerScheme().calcularImss(value[i].nominas![j].salary)));
        }
        nominasWeek.add(NominasSemanales(
          startDate: value[i].startDate,
          endDate: value[i].endDate,
          nominas: nominasPay,
        ));
      }
    });
  }

  Future<List<Map<String, dynamic>>> fetchCuentasCobrarData() async {
    final response = await http
        .get(Uri.parse('http://localhost:3000/Api/v1/proyectos/cuentasCobrar'));

    if (response.statusCode == 200) {
      debugPrint("Cuentas por cobrar cargado con éxito");
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Error al cargar datos de Ingresos');
    }
  }

  Future<List<Map<String, dynamic>>> fetchFlujoData() async {
    final response = await http
        .get(Uri.parse('http://localhost:3000/Api/v1/proyectos/flujo'));

    if (response.statusCode == 200) {
      debugPrint("Cuentas por cobrar cargado con éxito");
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Error al cargar datos de Ingresos');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: AppBarDatafire(
            title: "Finanzas",
            description:
                "Aquí tendrás acceso a todas las finanzas de los proyectos"),
      ),
      body: tabView(),
    );
  }

  Row tabView() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: DefaultTabController(
            length: 4,
            child: Column(
              children: [
                const TabBar(
                    labelStyle: TextStyle(
                      fontFamily: 'GoogleSans',
                    ),
                    tabs: [
                      Tab(text: "Egresos"),
                      Tab(text: "Ingresos"),
                      Tab(text: "Flujo"),
                      Tab(text: "  Cuentas por cobrar")
                    ]),
                Flexible(
                  child: TabBarView(
                    children: [
                      isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : NewEgresos(
                              workersScheme: workersScheme,
                              nominasWeek: nominasWeek,
                            ),
                      isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : NewIngresos(
                              ingresoScheme: ingresoScheme,
                            ),
                      FlujoWidget(fetchDataFuture: fetchFlujData),
                      CobrarWidget(fetchDataFuture: fetchCobrarData)
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
