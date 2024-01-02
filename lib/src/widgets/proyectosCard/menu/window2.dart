// cliente_asociado_tab.dart

import 'package:datafire/src/services/proyectos-clientes.service.dart';
import 'package:flutter/material.dart';

class window2 extends StatelessWidget {
  final Map<String, dynamic>? proyecto;
  final String idProyecto; 
   final void Function(String) selectClientsDialog;

  const window2({
    Key? key,
    required this.proyecto,
    required this.idProyecto,
    required this.selectClientsDialog,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
                            children: [
                              FutureBuilder<List<dynamic>>(
                                future: fetchCustomerProjects(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return CircularProgressIndicator();
                                  } else if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                    return Text('No hay datos disponibles');
                                  } else {
                                    List<dynamic> customerProjects = snapshot.data!;
                                    List customerData = customerProjects
                                        .where((cp) => cp['project_id'] == proyecto?['id'])
                                        .toList();

                                    return DataTable(
                                      columns: [
                                        DataColumn(label: Text('Clientes')),
                                        DataColumn(
                                          label: Text('Eliminar'),
                                          numeric: true,
                                        ),
                                      ],
                                      rows: customerData
                                          .map((customer) => DataRow(
                                            cells: [
                                              DataCell(Text(customer['customer_name'].toString())),
                                              DataCell(
                                                IconButton(
                                                  icon: Icon(Icons.delete),
                                                  onPressed: () {
                                                    deleteCustomerProjectRelation(customer['id']);
                                                    // Muestra el Snackbar al eliminar el cliente
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      SnackBar(
                                                        content: Text('Cliente eliminado correctamente'),
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
                                    selectClientsDialog(idProyecto);
                                  },
                                  icon: Icon(Icons.edit),
                                ),
                              ),
                            ],
                          ),
    );
  }
}
