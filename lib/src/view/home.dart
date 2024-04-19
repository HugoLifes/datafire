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
    final uri = Uri.parse(
        'https://datafire-production.up.railway.app/api/v1/proyectos/project-stats');
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
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: AppBarDatafire(
            title: "Gestion", description: "Mantente al dia de tus proyectos"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildCard(size, "Ganancia", _cartesianChart()),
            _buildCard(
                size,
                "Proyectos de los últimos 12 meses",
                pieChartSections.isNotEmpty
                    ? PieChart(_pieChartData())
                    : Center(child: const CircularProgressIndicator())),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(Size size, String title, Widget chart) {
    return Container(
      margin: const EdgeInsets.only(top: 35, left: 20, right: 20, bottom: 20),
      padding: const EdgeInsets.all(10),
      decoration: CardTempII(blur: 3.0, of1: 0, of2: 3).getCard(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15, top: 6),
            child: Text(title,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 20),
          SizedBox(height: 200, child: chart),
        ],
      ),
    );
  }

  PieChartData _pieChartData() => PieChartData(
        sections: pieChartSections,
        sectionsSpace: 0,
        centerSpaceRadius: 40,
        startDegreeOffset: -90,
        borderData: FlBorderData(show: false),
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
              width: 5,
              pointColorMapper: (ChartData data, _) => data.color,
              xValueMapper: (ChartData data, _) =>
                  _getMonthLabel(DateTime.parse(data.month).month),
              yValueMapper: (ChartData data, _) => data.totalExpense.toDouble(),
              markerSettings: const MarkerSettings(
                  color: Colors.green,
                  borderColor: Colors.black,
                  borderWidth: 3,
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
