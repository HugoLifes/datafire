import 'package:datafire/src/services/proyectos.service.dart';
import 'package:datafire/src/view/exito_alta.dart';
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
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _inicioController = TextEditingController();
  final _finController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nombreController.text = widget.proyecto?['name'] ?? '';
    _inicioController.text = widget.proyecto?['fecha_inicio'] ?? '';
    _finController.text = widget.proyecto?['fecha_fin'] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles y Editar Proyecto'),
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

              // Edición de Proyecto (Formulario)
              Container(
                padding: const EdgeInsets.all(16.0),
                child: editarProyectosForm(proyecto: widget.proyecto),
              ),
            ],
          );
        },
      ),
    );
  }
}
