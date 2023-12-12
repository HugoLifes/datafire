import 'package:datafire/src/forms/alta_form_clientes.dart';
import 'package:datafire/src/services/cliente.servicio.dart';
import 'package:datafire/src/widgets/clientesCard.dart';
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
    _clientesFuture =
        fetchClientes(); // Adjust this function based on your actual implementation
  }

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
              'Clientes',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            ),
            Text(
              'En esta sección se mostrarán sus clientes o poder dar de alta clientes',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
        backgroundColor: accentCanvasColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
      ),
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
      body: FutureBuilder<List<dynamic>>(
        future: _clientesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error al cargar los clientes'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay clientes disponibles'));
          } else {
            // Mostrar la lista de clientes en la UI
            final clientes = snapshot.data as List<dynamic>;
            return GridView.builder(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 15),
              itemCount: clientes.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: size.width > 800 ? 2 : 1,
                childAspectRatio: size.width / (size.width > 800 ? 500 : 255),
                crossAxisSpacing: 25,
                mainAxisSpacing: 20,
              ),
              itemBuilder: (context, index) {
                final cliente = clientes[index];
                return clienteCard(cliente: cliente);
              },
            );
          }
        },
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
