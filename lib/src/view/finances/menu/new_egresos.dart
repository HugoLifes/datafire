import 'dart:io';

import 'package:datafire/src/model/nominas_semanales.dart';
import 'package:datafire/src/model/prestamos_model.dart';
import 'package:datafire/src/model/workers_model.dart';
import 'package:datafire/src/widgets/chartInfoBox.dart';
import 'package:datafire/src/widgets/table_scrolleable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class NewEgresos extends StatefulWidget {
  NewEgresos({super.key, this.workersScheme, this.nominasWeek, this.prestamos});
  List<WorkerScheme>? workersScheme = [];
  List<NominasSemanales>? nominasWeek = [];
  List<Prestamos>? prestamos = [];
  @override
  State<NewEgresos> createState() => _NewEgresosState();
}

class _NewEgresosState extends State<NewEgresos> {
  late ScrollController verrticalController = ScrollController();
  double impustosTotal = 0;
  dynamic totalSueldos;
  final NumberFormat numberFormat = NumberFormat("#,##0.00", "es_MX");
  bool isEgresos = true;
  List<ChartData>? chartdata = [];
  List<ChartData>? chartdata2 = [];
  List<DivisionEgresos> dEgresos = [];

  @override
  void initState() {
    super.initState();
    calculosEgresos();
  }

  @override
  Widget build(BuildContext context) {
    return Platform.isAndroid ? viewAndroid() : viewWindows();
  }

