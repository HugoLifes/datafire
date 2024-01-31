import 'package:datafire/src/widgets/card.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

import '../widgets/colors.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late int totalProjects;
  late List<PieChartSectionData> pieChartSections = [];

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

            // esto un color diferente a cada mes
            Color monthColor = monthColors[entry.key % monthColors.length];

            return PieChartSectionData(
              color: monthColor,
              value: projectCount,
              title: '$monthName\n${projectCount.toInt()}',
              titleStyle: TextStyle(
                fontSize: 12, // Tamaño del texto del mes
                color: Colors.black, // Color del texto del mes
                fontWeight: FontWeight.bold, // Puedes ajustar el peso de la fuente según tus preferencias
              ),
            );
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
              child: Text('Revisa tu flujo'),
            ),
            Container(
              margin: EdgeInsets.only(top: 110, left: 20),
              padding: EdgeInsets.all(10),
              decoration: CardTempII(blur: 3.0, of1: 0, of2: 3).getCard(),
              width: size.width < 800 ? size.width * 0.89 : size.width * 0.89,
              height: size.height < 800 ? size.height * 0.45 : 350,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 15, top: 6),
                    child: Text('Total'),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 15, top: 5),
                    child: Text(
                      'Ganancia',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
              padding: EdgeInsets.all(10),
              decoration: CardTempII(blur: 3.0, of1: 0, of2: 3).getCard(),
              width: size.width < 800 ? size.width * 0.45 : size.width * 0.40,
              height: size.height < 800 ? size.height * 0.45 : 350,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 15, top: 6),
                    child: Text('Nuevos'),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 15, top: 5),
                    child: Text(
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
              padding: EdgeInsets.all(10),
              decoration: CardTempII(blur: 3.0, of1: 0, of2: 3).getCard(),
              width: size.width < 800 ? size.width * 0.45 : size.width * 0.40,
              height: size.height < 800 ? size.height * 0.45 : 350,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 15, top: 6),
                    child: Text('Proyectos de los ultimos 12 meses'),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 15, top: 5),
                    child: Text(
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
                    CircularProgressIndicator(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
