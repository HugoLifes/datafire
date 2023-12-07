import 'package:flutter/material.dart';

import '../widgets/colors.dart';
import '../forms/alta_form_clientes.dart'; // Reemplaza con la ruta correcta

class AltaClientes extends StatelessWidget {
  const AltaClientes({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    var size = MediaQuery.of(context).size;

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Al presionar el botón, navegar a la página AltaClientePage
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AltaClientePage(),
            ),
          );
        },
        icon: const Icon(Icons.receipt),
        elevation: 4,
        label: Row(children: [
          Text('Agregar Cliente', style: TextStyle(fontSize: 15))
        ]),
      ),
      body: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(top: 8.0, right: 12.0),
            height: 100,
            decoration: const BoxDecoration(
                color: accentCanvasColor,
                borderRadius: BorderRadius.all(Radius.circular(20))),
          ),
          Container(
            padding: const EdgeInsets.all(15),
            child: const Text(
              'Clientes',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            ),
          ),
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