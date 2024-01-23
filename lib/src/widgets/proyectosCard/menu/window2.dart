import 'package:datafire/src/services/cliente.servicio.dart';
import 'package:flutter/material.dart';
import 'package:datafire/src/services/proyectos-clientes.service.dart';

class window2 extends StatefulWidget {
  final Map<String, dynamic>? proyecto;
  final String idProyecto;


  const window2({
    Key? key,
    required this.proyecto,
    required this.idProyecto,
  }) : super(key: key);

  @override
  _window2State createState() => _window2State();
}

class _window2State extends State<window2> {
  late Future<List<dynamic>> futureCustomerProjects;

  @override
  void initState() {
    super.initState();
    // Inicializar la lista de clientes al inicio
    futureCustomerProjects = fetchCustomerProjects();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          FutureBuilder<List<dynamic>>(
            future: futureCustomerProjects,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Text('No hay Clientes disponibles', style: TextStyle(fontSize: 20));
              } else {
                List<dynamic> customerProjects = snapshot.data!;
                List customerData = customerProjects
                    .where((cp) => cp['project_id'] == widget.proyecto?['id'])
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
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Cliente eliminado correctamente'),
                                      ),
                                    );
                                    // Actualizar la lista después de eliminar un cliente
                                    setState(() {
                                      futureCustomerProjects = fetchCustomerProjects();
                                    });
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
          SizedBox(height: 20),
          Container(
            child: IconButton.filled(
              onPressed: () {
                _selectClientsDialog(widget.idProyecto);
              },
              icon: Icon(Icons.edit),
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

                                setState(() {
                  futureCustomerProjects = fetchCustomerProjects();
                });
              },
              
              child: Text("Guardar"),
            ),
          ],
        );
      },
    );
  }
}

