import 'package:datafire/src/forms/alta_form_proyectos.dart';
import 'package:datafire/src/forms/alta_form_trabajadores.dart';
import 'package:flutter/material.dart';

import '../widgets/colors.dart';

class AltaTrabajadores extends StatelessWidget {
  const AltaTrabajadores({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Trabajadores',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            ),
            Text(
              'Da de alta a tus trabajadores',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
        backgroundColor: accentCanvasColor,
        shape: RoundedRectangleBorder(
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
              builder: (context) => AltaTrabajadorPage(),
            ),
          );
        },
        icon: const Icon(Icons.receipt),
        elevation: 8,
        label: const Row(children: [
          Text('Agregar Trabajador', style: TextStyle(fontSize: 15))
        ]),
      ),
    );
  }
}
