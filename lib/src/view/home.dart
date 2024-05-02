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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _showWelcomeMessage());
    _tooltipBehavior = TooltipBehavior(enable: true);
    fetchData();
  }

  Future<void> fetchData() async {
    final uri =
        Uri.parse('http://localhost:3000/api/v1/proyectos/project-stats');
    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        final data = json.decode(response.body);
        setState(() {
          _updateChartData(data);
          chartData = (jsonData['CostsByMonth'] as List)
              .map(
                (e) => ChartData.fromJson(e),
              )
              .toList();
        });
      }
    } catch (e) {
      print(e);
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
        color: monthColor,
        value: projectCount,
        title: '$monthName\n${projectCount.toInt()}',
        titleStyle: const TextStyle(
            fontSize: 12, color: Colors.black, fontWeight: FontWeight.bold),
      );
    }).toList();

    /* costData = (data['CostsByMonth'] as List).asMap().entries.map((entry) {
      final totalExpense =
          double.tryParse(entry.value['totalExpense'].toString()) ?? 0.0;
      return FlSpot(entry.key.toDouble(), totalExpense);
    }).toList();*/
  }

  void _showWelcomeMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Bienvenido a la gestión de tus proyectos!'),
          duration: Duration(seconds: 3)),
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildCard("Ganancia", _cartesianChart(), size),
            Row(
              children: [
                Container(
                  width: size.width / 6,
                  height: 350,
                  child: _buildCardInfo(
                      "Ultimos Datos",
                      _triangles(Size(45, 45), TrianguloArriba()),
                      _triangles(Size(45, 45), TrianguloAbajo()),
                      size,
                      false),
                ),
                const SizedBox(
                  width: 10,
                ),
                Container(
                  width: size.width / 5,
                  height: 350,
                  child: _buildCard(
                      "Proyectos añadidos",
                      pieChartSections.isNotEmpty
                          ? PieChart(_pieChartData())
                          : const Center(
                              child: const CircularProgressIndicator()),
                      size),
                ),
                const SizedBox(
                  width: 10,
                ),
                cardsHorizontalView(size),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Row cardsHorizontalView(Size size) {
    return Row(
      children: [
        Column(
          children: [
            Container(
              width: size.width / 4,
              height: 150,
              child: _buildCardInfo(
                  "Clientes Recientes",
                  _triangles(Size(45, 45), TrianguloArriba()),
                  _triangles(Size(45, 45), TrianguloAbajo()),
                  size,
                  true),
            ),
            Container(
              width: size.width / 4,
              height: 150,
              child: _buildCardInfo(
                  "Ultimas Ganancias",
                  _triangles(Size(45, 45), TrianguloArriba()),
                  _triangles(Size(45, 45), TrianguloAbajo()),
                  size,
                  true),
            ),
          ],
        ),
        SizedBox(
          width: 30,
        ),
        Column(
          children: [
            Container(
              width: size.width / 4,
              height: 150,
              child: _buildCardInfo(
                  "Pagos reciente",
                  _triangles(Size(45, 45), TrianguloArriba()),
                  _triangles(Size(45, 45), TrianguloAbajo()),
                  size,
                  true),
            ),
            Container(
              width: size.width / 4,
              height: 150,
              child: _buildCardInfo(
                  "Proyectos recientes",
                  _triangles(Size(45, 45), TrianguloArriba()),
                  _triangles(Size(45, 45), TrianguloAbajo()),
                  size,
                  true),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCard(String title, Widget chart, Size size) {
    return Card(
      borderOnForeground: false,
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.all(15),
      elevation: 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15, top: 6),
            child: Text(title,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 10),
          Container(
            padding: EdgeInsets.all(10),
            height: size.height * 0.25,
            child: chart,
          )
        ],
      ),
    );
  }

  Widget _buildCardInfo(String title, CustomPaint paint, CustomPaint paint2,
      Size size, bool otherInfo) {
    return Card(
      borderOnForeground: false,
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.all(15),
      elevation: 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 15,
            ),
            child: Text(title,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ),
          SizedBox(
            height: 35,
          ),
          otherInfo
              ? Container()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: paint,
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: paint2,
                    ),
                  ],
                )
        ],
      ),
    );
  }

  PieChartData _pieChartData() => PieChartData(
        sections: pieChartSections,
        sectionsSpace: 0,
        centerSpaceRadius: 40,
        startDegreeOffset: -90,
        borderData: FlBorderData(
          show: false,
        ),
        centerSpaceColor: Colors.transparent,
      );

  SfCartesianChart _cartesianChart() => SfCartesianChart(
        enableAxisAnimation: true,
        primaryXAxis: CategoryAxis(),
        primaryYAxis: NumericAxis(
            numberFormat:
                NumberFormat.compactCurrency(locale: 'es_MX', symbol: '\$')),
        tooltipBehavior: _tooltipBehavior,
        series: <CartesianSeries>[
          LineSeries<ChartData, String>(
              enableTooltip: true,
              dataSource: chartData,
              width: 3,
              pointColorMapper: (ChartData data, _) => data.color,
              xValueMapper: (ChartData data, _) =>
                  _getMonthLabel(DateTime.parse(data.month).month),
              yValueMapper: (ChartData data, _) => data.totalExpense.toDouble(),
              markerSettings: const MarkerSettings(
                  color: Colors.green,
                  borderColor: Colors.black,
                  borderWidth: 5,
                  shape: DataMarkerType.circle,
                  width: 4,
                  height: 4,
                  isVisible: true),
              dataLabelSettings: const DataLabelSettings(
                  useSeriesColor: true,
                  textStyle: TextStyle(
                      fontSize: 13,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w500),
                  isVisible: true,
                  labelAlignment: ChartDataLabelAlignment.auto))
        ],
      );

  String _getMonthLabel(int value) {
    switch (value) {
      case 0:
        return 'Ene';
      case 1:
        return 'Feb';
      case 2:
        return 'Mar';
      case 3:
        return 'Abr';
      case 4:
        return 'May';
      case 5:
        return 'Jun';
      case 6:
        return 'Jul';
      case 7:
        return 'Ago';
      case 8:
        return 'Sep';
      case 9:
        return 'Oct';
      case 10:
        return 'Nov';
      case 11:
        return 'Dic';
      default:
        return '';
    }
  }

  CustomPaint _triangles(Size size, CustomPainter direction) {
    return CustomPaint(
      painter: direction,
      size: size,
    );
  }
}

class ChartData {
  ChartData(this.month, this.totalExpense, this.color);
  final String month;
  final double totalExpense;
  final Color? color;

  factory ChartData.fromJson(Map<String, dynamic> json) {
    return ChartData(
        json['month'], double.parse(json['totalExpense']), Colors.blue);
  }
}
