import 'package:flutter/material.dart';
import 'package:datafire/src/services/proyectos-clientes.service.dart';
import 'package:datafire/src/view/Customers/ClientesCard/form.editar.clientes.dart';

class DetallesYEditarClientesPage extends StatefulWidget {
  final Map<String, dynamic>? cliente;

  const DetallesYEditarClientesPage({Key? key, required this.cliente})
      : super(key: key);

  @override
  _DetallesYEditarClientesPageState createState() =>
      _DetallesYEditarClientesPageState();
}

class _DetallesYEditarClientesPageState
    extends State<DetallesYEditarClientesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles y Editar Cliente'),
      ),
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: DefaultTabController(
              length: 3,
              child: Column(
                children: [
                  const TabBar(
                    tabs: [
                      Tab(text: 'Detalles'),
                      Tab(text: 'Proyectos'),
                      Tab(text: 'Otra Más'),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        // Detalles
                        buildDetailsSection(widget.cliente),
                        // Proyectos
                        buildProjectsSection(widget.cliente),
                        // Otra Más
                        const Center(
                          child: Text('Contenido de la tercera opción'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.all(18.0),
              child: EditarClienteForm(cliente: widget.cliente),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDetailsSection(Map<String, dynamic>? cliente) {
    if (cliente == null) {
      return const Center(child: Text("No hay información del cliente."));
    }
    return SingleChildScrollView(
      child: Column(
        children: cliente.entries
            .map((entry) => Card(
                  elevation: 4.0,
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: Icon(Icons.info_outline,
                        color: Theme.of(context).primaryColor),
                    title: Text(entry.key,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('${entry.value}'),
                  ),
                ))
            .toList(),
      ),
    );
  }

  Widget buildProjectsSection(Map<String, dynamic>? cliente) {
    return FutureBuilder<List<dynamic>>(
      future: fetchCustomerProjectsbyId(cliente?['id']),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.data == null || snapshot.data!.isEmpty) {
          return const Center(
              child: Text('El cliente no tiene proyectos asociados'));
        }
        return SingleChildScrollView(
          child: Column(
            children: snapshot.data!
                .map((project) => Card(
                      elevation: 4.0,
                      margin: const EdgeInsets.all(8.0),
                      child: ListTile(
                        leading: Icon(Icons.business_center,
                            color: Theme.of(context).primaryColor),
                        title: Text(project['project_name'],
                            style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text("ID: ${project['project_id']}"),
                      ),
                    ))
                .toList(),
          ),
        );
      },
    );
  }
}
