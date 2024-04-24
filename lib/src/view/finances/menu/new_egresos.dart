import 'package:datafire/src/model/workers_model.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class NewEgresos extends StatefulWidget {
  NewEgresos({super.key, this.workersScheme});
  List<WorkerScheme>? workersScheme = [];
  @override
  State<NewEgresos> createState() => _NewEgresosState();
}

class _NewEgresosState extends State<NewEgresos> {
  late ScrollController verticalController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IncomeCard(
            title: 'Otros gastos',
            amount: '\$ 5000',
            descripcion: 'Otros gastos de la empresa',
            isChart: false,
          ),
          IncomeCard(
            title: 'Nomina de trabajadores',
            amount: '\$50,000',
            descripcion: 'Gastos en nomina de trabajadores',
            isChart: false,
          ),
          IncomeCard(
            title: 'Division Egresos',
            amount: '',
            descripcion: 'Tipos de division de egresos',
            isChart: true,
          )
        ],
      ),
    ]);
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
