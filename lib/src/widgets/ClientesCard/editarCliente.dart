import 'package:datafire/src/widgets/ClientesCard/form.editar.clientes.dart';
import 'package:flutter/material.dart';

class DetallesYEditarClientesPage extends StatefulWidget {
  final Map<String, dynamic>? cliente;

  DetallesYEditarClientesPage({Key? key, required this.cliente})
      : super(key: key);

  @override
  _DetallesYEditarClientesPageState createState() =>
      _DetallesYEditarClientesPageState();
}

class _DetallesYEditarClientesPageState
    extends State<DetallesYEditarClientesPage> {
  final _nombreController = TextEditingController();
  final _apellidosController = TextEditingController();
  final _empresaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nombreController.text = widget.cliente?['name'] ?? '';
    _apellidosController.text = widget.cliente?['last_name'] ?? '';
    _empresaController.text = widget.cliente?['company'] ?? '';
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
                              rows: widget.cliente?.entries
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
              padding: const EdgeInsets.all(18.0),
              child: EditarClienteForm(cliente: widget.cliente),
            ),
          ),
        ],
      ),
    );
  }
}