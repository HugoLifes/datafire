import 'package:datafire/src/view/NominasView/NominasView.dart';
import 'package:datafire/src/widgets/appBar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NominasMain extends StatefulWidget {
  const NominasMain({Key? key}) : super(key: key);

  @override
  _NominasMainState createState() => _NominasMainState();
}

class _NominasMainState extends State<NominasMain> {
  List<Map<String, dynamic>> allNominas = [];
  late Map<String, dynamic> selectedWeek;

  @override
  void initState() {
    super.initState();
    loadNominas();
  }

  Future<void> loadNominas() async {
    var url = Uri.parse('http://localhost:3000/Api/v1/nominasSemanales/weeklyNominas');
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: AppBarDatafire(title: "Nominas", description: "Registro y generación de nóminas.")
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Theme.of(context).primaryColor,
        label: Text("Generar Nómina", style: TextStyle(color: Colors.white)),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => NominasView()));
        },
        icon: const Icon(Icons.group_add, color: Colors.white),
      ),
      body: allNominas.isNotEmpty ? buildBody() : Center(child: CircularProgressIndicator()),
    );
  }

  Widget buildBody() => Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      children: [
        buildDropdown(),
        SizedBox(height: 20), // Añade un espacio vertical para mejor separación
        Expanded(child: buildNominaList()),
        buildTotalSemanal(),
      ],
    ),
  );

  // Mejoras visuales en Dropdown
  Widget buildDropdown() => Container(
    padding: EdgeInsets.symmetric(vertical: 8.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10.0),
      border: Border.all(color: Theme.of(context).primaryColorLight, width: 1),
    ),
    child: DropdownButtonHideUnderline(
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
              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
            ),
          );
        }).toList(),
      ),
    ),
  );

  Widget buildNominaList() => ListView.builder(
    itemCount: selectedWeek['nominas'].length,
    itemBuilder: (context, index) {
      final nomina = selectedWeek['nominas'][index];
      return Card(
        elevation: 2.0, 
        margin: EdgeInsets.symmetric(vertical: 8.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), // Bordes redondeados
        child: ListTile(
          leading: CircleAvatar( 
            backgroundColor: Theme.of(context).primaryColor,
            child: Icon(Icons.person, color: Colors.white),
          ),
          title: Text(
            "${nomina['workerName']}",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text("Salario: \$${nomina['salary']}"),
        ),
      );
    },
  );

  Widget buildTotalSemanal() => Padding(
    padding: EdgeInsets.symmetric(vertical: 16.0),
    child: Text(
      "Total Semanal: \$${selectedWeek['totalWeeklySalary']}",
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
    ),
  );
}
