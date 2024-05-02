import 'package:datafire/src/model/workers_model.dart';
import 'package:datafire/src/widgets/table_scrolleable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class NewEgresos extends StatefulWidget {
  NewEgresos({super.key, this.workersScheme});
  List<WorkerScheme>? workersScheme = [];
  @override
  State<NewEgresos> createState() => _NewEgresosState();
}

class _NewEgresosState extends State<NewEgresos> {
  late ScrollController verrticalController = ScrollController();
  double impustosTotal = 0;
  int totalSueldos = 0;
  final NumberFormat numberFormat = NumberFormat("#,##0.00", "es_MX");

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    calculosEgresos();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            cardXtable(),
            Flexible(
              child: Column(
                children: [
                  Container(
                    width: 600,
                    child: IncomeCard(
                      title: 'Division Egresos',
                      amount: '',
                      descripcion: 'Tipos de division de egresos',
                      isChart: true,
                    ),
                  ),
                  Container(
                    width: 600,
                    child: IncomeCard(
                      title: 'Pago de Impuestos',
                      amount: '',
                      descripcion: 'Gastos en pago de impuestos',
                      isChart: true,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ]),
    );
  }

  cardXtable() {
    return Container(
      width: 800,
      //height: 900,
      // color: Colors.red,,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IncomeCard(
                title: 'Total Impuestos',
                amount: '\$ ${numberFormat.format(impustosTotal)} MXN',
                descripcion: 'Otros gastos de la empresa',
                isChart: false,
              ),
              IncomeCard(
                title: 'Nomina de trabajadores',
                amount: '\$ ${numberFormat.format(totalSueldos)} MXN',
                descripcion: 'Gastos en nomina de trabajadores',
                isChart: false,
              ),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          Container(
            height: 500,
            width: 900,

            // color: Colors.red,,
            child: TableTemplate(
              isEgresos: true,
              verticalController: verrticalController,
              workerScheme: widget.workersScheme!,
            ),
          ),
          Container(
            height: 500,
            width: 900,

            // color: Colors.red,,
            child: TableTemplate(
              isEgresos: true,
              verticalController: verrticalController,
              workerScheme: widget.workersScheme!,
            ),
          )
        ],
      ),
    );
  }

  calculosEgresos() {
    double totalIsr = 0;
    double totalSS = 0;
    int sueldos = 0;
    for (int i = 0; i < widget.workersScheme!.length; i++) {
      totalSS += widget.workersScheme![i].seguroSocial;
      totalIsr += widget.workersScheme![i].isr;
      sueldos += widget.workersScheme![i].salary!;
    }
    setState(() {
      impustosTotal = totalSS + totalIsr;
      totalSueldos = sueldos;
    });
  }
}

class IncomeCard extends StatelessWidget {
  final String title;
  final String amount;
  final String descripcion;
  bool isChart = false;

  IncomeCard(
      {Key? key,
      required this.amount,
      required this.descripcion,
      required this.title,
      required this.isChart})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              SizedBox(
                height: 8,
              ),
              isChart == true
                  ? Container(
                      padding: EdgeInsets.only(top: 20),
                      height: 150,
                      width: 200,
                      child: SfCircularChart(
                        series: <CircularSeries>[
                          // Render pie chart
                          PieSeries<ChartData, String>(
                            dataSource: <ChartData>[
                              ChartData('David', 35),
                              ChartData('Steve', 38),
                              ChartData('Jack', 34),
                              ChartData('Others', 52)
                            ],
                            xValueMapper: (ChartData data, _) => data.x,
                            yValueMapper: (ChartData data, _) => data.y,
                            radius: '120%',
                            explode: true,
                            dataLabelSettings: const DataLabelSettings(
                                isVisible: true,
                                labelPosition: ChartDataLabelPosition.inside),
                          ),
                        ],
                      ),
                    )
                  : Container(),
              isChart == false
                  ? SizedBox(
                      height: 8,
                    )
                  : Container(),
              Text(
                amount,
                style: const TextStyle(
                  fontSize: 24,
                ),
              ),
              isChart == false
                  ? SizedBox(
                      height: 8,
                    )
                  : Container(),
              Text(
                descripcion,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChartData {
  ChartData(this.x, this.y);
  final String x;
  final double y;
}

class TramoISR {
  final double limiteInferior;
  final double limiteSuperior;
  final double tasa;

  TramoISR(
      {required this.limiteInferior,
      required this.limiteSuperior,
      required this.tasa});
}

class Deduccion {
  final String nombre;
  final double monto;

  Deduccion({required this.nombre, required this.monto});
}
