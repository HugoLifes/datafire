import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:datafire/src/services/cliente.servicio.dart';
import 'package:flutter/material.dart';
import 'package:datafire/src/services/proyectos-clientes.service.dart';

class Window2 extends StatefulWidget {
  final Map<String, dynamic>? proyecto;
  final String idProyecto;

  const Window2({
    Key? key,
    required this.proyecto,
    required this.idProyecto,
  }) : super(key: key);

  @override
  _Window2State createState() => _Window2State();
}

class _Window2State extends State<Window2> {
  late Future<List<dynamic>> futureCustomerProjects;

  @override
  void initState() {
    super.initState();
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
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Text('No hay Clientes disponibles',
                    style: TextStyle(fontSize: 20));
              } else {
                List<dynamic> customerProjects = snapshot.data!;
                List customerData = customerProjects
                    .where((cp) => cp['project_id'] == widget.proyecto?['id'])
                    .toList();

                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: customerData.length,
                  itemBuilder: (context, index) {
                    final customer = customerData[index];
                    return Card(
                      elevation: 5,
                      margin: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 0),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        leading: CircleAvatar(
                          backgroundColor: Theme.of(context).primaryColor,
                          child: Text(
                            customer['customer_name'][0].toUpperCase(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        title: Text(
                          customer['customer_name'],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text('ID Cliente: ${customer['id']}'),
                        trailing: Wrap(
                          spacing: 12,
                          children: <Widget>[
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteCustomerDialog(customer),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {
              _selectClientsDialog(widget.idProyecto);
            },
            icon: const Icon(Icons.add),
            label: const Text("Añadir Clientes"),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _deleteCustomerDialog(dynamic customer) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      animType: AnimType.scale,
      title: "Eliminar Cliente del proyecto",
      desc: "¿Estás seguro que quieres eliminar este Cliente?",
      width: 620,
      btnCancelOnPress: () {},
      btnOkOnPress: () async {
        await deleteCustomerProjectRelation(customer['id']);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cliente eliminado correctamente'),
          ),
        );
        setState(() {
          futureCustomerProjects = fetchCustomerProjects();
        });
      },
    ).show();
  }

  void _selectClientsDialog(String projectId) async {
    List<dynamic> todosLosClientes = await fetchClientes();
    List<dynamic> proyectosClientes = await fetchCustomerProjects();

    // Filtra para obtener solo los clientes relacionados
    List<dynamic> clientesDelProyecto = proyectosClientes
        .where((cp) => cp['project_id'].toString() == projectId)
        .toList();

    // Extrae los IDs de los clientes
    List<String> idsClientesDelProyecto =
        clientesDelProyecto.map((cp) => cp['customer_id'].toString()).toList();

    // Filtra la lista de todos los clientes
    List<dynamic> clientesParaMostrar = todosLosClientes
        .where((cliente) =>
            !idsClientesDelProyecto.contains(cliente['id'].toString()))
        .toList();

    List<String> clientesSeleccionados = [];

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Selecciona clientes"),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SingleChildScrollView(
                child: Column(
                  children: clientesParaMostrar.map((cliente) {
                    bool isSelected = clientesSeleccionados
                        .contains(cliente["id"]?.toString() ?? "");
                    return CheckboxListTile(
                      title: Text(cliente["name"]?.toString() ?? ""),
                      value: isSelected,
                      onChanged: (bool? value) {
                        setState(() {
                          if (value != null) {
                            if (value) {
                              clientesSeleccionados
                                  .add(cliente["id"]?.toString() ?? "");
                            } else {
                              clientesSeleccionados
                                  .remove(cliente["id"]?.toString() ?? "");
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
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancelar"),
            ),
            TextButton(
              onPressed: () async {
                await Future.forEach(clientesSeleccionados,
                    (dynamic clienteId) async {
                  await PostCustomerProject()
                      .addCustomerProject(projectId, clienteId.toString());
                });
                setState(() {
                  futureCustomerProjects = fetchCustomerProjects();
                });
                Navigator.of(context).pop();
              },
              child: const Text("Guardar"),
            ),
          ],
        );
      },
    );
  }
}
