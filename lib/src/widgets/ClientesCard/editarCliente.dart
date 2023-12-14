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
      body: LayoutBuilder(
        builder: (context, constraints) {
          //aqui es donde se convierte en dos columnas o una
          int columnas = constraints.maxWidth > 600 ? 2 : 1;
          return GridView.count(
            crossAxisCount: columnas,
            children: [
              Container(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: DataTable(
                    columns: [
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

              // Edición de Proyecto (Formulario)
              Container(
                padding: const EdgeInsets.all(18.0),
                child: editarClienteForm(cliente: widget.cliente),
              ),
            ],
          );
        },
      ),
    );
  }
}
