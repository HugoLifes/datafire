import 'package:flutter/material.dart';

import '../widgets/colors.dart';

//Vista donde los clientes se van a dar de alta

class AltaClientes extends StatelessWidget {
  const AltaClientes({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(Icons.receipt),
        elevation: 8,
        //si se resite a cambios de estilo quitar const
        label: const Row(
            children: [Text('Alta Clientes', style: TextStyle(fontSize: 15))]),
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
                'Clientes',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              )),
          Container(
            padding: const EdgeInsets.only(top: 55, left: 10),
            width: size.width > 600 ? size.width * 0.8 : 500,
            child: const Text(
                'En esta seccion se mostraran sus clientes o poder dar de alta clientes'),
          ),
        ],
      ),
    );
  }
}

  //funcion de snack bar
        //  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            //  content: const Text('Hola!'),
            //  elevation: 6,
             // action: SnackBarAction(
              //  textColor: Colors.white,
              //  label: 'Cerrar',
              //  onPressed: () {
              //    ScaffoldMessenger.of(context).hideCurrentSnackBar();
             //   },
            //  )));