  Row viewWindows() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        cardXtable(false),
        Column(
          children: [
            SizedBox(
              width: 600,
              child: IncomeCard(
                title: 'Division Egresos',
                amount: '',
                descripcion: 'Tipos de division de egresos',
                isChart: true,
                chartdata: chartdata2,
              ),
            ),
            SizedBox(
              width: 600,
              child: IncomeCard(
                title: 'Pago de Impuestos',
                amount: '',
                descripcion: 'Gastos en pago de impuestos',
                isChart: true,
                chartdata: chartdata,
              ),
            ),
          ],
        ),
      ],
    );
  }

  cardXtable(bool isAndroid) {
    return SizedBox(
      width: 800,
      //height: 900,
      // color: Colors.red,,
      child: Column(
        children: [
          Platform.isAndroid
              ? Column(
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
                )
              : Row(
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
          isAndroid
              ? Container()
              : SizedBox(
                  width: 900,
                  height: 500,
                  child: GridView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      childAspectRatio: 1.6,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 15,
                    ),
                    itemCount: widget.nominasWeek!.length,
                    itemBuilder: (_, int data) {
                      return TableTemplate(
                        isEgresos: isEgresos,
                        verticalController: verrticalController,
                        workerScheme: widget.workersScheme!,
                        payroll: widget.nominasWeek![data].nominas,
                        isFlujo: false,
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }

  calculosEgresos() {
    for (int i = 0; i < widget.nominasWeek!.length; i++) {
      List<Egresos>? egresos = [];
      double totalIsr = 0;
      double totalSS = 0;
      dynamic sueldos = 0;
      for (int j = 0; j < widget.nominasWeek![i].nominas!.length; j++) {
        totalSS += widget.nominasWeek![i].nominas![j].seguroSocial;
        totalIsr += widget.nominasWeek![i].nominas![j].isr;
        sueldos += widget.nominasWeek![i].nominas![j].salary!;
      }
      egresos.add(Egresos(isr: totalIsr, ss: totalSS, salary: sueldos));
      dEgresos.add(DivisionEgresos(egresos: egresos));
    }
    setState(() {
      impustosTotal = dEgresos.isEmpty
          ? 0.0
          : dEgresos.last.egresos!.last.isr + dEgresos.last.egresos!.last.ss;
      totalSueldos =
          dEgresos.isEmpty ? 0.0 : dEgresos.last.egresos!.last.salary;
    });

    chartdata!.add(ChartData(
        'Ss',
        dEgresos.isEmpty
            ? '0.0'
            : double.parse(dEgresos.last.egresos!.last.ss.toString())
                .toStringAsFixed(1)));
    chartdata!.add(ChartData(
        'ISR',
        dEgresos.isEmpty
            ? '0.0'
            : double.parse(dEgresos.last.egresos!.last.isr.toString())
                .toStringAsFixed(1)));

    chartdata2!.add(ChartData(
        'Salario',
        dEgresos.isEmpty
            ? '0.0'
            : double.parse(dEgresos.last.egresos!.last.salary.toString())
                .toStringAsFixed(1)));
    chartdata2!.add(ChartData(
        'ISR',
        dEgresos.isEmpty
            ? '0.0'
            : double.parse(dEgresos.last.egresos!.last.isr.toString())
                .toStringAsFixed(1)));
    chartdata2!.add(ChartData(
        'Ss',
        dEgresos.isEmpty
            ? double.parse('0.00').toStringAsFixed(1)
            : double.parse(dEgresos.last.egresos!.last.ss.toString())
                .toStringAsFixed(1)));
  }

  viewAndroid() {
    return ListView(
      shrinkWrap: true,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            cardXtable(true),
            Column(
              children: [
                SizedBox(
                  width: 600,
                  child: IncomeCard(
                    title: 'Division Egresos',
                    amount: '',
                    descripcion: 'Tipos de division de egresos',
                    isChart: true,
                    chartdata: chartdata2,
                  ),
                ),
                SizedBox(
                  width: 600,
                  child: IncomeCard(
                    title: 'Pago de Impuestos',
                    amount: '',
                    descripcion: 'Gastos en pago de impuestos',
                    isChart: true,
                    chartdata: chartdata,
                  ),
                ),
              ],
            ),
          ],
        )
      ],
    );
  }
}

class IncomeCard extends StatelessWidget {
  final String title;
  final String amount;
  final String descripcion;
  bool isChart = false;
  List<ChartData>? chartdata = [];

  IncomeCard({
    Key? key,
    required this.amount,
    required this.descripcion,
    required this.title,
    required this.isChart,
    this.chartdata,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: InkWell(
        child: Card(
          elevation: 3,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'GoogleSans',
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                isChart == true
                    ? Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.only(top: 20),
                            height: 150,
                            width: 200,
                            child: SfCircularChart(
                              series: <CircularSeries>[
                                // Render pie chart
                                PieSeries<ChartData, String>(
                                  dataSource: chartdata,
                                  xValueMapper: (ChartData data, _) =>
                                      data.gasto,
                                  yValueMapper: (ChartData data, _) =>
                                      double.tryParse(data.calculo),
                                  radius: '120%',
                                  explode: true,
                                  dataLabelSettings: const DataLabelSettings(
                                      isVisible: true,
                                      labelPosition:
                                          ChartDataLabelPosition.inside),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const ChartInfoBox(
                                color: Color(0xff6355c7),
                                title: 'ISR',
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              title.contains('Pago de Impuestos')
                                  ? Container()
                                  : const ChartInfoBox(
                                      color: Color(0xff315a74),
                                      title: 'Seguro Social',
                                    ),
                              title.contains('Pago de Impuestos')
                                  ? Container()
                                  : const SizedBox(
                                      height: 10,
                                    ),
                              title.contains('Pago de Impuestos')
                                  ? const ChartInfoBox(
                                      color: Color(0xff06aee0),
                                      title: 'Seguro Social',
                                    )
                                  : const ChartInfoBox(
                                      color: Color(0xff06aee0),
                                      title: 'Nomina',
                                    )
                            ],
                          )
                        ],
                      )
                    : Container(),
                isChart == false
                    ? const SizedBox(
                        height: 8,
                      )
                    : Container(),
                Text(
                  amount,
                  style: const TextStyle(
                    fontFamily: 'GoogleSans',
                    fontSize: 24,
                  ),
                ),
                isChart == false
                    ? const SizedBox(
                        height: 8,
                      )
                    : Container(),
                Text(
                  descripcion,
                  style: const TextStyle(
                    fontFamily: 'GoogleSans',
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ChartData {
  ChartData(this.gasto, this.calculo);
  final String gasto;
  final dynamic calculo;
}

class DivisionEgresos {
  DivisionEgresos({this.egresos});
  List<Egresos>? egresos = [];
}

class Egresos {
  Egresos({this.isr, this.salary, this.ss});

  final dynamic ss;
  final dynamic isr;
  final dynamic salary;
}
