

import 'package:datafire/src/view/NominasView/NominasView.dart';
import 'package:datafire/src/widgets/appBar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // Para decodificar la respuesta del API

class NominasMain extends StatefulWidget {
  const NominasMain({Key? key}) : super(key: key);

  @override
  _NominasMainState createState() => _NominasMainState();
}

class _NominasMainState extends State<NominasMain> {
  List<Map<String, dynamic>> allNominas = []; // Vacío inicialmente
  late Map<String, dynamic> selectedWeek; // Será inicializado después de cargar los datos

  @override
  void initState() {
    super.initState();
    loadNominas(); // Cargar los datos al inicializar el widget
  }

  // Función para cargar los datos de las nóminas desde el API
  Future<void> loadNominas() async {
    var url = Uri.parse('http://localhost:3000/Api/v1/nominasSemanales/weeklyNominas'); // Sustituye con la URL de tu API
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> nominasData = json.decode(response.body);
        setState(() {
          allNominas = nominasData.map<Map<String, dynamic>>((nomina) => nomina as Map<String, dynamic>).toList();
          if (allNominas.isNotEmpty) {
            selectedWeek = allNominas.last;
          }
        });
      } else {
        throw Exception('Failed to load nominas');
      }
    } catch (e) {
      print(e.toString());
      // Manejar el error como consideres necesario
    }
  }

  @override
  Widget build(BuildContext context) {
    // El resto del código del build sigue igual
    return Scaffold(
      appBar: const PreferredSize(
              preferredSize: Size.fromHeight(kToolbarHeight),
              child: AppBarDatafire(title: "Nominas", description: "En esta sección podra llevar un registro de las nominas, asi como generarlas.")
            ),
            floatingActionButton: FloatingActionButton.extended(
              label: Text("Generar Nomina"),
              onPressed: (){
                Navigator.push(context, 
                MaterialPageRoute(
              builder: (context) => const NominasView(),
            ),);
              },
              icon: const Icon(Icons.group_add),
              ),
      body: allNominas.isNotEmpty // Verificar que los datos están cargados
          ? buildBody()
          : Center(child: CircularProgressIndicator()), // Mostrar un indicador de carga mientras los datos están siendo cargados
    );
  }

  Widget buildBody() => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: DropdownButton<Map<String, dynamic>>(
                isExpanded: true,
                value: selectedWeek,
                onChanged: (newValue) {
                  setState(() {
                    selectedWeek = newValue!;
                  });
                },
                items: allNominas.map<DropdownMenuItem<Map<String, dynamic>>>((Map<String, dynamic> value) {
                  return DropdownMenuItem<Map<String, dynamic>>(
                    value: value,
                    child: Text(
                      "${DateFormat('yyyy-MM-dd').format(DateTime.parse(value['startDate']))} a ${DateFormat('yyyy-MM-dd').format(DateTime.parse(value['endDate']))}",
                      style: TextStyle(color: Colors.deepPurple),
                    ),
                  );
                }).toList(),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: selectedWeek['nominas'].length,
                itemBuilder: (context, index) {
                  final nomina = selectedWeek['nominas'][index];
                  return Card(
                    elevation: 4.0,
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      leading: Icon(Icons.person, color: Colors.deepPurple),
                      title: Text(
                        "${nomina['workerName']}",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text("Salario: \$${nomina['salary']}"),
                    ),
                  );
                },
              ),
            ),
            // Widget para mostrar el total semanal
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                "Total Semanal: \$${selectedWeek['totalWeeklySalary']}",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepPurple),
              ),
            ),
          ],
        ),
      );
}
