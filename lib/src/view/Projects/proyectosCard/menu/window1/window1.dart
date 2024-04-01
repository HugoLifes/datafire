import 'package:flutter/material.dart';

class Window1 extends StatelessWidget {
  final Map<String, dynamic>? proyecto;

  const Window1({super.key, this.proyecto});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          proyecto != null ? buildProjectDetails() : buildEmptyState(),
        ],
      ),
    );
  }

  Widget buildProjectDetails() {
    List<Widget> projectDetails = proyecto!.entries.map((entry) {
      return Card(
        elevation: 4.0,
        margin: const EdgeInsets.all(8.0),
        child: ListTile(
          leading: Icon(
            Icons.check_circle_outline,
          ),
          title: Text(entry.key, style: TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text('${entry.value}'),
        ),
      );
    }).toList();

    return SingleChildScrollView(
      child: Column(
        children: projectDetails,
      ),
    );
  }

  Widget buildEmptyState() {
    // Mostrar un estado vacío si el proyecto es nulo
    return Center(
      child: Text('No hay detalles del proyecto para mostrar.'),
    );
  }
}
