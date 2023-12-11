import 'package:datafire/src/forms/alta_form_proyectos.dart';
import 'package:flutter/material.dart';

import '../widgets/colors.dart';

class AltaProyectos extends StatelessWidget {
  const AltaProyectos({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Proyectos',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            ),
            Text(
              'Da de alta proyectos y asígnalos a tus clientes y trabajadores',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
        backgroundColor: accentCanvasColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            bottomLeft: Radius.circular(20),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AltaProyectoPage(),
            ),
          );
        },
        icon: const Icon(Icons.receipt),
        elevation: 8,
        label: const Row(
          children: [
            Text('Alta Proyectos', style: TextStyle(fontSize: 15)),
          ],
        ),
      ),
      body: Container(),
    );
  }
}
