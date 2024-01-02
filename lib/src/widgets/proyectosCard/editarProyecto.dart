import 'dart:convert';
import 'package:datafire/src/services/cliente.servicio.dart';
import 'package:datafire/src/services/proyectos-clientes.service.dart';
import 'package:datafire/src/services/proyectos.service.dart';
import 'package:datafire/src/services/proyectosTrabajadores.service.dart';
import 'package:datafire/src/services/trabajadores.servicio.dart';
import 'package:datafire/src/widgets/proyectosCard/menu/window1.dart';
import 'package:datafire/src/widgets/proyectosCard/menu/window2.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:datafire/src/widgets/proyectosCard/form_editarProyecto.dart';

class DetallesYAltaProyectoPage extends StatefulWidget {
  final Map<String, dynamic>? proyecto;

  DetallesYAltaProyectoPage({Key? key, required this.proyecto}) : super(key: key);

  @override
  _DetallesYAltaProyectoPageState createState() => _DetallesYAltaProyectoPageState();
}

class _DetallesYAltaProyectoPageState extends State<DetallesYAltaProyectoPage> {
  final _nombreController = TextEditingController();
  final _inicioController = TextEditingController();
  final _finController = TextEditingController();
  final _costoController = TextEditingController();
  late final String _idProyecto;

  @override
  void initState() {
    super.initState();
    _idProyecto = widget.proyecto?["id"].toString() ?? "";
    _nombreController.text = widget.proyecto?['project_name'] ?? 'Sin nombre';
    _inicioController.text = widget.proyecto?['fecha_inicio'] ?? 'Sin fecha de inicio';
    _finController.text = widget.proyecto?['fecha_fin'] ?? 'Sin fecha de finalización';
    _costoController.text = widget.proyecto?["costo"].toString() ?? "Sin costo total";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles y Editar Proyecto'),
      ),
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: DefaultTabController(
              length: 3,
              child: Column(
                children: [
                  TabBar(
                    tabs: [
                      Tab(text: 'Detalles'),
                      Tab(text: 'Clientes Asociados'),
                      Tab(text: 'Trabajadores'),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        // Detalles
                        window1(proyecto: widget.proyecto),

                        // Clientes Asociados
                        Container(
                          padding: const EdgeInsets.all(16.0),
                          child: window2(proyecto: widget.proyecto, selectClientsDialog: _selectClientsDialog, idProyecto: _idProyecto,)
                        ),

                        // Contenido para la tercera pestaña
                         Container(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
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
                                        .where((cp) => cp['project_id'] == widget.proyecto?['id'])
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
                                    _selectWorkersDialog(_idProyecto);
                                  },
                                  icon: Icon(Icons.edit),
                                ),
                              ),
                            ],
                          ),
                        ),




                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Formulario en el lado derecho
          Expanded(
            flex: 1,
            child: Container(
              width: 300,
              padding: const EdgeInsets.all(16.0),
              child: EditarProyectosForm(proyecto: widget.proyecto),
            ),
          ),
        ],
      ),
    );
  }

  void _selectClientsDialog(String projectId) async {
    List<dynamic> clientes = await fetchClientes();
    List<String> clientesSeleccionados = [];

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Selecciona clientes"),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SingleChildScrollView(
                child: Column(
                  children: clientes.map((cliente) {
                    bool isSelected = clientesSeleccionados.contains(cliente["id"]?.toString() ?? "");

                    return CheckboxListTile(
                      title: Text(cliente["name"]?.toString() ?? ""),
                      value: isSelected,
                      onChanged: (bool? value) {
                        setState(() {
                          if (value != null) {
                            if (value) {
                              clientesSeleccionados.add(cliente["id"]?.toString() ?? "");
                            } else {
                              clientesSeleccionados.remove(cliente["id"]?.toString() ?? "");
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
                clientesSeleccionados.forEach((clienteId) {
                  postCustomerProject().addCustomerProject(projectId, clienteId);
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
  void _selectWorkersDialog(String projectId) async {
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
