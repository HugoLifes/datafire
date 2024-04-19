import 'package:datafire/src/view/workers/trabajadores/menu/Tools.dart';

import 'package:flutter/material.dart';
import 'package:datafire/src/services/proyectosTrabajadores.service.dart';
import 'package:datafire/src/view/workers/trabajadores/menu/WorkerCosts.dart';
import 'package:datafire/src/view/workers/trabajadores/form_editarTrabajadores.dart';

class DetallesYEditarTrabajadoresPage extends StatefulWidget {
  final Map<String, dynamic>? trabajador;

  const DetallesYEditarTrabajadoresPage({Key? key, required this.trabajador})
      : super(key: key);

  @override
  _DetallesYEditarTrabajadoresPageState createState() =>
      _DetallesYEditarTrabajadoresPageState();
}

class _DetallesYEditarTrabajadoresPageState
    extends State<DetallesYEditarTrabajadoresPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles y Editar Trabajador'),
      ),
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: DefaultTabController(
              length: 4,
              child: Column(
                children: [
                  const TabBar(
                    tabs: [
                      Tab(text: 'Detalles'),
                      Tab(text: 'Proyectos'),
                      Tab(text: 'Costo Empresa semanal'),
                      Tab(text: 'Herramientas'),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        // Detalles
                        buildDetailsSection(widget.trabajador),
                        // Proyectos
                        buildProjectsSection(widget.trabajador),
                        // Costo Empresa semanal
                        WorkerCostsTab(
                          idProyecto: widget.trabajador!["id"].toString(),
                          salary: widget.trabajador!["salary"],
                        ),
                        ToolsTab(
                          workerId: widget.trabajador!["id"].toString(),
                          salary: widget.trabajador!["salary"],
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
              padding: const EdgeInsets.all(16.0),
              child: EditarTrabajadoresForm(trabajador: widget.trabajador),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDetailsSection(Map<String, dynamic>? trabajador) {
    if (trabajador == null) {
      return const Center(child: Text("No hay información del trabajador."));
    }
    return SingleChildScrollView(
      child: Column(
        children: trabajador.entries
            .map((entry) => Card(
                  elevation: 4.0,
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: Icon(Icons.person_outline,
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

  Widget buildProjectsSection(Map<String, dynamic>? trabajador) {
    return FutureBuilder<List<dynamic>>(
      future: fetchProjectWorkersbyId(trabajador?['id']),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.data == null || snapshot.data!.isEmpty) {
          return const Center(
              child: Text('El trabajador no tiene proyectos asociados'));
        }
        return SingleChildScrollView(
          child: Column(
            children: snapshot.data!
                .map((project) => Card(
                      elevation: 4.0,
                      margin: const EdgeInsets.all(8.0),
                      child: ListTile(
                        leading: Icon(Icons.work_outline,
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
