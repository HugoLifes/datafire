import 'package:flutter/material.dart';

import '../widgets/colors.dart';

/// [Home] o Dasboard se usara para mostrar las estadisticas principales
/// como perdida o ganancia, nuevos clientes, proyectos finalizados etc
class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    // final theme = Theme.of(context);
    var size = MediaQuery.of(context).size;
    return Scaffold(
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
                'Home',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              )),
          Container(
            padding: const EdgeInsets.only(top: 55, left: 10),
            width: size.width > 600 ? size.width * 0.8 : 500,
            child: Text('Revisa tu flujo'),
          ),
        ],
      ),
    );
  }
}
