import 'package:datafire/src/services/proyectosTrabajadores.service.dart';
import 'package:flutter/material.dart';
import 'package:datafire/src/widgets/trabajadoresCard/editar.trabajadores.form.dart';

class DetallesYEditarTrabajadoresPage extends StatefulWidget {
  final Map<String, dynamic>? trabajador;

  DetallesYEditarTrabajadoresPage({Key? key, required this.trabajador})
      : super(key: key);

  @override
  _DetallesYEditarTrabajadoresPageState createState() =>
      _DetallesYEditarTrabajadoresPageState();
}

class _DetallesYEditarTrabajadoresPageState
    extends State<DetallesYEditarTrabajadoresPage> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _apellidosController = TextEditingController();
  final _cargoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nombreController.text = widget.trabajador?['name'] ?? '';
    _apellidosController.text = widget.trabajador?['last_name'] ?? '';
    _cargoController.text = widget.trabajador?['position'] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles y Editar Trabajador'),
      ),
      body: Row(
        children: [
          Expanded(
            flex: 1, // Ajusta el flex para la mitad de la pantalla
            child: DefaultTabController(
              length: 3,
              child: Column(
                children: [
                  TabBar(
                    tabs: [
                      Tab(text: 'Detalles'),
                      Tab(text: 'Proyectos'),
                      Tab(text: 'Otra Más'),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        // Detalles
                        Container(
                          padding: const EdgeInsets.all(16.0),
                          child: SingleChildScrollView(
                            child: DataTable(
                              columns: [
                                DataColumn(label: Text('Campo')),
                                DataColumn(label: Text('Valor')),
                              ],
                              rows: widget.trabajador?.entries
                                      .map((entry) => DataRow(
                                        cells: [
                                          DataCell(Text(entry.key)),
                                          DataCell(Text('${entry.value}')),
                                        ],
                                      ))
                                      .toList() ??
                                  [],
                            ),
                          ),
                        ),

                        // Contenido para la segunda pestaña
                        Container(
                          padding: const EdgeInsets.all(16.0),
                          child: FutureBuilder<List<dynamic>>(
                            future: fetchProjectWorkersbyId(widget.trabajador?['id']),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else if (!snapshot.hasData ||
                                  snapshot.data!.isEmpty) {
                                return Text('El cliente no tiene proyectos asociados');
                              } else {
                                List<dynamic> customerProjects = snapshot.data!;
                                return DataTable(
                                  columns: [
                                    DataColumn(label: Text("ID")),
                                    DataColumn(label: Text('Proyecto')),
                                  ],
                                  rows: customerProjects
                                      .map((project) => DataRow(
                                            cells: [
                                              DataCell(Text(project["project_id"].toString())),
                                              DataCell(Text(project['project_name'].toString())),
                                            ],
                                          ))
                                      .toList(),
                                );
                              }
                            },
                          ),
                        ),

                        // Contenido para la tercera pestaña
                        Container(
                          child: Center(
                            child: Text('Contenido de la tercera opción'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
//lado derecho jaja
          Expanded(
            flex: 1, 
            child: Container(
              width: 300, 
              padding: const EdgeInsets.all(16.0),
              child: EditarTrabajadoresForm(trabajador: widget.trabajador),
            ),
          ),
        ],
      ),
    );
  }
}
