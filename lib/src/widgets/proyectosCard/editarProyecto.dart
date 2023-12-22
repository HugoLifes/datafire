import 'package:datafire/src/widgets/proyectosCard/editar.Proyecto.form.dart';
import 'package:flutter/material.dart';

class DetallesYAltaProyectoPage extends StatefulWidget {
  final Map<String, dynamic>? proyecto;

  DetallesYAltaProyectoPage({Key? key, required this.proyecto})
      : super(key: key);

  @override
  _DetallesYAltaProyectoPageState createState() =>
      _DetallesYAltaProyectoPageState();
}

class _DetallesYAltaProyectoPageState extends State<DetallesYAltaProyectoPage> {
  final _nombreController = TextEditingController();
  final _inicioController = TextEditingController();
  final _finController = TextEditingController();
  final _costoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nombreController.text = widget.proyecto?['name'] ?? 'Sin nombre';
    _inicioController.text = widget.proyecto?['fecha_inicio'] ?? 'Sin fecha de inicio';
    _finController.text = widget.proyecto?['fecha_fin'] ?? 'Sin fecha de finaliacion';
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
                      Tab(text: 'Otra Opción'),
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
                              columns: const [
                                DataColumn(label: Text('Campo')),
                                DataColumn(label: Text('Valor')),
                              ],
                              rows: widget.proyecto?.entries
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
                          child: Center(
                            child: Text('Contenido de la segunda opción'),
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
}
