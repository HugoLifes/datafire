import 'package:datafire/src/services/cliente.servicio.dart';
import 'package:datafire/src/services/proyectos.service.dart';
import 'package:datafire/src/view/exito_alta.dart';
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
  final _formKey = GlobalKey<FormState>();
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
                padding: const EdgeInsets.all(16.0),
                child: formview(context),
              ),
            ],
          );
        },
      ),
    );
  }

  Container formview(BuildContext context) {
    return Container(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _nombreController,
              decoration: const InputDecoration(
                labelText: 'Nombre del Cliente',
                border: OutlineInputBorder(),
                fillColor: Colors.white,
                filled: true,
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Por favor, ingresa el nombre del Cliente';
                }
                return null;
              },
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: _apellidosController,
              decoration: const InputDecoration(
                labelText: 'Apellidos',
                border: OutlineInputBorder(),
                fillColor: Colors.white,
                filled: true,
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Por favor, ingresa la edad del cliente';
                }
                return null;
              },
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: _empresaController,
              decoration: const InputDecoration(
                labelText: 'Compáñia',
                border: OutlineInputBorder(),
                fillColor: Colors.white,
                filled: true,
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Por favor, ingresa la compañia del cliente';
                }
                return null;
              },
            ),
            const SizedBox(height: 16.0),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    String name = _nombreController.text;
                    String last_name = _apellidosController.text;
                    String company = _empresaController.text;

                    // Lógica para editar el proyecto existente
                    try {
                      await updateCliente(
                          widget.cliente?['id'], name, last_name, company);
                      print('Cliente actualizado: $name');
                      // Puedes llamar a una función o realizar cualquier otra acción aquí
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SuccessfulScreen(),
                        ),
                      );
                      print(
                          'Datos a enviar para actualizar cliente: $name, $last_name, $company');
                    } catch (error) {
                      print('Error al actualizar el cliente: $error');
                      // Puedes mostrar un mensaje de error al usuario si es necesario
                    }
                  }
                },
                child: const Text('Sobreescribir'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
