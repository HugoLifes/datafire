import 'package:datafire/src/forms/alta_form_proyectos.dart';
import 'package:flutter/material.dart';

import '../widgets/colors.dart';

//En esta seccion se hacen alta de proyectos

//hay que levantar un proyecto y casarlo a un cliente

// Seccion de trabajadores

class AltaProyectos extends StatelessWidget {
  const AltaProyectos({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    var size = MediaQuery.of(context).size;
    return Scaffold(
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
        label: Row(
            children: [Text('Alta Proyectos', style: TextStyle(fontSize: 15))]),
      ),
      body: Stack(
        children: [
          Container(
              height: 100,
              decoration: const BoxDecoration(
                  color: accentCanvasColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      bottomLeft: Radius.circular(20)))),
          Container(
              padding: const EdgeInsets.all(15),
              child: const Text(
                'Proyectos',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              )),
          Container(
            padding: const EdgeInsets.only(top: 55, left: 10),
            width: size.width > 600 ? size.width * 0.8 : 500,
            child: Text(
                'Da de alta proyectos y asignalo a tus clientes y trabajadores'),
          ),
        ],
      ),
    );
  }
}
