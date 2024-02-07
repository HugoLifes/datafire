import 'package:datafire/src/services/proyectosTrabajadores.service.dart';
import 'package:datafire/src/services/trabajadores.servicio.dart';
import 'package:flutter/material.dart';

class Window3 extends StatefulWidget {
  final Map<String, dynamic>? proyecto;

  Window3({required this.proyecto});

  @override
  _Window3State createState() => _Window3State();
}

class _Window3State extends State<Window3> {
  late Future<List<dynamic>> futureProjectWorkers;

  @override
  void initState() {
    super.initState();
    futureProjectWorkers = fetchProjectWorkers();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FutureBuilder<List<dynamic>>(
          future: futureProjectWorkers,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Text('No hay datos disponibles');
            } else {
              List<dynamic> workerProjects = snapshot.data!;
              List workerData = workerProjects
                  .where((cp) => cp['project_id'] == widget.proyecto?['id'])
                  .toList();

              return DataTable(
                columns: const [
                  DataColumn(label: Text('Trabajadores')),
                  DataColumn(
                    label: Text('Eliminar'),
                    numeric: true,
                  ),
                ],
                rows: workerData
                    .map((worker) => DataRow(
                          cells: [
                            DataCell(Text(worker['worker_name'].toString())),
                            DataCell(
                              IconButton(
                                icon: const Icon(Icons.delete),
onPressed: () async {
  await deleteProjectWorkers(worker['id']);
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('Trabajador eliminado correctamente'),
    ),
  );
  setState(() {
    futureProjectWorkers = fetchProjectWorkers();
  });
},

                              ),
                            ),
                          ],
                        ))
                    .toList(),
              );
            }
          },
        ),
        IconButton.filled(
          onPressed: () {
            _selectWorkersDialog(context, widget.proyecto?["id"].toString() ?? "");
          },
          icon: const Icon(Icons.edit),
        ),
      ],
    );
  }

  void _selectWorkersDialog(BuildContext context, String projectId) async {
    List<dynamic> workers = await fetchTrabajadores();
    List<String> workersSeleccionados = [];

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Selecciona trabajadores"),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SingleChildScrollView(
                child: Column(
                  children: workers.map((worker) {
                    bool isSelected = workersSeleccionados.contains(worker["id"]?.toString() ?? "");

                    return CheckboxListTile(
                      title: Text(worker["name"]?.toString() ?? ""),
                      value: isSelected,
                      onChanged: (bool? value) {
                        setState(() {
                          if (value != null) {
                            if (value) {
                              workersSeleccionados.add(worker["id"]?.toString() ?? "");
                            } else {
                              workersSeleccionados.remove(worker["id"]?.toString() ?? "");
                            }
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancelar"),
            ),
            TextButton(
              onPressed: () async {
                await Future.forEach(workersSeleccionados, (workerId) async {
                  await postProjectWorker().addProjectWorker(projectId, workerId);
                });

                // Update the list after adding workers
                setState(() {
                  futureProjectWorkers = fetchProjectWorkers();
                });

                // Close the dialog
                Navigator.of(context).pop();
              },
              child: const Text("Guardar"),
            ),
          ],
        );
      },
    );
  }
}
