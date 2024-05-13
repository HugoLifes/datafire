import 'package:datafire/src/forms%20alta/alta_form_clientes.dart';
import 'package:datafire/src/model/data.dart';
import 'package:datafire/src/view/Customers/ClientesCard/clientesCard.dart';
import 'package:datafire/src/widgets/appBar.dart';
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
    _clientesFuture = obtenerClientes();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: AppBarDatafire(
              title: "Clientes",
              description:
                  "En esta sección se mostrarán sus clientes o poder dar de alta clientes")),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Al presionar el botón, navegar a la página AltaClientePage
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AltaClientePage(),
            ),
          );
        },
        icon: const Icon(Icons.group_add),
        elevation: 4,
        label: const Row(children: [
          Text('Agregar Cliente',
              style: TextStyle(fontFamily: 'GoogleSans', fontSize: 15))
        ]),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _clientesFuture,
        builder: (context, snapshot) {
          // funcion case
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(
                child: Text(
              'Error al cargar los clientes',
              style: TextStyle(
                fontFamily: 'GoogleSans',
              ),
            ));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
                child: Text(
              'No hay clientes disponibles',
              style: TextStyle(
                fontFamily: 'GoogleSans',
              ),
            ));
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
                return ClienteCard(cliente: cliente);
              },
            );
          }
        },
      ),
    );
  }
}
