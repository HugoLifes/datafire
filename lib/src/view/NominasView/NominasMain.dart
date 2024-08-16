
import 'package:datafire/src/model/proyectos_model.dart';
import 'package:datafire/src/services/proyectos.service.dart';
import 'package:datafire/src/widgets/appBar.dart';
import 'package:datafire/src/widgets/cache_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import "./NominasView.dart";

class NominasMain extends StatefulWidget {
  const NominasMain({Key? key}) : super(key: key);

  @override
  _NominasMainState createState() => _NominasMainState();
}

class _NominasMainState extends State<NominasMain> {
  List<Map<String, dynamic>> allNominas = [];
  late Map<String, dynamic> selectedWeek;
  Future<List<dynamic>>? projects;
  bool hasData = true;
  List<Proyectos> proyectos = [];
  @override
  void initState() {
    super.initState();
    loadNominas();
    obtenerProyectos();
  }

  Future<void> loadNominas() async {
    final url = Uri.parse(
        'https://data-fire-product.up.railway.app/Api/v1/nominasSemanales/weeklyNominas');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final nominasData = json.decode(response.body) as List;
        setState(() {
          allNominas = nominasData.cast<Map<String, dynamic>>();
          selectedWeek = allNominas.isNotEmpty ? allNominas.last : {};
        });
      } else if (response.statusCode == 405) {
        setState(() {
          hasData = false;
        });

        throw Exception('Failed to load nominas');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  obtenerProyectos() async {
    await fetchProjects2().then((value) => {
          for (int i = 0; i < value.length; i++)
            {
              proyectos.add(Proyectos(
                  id: value[i].id,
                  name: value[i].name,
                  fechaInicio: value[i].fechaInicio,
                  fechaFin: value[i].fechaFin,
                  createdAt: value[i].createdAt))
            },
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: AppBarDatafire(
            title: "Nominas", description: "Registro y generación de nóminas."),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text("Generar Nómina",
            style: TextStyle(
              fontFamily: 'GoogleSans',
            )),
        onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => NominasView(
                      proyectos: proyectos,
                    ))),
        icon: const Icon(
          Icons.group_add,
        ),
      ),
      body: allNominas.isNotEmpty
          ? buildNominaContent()
          : hasData == false
              ? Center(
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/sleep.gif',
                        isAntiAlias: true,
                      ),
                      const Text(
                        'NO HAY DATOS, DA DE ALTA NOMINAS PARA EMPEZAR',
                        style: TextStyle(
                            fontFamily: 'GoogleSans',
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                )
              : const Center(child: CircularProgressIndicator()),
    );
  }

  Widget buildNominaContent() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          buildDropdown(),
          const SizedBox(height: 20),
          Expanded(child: buildNominaList()),
          buildTotalSemanal(),
        ],
      ),
    );
  }

  Widget buildDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border:
            Border.all(color: Theme.of(context).primaryColorLight, width: 1),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<Map<String, dynamic>>(
          isExpanded: true,
          value: selectedWeek,
          onChanged: (newValue) => setState(() => selectedWeek = newValue!),
          items:
              allNominas.map<DropdownMenuItem<Map<String, dynamic>>>((value) {
            final startDate = DateFormat('yyyy-MM-dd')
                .format(DateTime.parse(value['startDate']));
            final endDate = DateFormat('yyyy-MM-dd')
                .format(DateTime.parse(value['endDate']));
            return DropdownMenuItem(
              value: value,
              child: Text("$startDate a $endDate",
                  style: TextStyle(
                      fontFamily: 'GoogleSans',
                      color: Theme.of(context).colorScheme.secondary)),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget buildNominaList() {
    return ListView.builder(
      itemCount: selectedWeek['nominas']?.length ?? 0,
      itemBuilder: (context, index) {
        final nomina = selectedWeek['nominas'][index];
        return buildNominaListItem(nomina);
      },
    );
  }

  Widget buildNominaListItem(Map<String, dynamic> nomina) {
    return Card(
      elevation: 2.0,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        onTap: () => showNominaDetailsDialog(context, nomina),
        leading: const CircleAvatar(
          backgroundColor: Colors.deepPurple,
          child: Icon(Icons.person, color: Colors.white),
        ),
        title: Text(nomina['workerName'],
            style: const TextStyle(
                fontFamily: 'GoogleSans', fontWeight: FontWeight.bold)),
        subtitle: Text(
          "Salario: \$${nomina['salary']}",
          style: const TextStyle(
            fontFamily: 'GoogleSans',
          ),
        ),
      ),
    );
  }

  void showNominaDetailsDialog(
      BuildContext context, Map<String, dynamic> nomina) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(nomina['workerName'],
              style: const TextStyle(
                  fontFamily: 'GoogleSans', fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                buildDialogListItem(Icons.monetization_on, "Salario por hora",
                    "\$${nomina['salary_hour']}"),
                buildDialogListItem(Icons.access_time, "Horas trabajadas",
                    "${nomina['horas_trabajadas']}"),
                buildDialogListItem(Icons.nightlight_round, "Horas extra",
                    "${nomina['horas_extra']}"),
                buildDialogListItem(Icons.account_balance_wallet, "Salario",
                    "\$${nomina['salary']}"),
                buildDialogListItem(
                    Icons.trending_down, "ISR", "\$${nomina['isr']}"),
                buildDialogListItem(Icons.medical_services, "Seguro Social",
                    "\$${nomina['seguro_social']}"),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cerrar',
                  style: TextStyle(
                      fontFamily: 'GoogleSans',
                      color: Theme.of(context).primaryColor)),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  Widget buildDialogListItem(IconData icon, String title, String trailing) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).primaryColor),
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: 'GoogleSans',
        ),
      ),
      trailing: Text(trailing,
          style: const TextStyle(
              fontFamily: 'GoogleSans', fontWeight: FontWeight.bold)),
    );
  }

  Widget buildTotalSemanal() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Text(
        "Total Semanal: \$${selectedWeek['totalWeeklySalary']}",
        style: TextStyle(
            fontFamily: 'GoogleSans',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor),
      ),
    );
  }

  Widget buildImageCache() {
    return FutureBuilder<ImageProvider>(
      future: getFileFromCache('working.png'),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Image(image: snapshot.data!);
        } else if (snapshot.hasError) {
          return const Text('Error al cargar el GIF');
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
