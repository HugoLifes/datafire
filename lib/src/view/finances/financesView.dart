import 'dart:convert';

import 'package:datafire/src/model/ingresos_model.dart';
import 'package:datafire/src/view/finances/menu/Egresos.dart' as Egresos;
import 'package:datafire/src/view/finances/menu/Flujo.dart';
import 'package:datafire/src/view/finances/menu/cuentasPorCobrar.dart';
import 'package:datafire/src/view/finances/menu/ingresos.dart'
    hide OrderInfoDataSource;
import 'package:datafire/src/view/finances/menu/new_ingresos.dart';
import 'package:datafire/src/widgets/appBar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FinancesView extends StatefulWidget {
  const FinancesView({Key? key}) : super(key: key);

  @override
  _FinancesViewState createState() => _FinancesViewState();
}

Future<List<Ingresos>> fetchingresos() async {
  final response = await http.get(Uri.parse(
      'https://datafire-production.up.railway.app/Api/v1/proyectos/ingresos'));

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

  @override
  void initState() {
    super.initState();
    fetchDataFuture = fetchData();
    //fetchIngresosFuture = fetchingresos();
    dataIngresos();
    fetchCobrarData = fetchCuentasCobrarData();
    fetchFlujData = fetchFlujoData();
  }

  Future<List<Map<String, dynamic>>> fetchData() async {
    final response = await http.get(Uri.parse(
        'https://datafire-production.up.railway.app/Api/v1/proyectos/egresos'));

    if (response.statusCode == 200) {
      debugPrint("cargado con éxito");
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Error al cargar datos de egresos');
    }
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

  Future<List<Map<String, dynamic>>> fetchCuentasCobrarData() async {
    final response = await http.get(Uri.parse(
        'https://datafire-production.up.railway.app/Api/v1/proyectos/cuentasCobrar'));

    if (response.statusCode == 200) {
      debugPrint("Cuentas por cobrar cargado con éxito");
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Error al cargar datos de Ingresos');
    }
  }

  Future<List<Map<String, dynamic>>> fetchFlujoData() async {
    final response = await http.get(Uri.parse(
        'https://datafire-production.up.railway.app/Api/v1/proyectos/flujo'));

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
      body: Row(
        children: [
          Expanded(
            flex: 2,
            child: DefaultTabController(
              length: 4,
              child: Column(
                children: [
                  const TabBar(tabs: [
                    Tab(text: "Egresos"),
                    Tab(text: "Ingresos"),
                    Tab(text: "Flujo"),
                    Tab(text: "  Cuentas por cobrar")
                  ]),
                  Expanded(
                    child: TabBarView(
                      children: [
                        Egresos.EgresosWidget(fetchDataFuture: fetchDataFuture),
                        NewIngresos(
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
      ),
    );
  }
}
