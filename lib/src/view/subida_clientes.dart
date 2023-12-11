import 'package:datafire/src/forms/alta_form_clientes.dart';
import 'package:datafire/src/services/cliente.servicio.dart';
import 'package:datafire/src/widgets/colors.dart';
import 'package:flutter/material.dart';

class AltaClientes extends StatefulWidget {
  const AltaClientes({Key? key}) : super(key: key);

  @override
  _AltaClientesState createState() => _AltaClientesState();
}

class _AltaClientesState extends State<AltaClientes> {
  late Future<List<dynamic>> _clientesFuture;

  @override
  void initState() {
    super.initState();
    _clientesFuture = getAllClientes();
  }

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
        label: const Row(children: [
          Text('Agregar Cliente', style: TextStyle(fontSize: 15))
        ]),
      ),
      body: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 8.0, right: 12.0),
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
                'En esta sección se mostrarán sus clientes o poder dar de alta clientes'),
          ),
          FutureBuilder<List<dynamic>>(
            future: _clientesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Center(
                    child: Text('Error al cargar los clientes'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No hay clientes disponibles'));
              } else {
                // Mostrar la lista de clientes en la UI
                final clientes = snapshot.data as List<dynamic>;
                return ListView.builder(
                  itemCount: clientes.length,
                  itemBuilder: (context, index) {
                    final cliente = clientes[index];
                    return ListTile(
                      leading: const Icon(Icons.edit_outlined),
                      title: Text(cliente["name"]),
                      subtitle: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(cliente["last_name"]),
                            Text(cliente["company"]),
                          ]),
                    );
                  },
                );
              }
            },
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
