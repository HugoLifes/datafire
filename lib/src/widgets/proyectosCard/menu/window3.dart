
import 'package:datafire/src/services/proyectosTrabajadores.service.dart';
import 'package:datafire/src/services/trabajadores.servicio.dart';
import 'package:flutter/material.dart';

class ThirdTabContent extends StatelessWidget {
  final Map<String, dynamic>? proyecto;

  ThirdTabContent({required this.proyecto});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FutureBuilder<List<dynamic>>(
          future: fetchProjectWorkers(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Text('No hay datos disponibles');
            } else {
              List<dynamic> workerProjects = snapshot.data!;
              List workerData = workerProjects
                  .where((cp) => cp['project_id'] == proyecto?['id'])
                  .toList();

              return DataTable(
                columns: [
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
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              deleteProjectWorkers(worker['id']);
                              // Muestra el Snackbar al eliminar el Trabajador
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Trabajador eliminado correctamente'),
                                ),
                              );
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
        Container(
          child: IconButton.filled(
            onPressed: () {
              _selectWorkersDialog(context, proyecto?["id"].toString() ?? "");
            },
            icon: Icon(Icons.edit),
          ),
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
          title: Text("Selecciona trabajadores"),
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
              child: Text("Cancelar"),
            ),
            TextButton(
              onPressed: () {
                workersSeleccionados.forEach((workerId) {
                  postProjectWorker().addProjectWorker(projectId, workerId);
                });
                Navigator.of(context).pop();
              },
              child: Text("Guardar"),
            ),
          ],
        );
      },
    );
  }
}
