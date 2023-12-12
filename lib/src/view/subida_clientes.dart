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
    _clientesFuture = fetchProjects();
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
            return ListView.builder(
              itemCount: clientes.length,
              itemBuilder: (context, index) {
                final cliente = clientes[index];
                return Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors
                            .grey, // Cambia el color del borde según tus necesidades
                        width:
                            1.0, // Cambia el ancho del borde según tus necesidades
                      ),
                    ),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 20),
                    leading: const Icon(
                      Icons.edit_outlined,
                      size: 27,
                      color: Colors.orange,
                    ),
                    subtitle: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              cliente["id"].toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 12),
                            Text(cliente["name"]),
                            SizedBox(width: 12),
                            Text(cliente["last_name"]),
                            SizedBox(width: 12),
                            Text(cliente["company"]),
                          ],
                        )
                      ],
                    ),
                  ),
                );
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
