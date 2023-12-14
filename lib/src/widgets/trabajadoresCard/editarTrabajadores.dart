import 'package:datafire/src/services/cliente.servicio.dart';
import 'package:datafire/src/services/proyectos.service.dart';
import 'package:datafire/src/services/trabajadores.servicio.dart';
import 'package:datafire/src/view/success.dart';
import 'package:datafire/src/widgets/trabajadoresCard/editar.trabajadores.form.dart';
import 'package:flutter/material.dart';

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

              // Edición de Proyecto (Formulario)
              Container(
                padding: const EdgeInsets.all(16.0),
                child: editarTrabajadoresForm(trabajador: widget.trabajador),
              ),
            ],
          );
        },
      ),
    );
  }
}
