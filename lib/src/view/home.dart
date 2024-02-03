import 'package:datafire/src/widgets/card.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'dart:math';


import '../widgets/colors.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late int totalProjects;
  late List<PieChartSectionData> pieChartSections = [];
  late List<FlSpot> costData = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:3000/Api/v1/proyectos/project-stats'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        List<Color> monthColors = [
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
        ];

        setState(() {
          totalProjects = data['totalProjects'];

          pieChartSections = List<PieChartSectionData>.from(data['projectsByMonth'].asMap().entries.map((entry) {
            double projectCount = double.tryParse(entry.value['projectCount'].toString()) ?? 0;
            String monthName = DateFormat('MMMM').format(DateTime.parse(entry.value['month']));
            Color monthColor = monthColors[entry.key % monthColors.length];

            return PieChartSectionData(
              color: monthColor,
              value: projectCount,
              title: '$monthName\n${projectCount.toInt()}',
              titleStyle: const TextStyle(
                fontSize: 12,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            );
          }));

          costData = List<FlSpot>.from(data['CostsByMonth'].asMap().entries.map((entry) {
            double totalExpense = double.tryParse(entry.value['totalExpense'].toString()) ?? 0;
            return FlSpot(entry.key.toDouble(), totalExpense);
          }));
        });
      } else {
        print('Error en la solicitud: ${response.statusCode}');
      }
    } catch (error) {
      print('Error al obtener datos: $error');
    }
  }


  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: 100,
              decoration: const BoxDecoration(
                color: accentCanvasColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(15),
              child: const Text(
                'Gestión',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 55, left: 10),
              width: size.width > 600 ? size.width * 0.8 : 500,
              child: const Text('Revisa tu flujo'),
            ),
            Container(
              margin: const EdgeInsets.only(top: 110, left: 20),
              padding: const EdgeInsets.all(10),
              decoration: CardTempII(blur: 3.0, of1: 0, of2: 3).getCard(),
              width: size.width < 800 ? size.width * 0.89 : size.width * 0.89,
              height: size.height < 800 ? size.height * 0.45 : 350,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 15, top: 6),
                    child: const Text('Total'),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 15, top: 5),
                    child: const Text(
                      'Ganancia',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                 Container(
  margin: const EdgeInsets.only(top: 10),
  height: 200,
  child: LineChart(
    LineChartData(
      gridData: FlGridData(show: false),
      titlesData: FlTitlesData(
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
            getTextStyles: (BuildContext context, double value) => const TextStyle(color: Color(0xff68737d), fontWeight: FontWeight.bold, fontSize: 16),
          getTitles: (value) {
            switch (value.toInt()) {
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
          },
          margin: 8,
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: Colors.grey),
      ),
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: costData.isNotEmpty ? costData.map((spot) => spot.y).reduce(max) : 1,
      lineBarsData: [
        LineChartBarData(
          spots: costData,
          isCurved: true,
          colors: [Colors.blue],
          belowBarData: BarAreaData(show: false),
        ),
      ],
    ),
  ),
),

                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: size.height < 760 ? size.height * 0.67 : 480,
                left: size.width > 1000 ? size.width * 0.038 : 20,
              ),
              padding: const EdgeInsets.all(10),
              decoration: CardTempII(blur: 3.0, of1: 0, of2: 3).getCard(),
              width: size.width < 800 ? size.width * 0.45 : size.width * 0.40,
              height: size.height < 800 ? size.height * 0.45 : 350,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 15, top: 6),
                    child: const Text('Nuevos'),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 15, top: 5),
                    child: const Text(
                      'Proyectos',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: size.height < 760 ? size.height * 0.67 : 480,
                left: size.width > 1000 ? size.width * 0.47 : 560,
              ),
              padding: const EdgeInsets.all(10),
              decoration: CardTempII(blur: 3.0, of1: 0, of2: 3).getCard(),
              width: size.width < 800 ? size.width * 0.45 : size.width * 0.40,
              height: size.height < 800 ? size.height * 0.45 : 350,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 15, top: 6),
                    child: const Text('Proyectos de los ultimos 12 meses'),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 15, top: 5),
                    child: const Text(
                      'Proyectos',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  if (pieChartSections.isNotEmpty)
                    SizedBox(
                      height: 220,
                      child: PieChart(
                        PieChartData(
                          sections: pieChartSections,
                          sectionsSpace: 0,
                          centerSpaceRadius: 40,
                          startDegreeOffset: -90,
                          borderData: FlBorderData(show: false), 
                          centerSpaceColor: Colors.transparent,
                        ),
                      ),
                    )
                  else
                    const CircularProgressIndicator(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
