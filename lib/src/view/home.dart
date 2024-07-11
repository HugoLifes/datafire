import 'dart:io';

import 'package:datafire/src/widgets/colors.dart';
import 'package:datafire/src/widgets/shapes.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:datafire/src/widgets/appBar.dart';
import 'package:datafire/src/widgets/card.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late int totalProjects;
  late List<PieChartSectionData> pieChartSections = [];
  late List<FlSpot> costData = [];
  late List<ChartData> chartData = [];
  late TooltipBehavior _tooltipBehavior;
  late List<ChartData> profit = [];
  late List<ChartData> payments = [];
  dynamic lastProfit;
  String lastProject = '';
  String lastCustomer = '';
  dynamic lastPayment;
  bool isLoading = true;
  bool errorConection = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _showWelcomeMessage());
    _tooltipBehavior = TooltipBehavior(enable: true);
    fetchData().whenComplete(() {
      setState(() {
        isLoading = false;
      });
    });
  }

  fetchData() async {
    final uri =
        Uri.parse('http://localhost:3000/api/v1/proyectos/project-stats');
    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        final data = json.decode(response.body);
        setState(() {
          _updateChartData(data);
          lastProfit = jsonData['lastProfit'];
          lastProject = jsonData['lastProject'];
          lastCustomer = jsonData['lastCustomer'];
          lastPayment = jsonData['lastPayment'];

          print(jsonData['costsByMonth']);

          chartData = (jsonData['costsByMonth'] as List)
              .map(
                (e) => ChartData.fromJson(e),
              )
              .toList();
          profit = (jsonData['profitByMonth'] as List)
              .map((e) => ChartData.fromJson(e))
              .toList();
          payments = (jsonData['paymentsByMonth'] as List)
              .map((e) => ChartData.fromJson(e))
              .toList();
        });
      }
    } on SocketMessage {
      return 'Error de conexion';
    } catch (e) {
      return ErrorWidget('error, $e');
    }
  }

  void _updateChartData(Map<String, dynamic> data) {
    final monthColors = List<Color>.of([
      Colors.blue,
      Colors.teal,
      Colors.orange,
      Colors.purple,
      Colors.green,
      Colors.red,
      Colors.indigo,
      Colors.amber,
      Colors.deepPurple,
      Colors.lime,
      Colors.cyan,
      Colors.deepOrange,
    ]);
    totalProjects = data['totalProjects'];
    pieChartSections =
        (data['projectsByMonth'] as List).asMap().entries.map((entry) {
      final projectCount =
          double.tryParse(entry.value['projectCount'].toString()) ?? 0.0;
      final monthName =
          DateFormat('MMMM').format(DateTime.parse(entry.value['month']));
      final monthColor = monthColors[entry.key % monthColors.length];

      return PieChartSectionData(
        showTitle: true,
        color: monthColor,
        value: projectCount,
        title: '${monthName.substring(0, 3)}\n${projectCount.toInt()}',
        titleStyle: const TextStyle(
            fontFamily: 'GoogleSans',
            fontSize: 10,
            color: Colors.black,
            fontWeight: FontWeight.bold),
      );
    }).toList();
  }

  void _showWelcomeMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text(
            'Bienvenido a la gestión de tus proyectos!',
            style: TextStyle(
              fontFamily: 'GoogleSans',
            ),
          ),
          duration: Duration(seconds: 2)),
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(61),
        child: AppBarDatafire(
            title: "Gestion", description: "Mantente al dia de tus proyectos"),
      ),
      body: Center(
        child: LayoutBuilder(builder: (context, constraints) {
          final anchoPantalla = MediaQuery.of(context).size.width;
          final largoPantalla = MediaQuery.of(context).size.height;
          print(' ancho $anchoPantalla');
          print('largo $largoPantalla');
          final double title1 = anchoPantalla > 1100 ? 18 : 15;
          final double title2 = anchoPantalla > 1100 ? 24 : 18;
          final double title3 = anchoPantalla > 1100 ? 16 : 15;

          return isLoading == true
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : ListView(
                  children: [
                    Stack(
                      children: [
                        Container(
                          child: _buildCard("Calculo de datos",
                              _cartesianChart(), size, 0.25, false),
                        ),
                        anchoPantalla < 950 && largoPantalla < 800
                            ? Container(
                                margin:
                                    EdgeInsets.only(top: size.height * 0.40),
                                alignment: Alignment.center,
                                child: Column(
                                  children: [
                                    Container(
                                      width: size.width * 0.3,
                                      height: size.height * 0.41,
                                      child: _buildCard(
                                          "Proyectos añadidos",
                                          pieChartSections.isNotEmpty
                                              ? PieChart(_pieChartData())
                                              : const Center(
                                                  child:
                                                      CircularProgressIndicator()),
                                          size,
                                          0.25,
                                          true),
                                    ),
                                    Container(
                                        child: cardsHorizontalView(
                                            size,
                                            title1,
                                            title2,
                                            title3,
                                            anchoPantalla,
                                            largoPantalla)),
                                  ],
                                ),
                              )
                            : Container(
                                margin:
                                    EdgeInsets.only(top: size.height * 0.40),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      width: size.width * 0.3,
                                      height: size.height * 0.41,
                                      child: _buildCard(
                                          "Proyectos añadidos",
                                          pieChartSections.isNotEmpty
                                              ? PieChart(_pieChartData())
                                              : const Center(
                                                  child:
                                                      CircularProgressIndicator()),
                                          size,
                                          0.25,
                                          true),
                                    ),
                                    Container(
                                        child: cardsHorizontalView(
                                            size,
                                            title1,
                                            title2,
                                            title3,
                                            anchoPantalla,
                                            largoPantalla)),
                                  ],
                                ),
                              )
                      ],
                    ),
                  ],
                );
        }),
      ),
    );
  }

  cardsHorizontalView(Size size, double title1, double title2, double title3,
      double ancho, double largo) {
    return ancho < 950 && largo < 800
        ? Column(
            children: [
              Column(
                children: [
                  Container(
                    width: size.width * 0.23,
                    child: _buildCardInfo("Clientes Recientes", lastCustomer,
                        "Cliente mas actual", size, title1, title2, title3),
                  ),
                  Container(
                    width: size.width * 0.23,
                    height: size.height * 0.26,
                    child: _buildCardInfo(
                        "Ultimas Ganancias",
                        lastProfit,
                        "Ultima ganancia registrada",
                        size,
                        title1,
                        title2,
                        title3),
                  ),
                ],
              ),
              Column(
                children: [
                  Container(
                    width: size.width * 0.23,
                    height: size.height * 0.26,
                    child: _buildCardInfo("Pagos reciente", lastPayment,
                        "Pagos mas recientes", size, title1, title2, title3),
                  ),
                  Container(
                    width: size.width * 0.23,
                    height: size.height * 0.26,
                    child: _buildCardInfo(
                        "Proyectos recientes",
                        lastProject,
                        "Ultimos pagos realizados",
                        size,
                        title1,
                        title2,
                        title3),
                  ),
                ],
              ),
            ],
          )
        : Row(
            children: [
              Column(
                children: [
                  Container(
                    width: size.width * 0.23,
                    height: size.height * 0.26,
                    child: _buildCardInfo("Clientes Recientes", lastCustomer,
                        "Cliente mas actual", size, title1, title2, title3),
                  ),
                  Container(
                    width: size.width * 0.23,
                    height: size.height * 0.26,
                    child: _buildCardInfo(
                        "Ultimas Ganancias",
                        lastProfit,
                        "Ultima ganancia registrada",
                        size,
                        title1,
                        title2,
                        title3),
                  ),
                ],
              ),
              Column(
                children: [
                  Container(
                    width: size.width * 0.23,
                    height: size.height * 0.26,
                    child: _buildCardInfo("Pagos reciente", lastPayment,
                        "Pagos mas recientes", size, title1, title2, title3),
                  ),
                  Container(
                    width: size.width * 0.23,
                    height: size.height * 0.26,
                    child: _buildCardInfo(
                        "Proyectos recientes",
                        lastProject,
                        "Ultimos pagos realizados",
                        size,
                        title1,
                        title2,
                        title3),
                  ),
                ],
              ),
            ],
          );
  }

  // tarjetas primarias
  Widget _buildCard(
      String title, Widget chart, Size size, double height, bool circular) {
    return Container(
      padding: EdgeInsets.all(5),
      child: Card(
        borderOnForeground: false,
        clipBehavior: Clip.antiAlias,
        elevation: circular == true ? 5 : 3,
        color: cardColor,
        margin: EdgeInsets.all(11),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //texto chart
            Padding(
              padding: const EdgeInsets.only(left: 15, top: 6),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(title,
                    style: const TextStyle(
                        fontFamily: 'GoogleSans',
                        fontSize: 21,
                        fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 10),
            //chart
            circular == true
                ? Container(
                    margin: EdgeInsets.all(100),
                    height: size.height * 0.0,
                    child: chart,
                  )
                : Container(
                    padding: EdgeInsets.all(5),
                    height: size.height * 0.3,
                    child: chart,
                  )
          ],
        ),
      ),
    );
  }

  // contenido de las tarjetas paralelas
  Widget _buildCardInfo(String title, dynamic content, String descripcion,
      Size size, double title1, double title2, double title3) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'GoogleSans',
                    fontWeight: FontWeight.bold,
                    fontSize: title1,
                  ),
                ),
              ),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  '$content',
                  style: TextStyle(
                    fontFamily: 'GoogleSans',
                    fontSize: title2,
                  ),
                ),
              ),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  descripcion,
                  style: TextStyle(
                    fontFamily: 'GoogleSans',
                    fontSize: title3,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  PieChartData _pieChartData() => PieChartData(
        sections: pieChartSections,
        sectionsSpace: 0,
        centerSpaceRadius: 40,
        startDegreeOffset: -90,
        pieTouchData: PieTouchData(enabled: true),
        borderData: FlBorderData(
          show: false,
        ),
        centerSpaceColor: Colors.transparent,
      );

  SfCartesianChart _cartesianChart() => SfCartesianChart(
        enableAxisAnimation: true,
        zoomPanBehavior: ZoomPanBehavior(
          enableMouseWheelZooming: true,
          zoomMode: ZoomMode.xy, // Zoom en ambos ejes
          maximumZoomLevel: 5.0, // Límite de zoom máximo
        ),
        primaryXAxis: const CategoryAxis(
          labelPlacement: LabelPlacement.onTicks,
        ),
        primaryYAxis: NumericAxis(
            numberFormat: NumberFormat.compactCurrency(
                locale: 'es_MX', symbol: '\$', decimalDigits: 2)),
        tooltipBehavior: _tooltipBehavior,
        series: <CartesianSeries>[
          LineSeries<ChartData, String>(
              name: 'Gastos',
              enableTooltip: true,
              dataSource: chartData,
              width: 3,
              pointColorMapper: (ChartData data, _) => data.color![0],
              xValueMapper: (ChartData data, _) =>
                  _getMonthLabel(DateTime.parse(data.month!).month),
              yValueMapper: (ChartData data, _) =>
                  data.totalExpense!.toDouble(),
              markerSettings: const MarkerSettings(
                  color: Colors.green,
                  borderColor: Colors.black,
                  borderWidth: 5,
                  shape: DataMarkerType.diamond,
                  width: 8,
                  height: 8,
                  isVisible: true),
              dataLabelSettings: const DataLabelSettings(
                  alignment: ChartAlignment.far,
                  useSeriesColor: true,
                  textStyle: TextStyle(
                      fontSize: 13,
                      fontFamily: 'GoogleSans',
                      fontWeight: FontWeight.w500),
                  isVisible: true,
                  labelAlignment: ChartDataLabelAlignment.auto)),
          LineSeries<ChartData, String>(
              name: 'Ganancias',
              enableTooltip: true,
              dataSource: profit,
              width: 3,
              pointColorMapper: (ChartData data, _) => data.color![1],
              xValueMapper: (ChartData data, _) =>
                  _getMonthLabel(DateTime.parse(data.month!).month),
              yValueMapper: (ChartData data, _) => data.totalProfit,
              markerSettings: const MarkerSettings(
                  color: Colors.green,
                  borderColor: Colors.black,
                  borderWidth: 5,
                  shape: DataMarkerType.diamond,
                  width: 4,
                  height: 4,
                  isVisible: true),
              dataLabelSettings: const DataLabelSettings(
                  alignment: ChartAlignment.far,
                  useSeriesColor: true,
                  textStyle: TextStyle(
                      fontSize: 13,
                      fontFamily: 'GoogleSans',
                      fontWeight: FontWeight.w500),
                  isVisible: true,
                  labelAlignment: ChartDataLabelAlignment.outer)),
          LineSeries<ChartData, String>(
              name: 'Pagos',
              enableTooltip: true,
              dataSource: payments,
              width: 3,
              pointColorMapper: (ChartData data, _) => data.color![2],
              xValueMapper: (ChartData data, _) =>
                  _getMonthLabel(DateTime.parse(data.month!).month),
              yValueMapper: (ChartData data, _) =>
                  data.totalPayments.toDouble(),
              markerSettings: const MarkerSettings(
                  color: Colors.green,
                  borderColor: Colors.black,
                  borderWidth: 5,
                  shape: DataMarkerType.diamond,
                  width: 4,
                  height: 4,
                  isVisible: true),
              dataLabelSettings: const DataLabelSettings(
                  alignment: ChartAlignment.near,
                  useSeriesColor: true,
                  textStyle: TextStyle(
                      fontSize: 13,
                      fontFamily: 'GoogleSans',
                      fontWeight: FontWeight.w500),
                  isVisible: true,
                  labelAlignment: ChartDataLabelAlignment.auto))
        ],
      );

  String _getMonthLabel(int value) {
    switch (value) {
      case 1:
        return 'Ene';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Abr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Ago';
      case 9:
        return 'Sep';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dic';
      default:
        return '';
    }
  }
}

class ChartData {
  ChartData(
      {this.month,
      this.totalExpense,
      this.color,
      this.totalProfit,
      this.totalPayments});
  final String? month;
  final dynamic? totalExpense;
  final dynamic? totalProfit;
  final dynamic? totalPayments;
  final List<Color>? color;

  factory ChartData.fromJson(Map<String, dynamic> json) {
    return ChartData(
        month: json['month'],
        totalExpense: json['totalExpense'] != null
            ? double.parse(json['totalExpense'])
            : '',
        totalPayments: json['totalPayment'] != null
            ? double.parse(json['totalPayment'])
            : '',
        totalProfit: json['totalProfit'] != null
            ? double.parse(json['totalProfit'].toString())
            : '',
        color: [Colors.redAccent, Colors.greenAccent, Colors.blueAccent]);
  }
}
