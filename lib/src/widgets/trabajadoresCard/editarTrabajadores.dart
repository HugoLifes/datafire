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
        title: Text('Detalles y Editar Cliente'),
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
//lado derecho jaja
          Expanded(
            flex: 1, 
            child: Container(
              width: 300, 
              padding: const EdgeInsets.all(16.0),
              child: editarTrabajadoresForm(trabajador: widget.trabajador),
            ),
          ),
        ],
      ),
    );
  }
}
