import 'package:flutter/material.dart';

import '../widgets/colors.dart';

//En esta seccion se hacen alta de proyectos

//hay que levantar un proyecto y casarlo a un cliente

// Seccion de trabajadores

class AltaTrabajadores extends StatelessWidget {
  const AltaTrabajadores({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    var size = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(Icons.receipt),
        elevation: 8,
        label: Row(children: [
          Text('Agregar Trabajador', style: TextStyle(fontSize: 15))
        ]),
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
                'Trabajadores',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              )),
          Container(
            padding: const EdgeInsets.only(top: 55, left: 10),
            width: size.width > 600 ? size.width * 0.8 : 500,
            child: Text('Da de alta a tus trabajadores'),
          ),
        ],
      ),
    );
  }
}
