import 'package:datafire/src/forms/alta_form_proyectos.dart';
import 'package:datafire/src/model/data.dart';
import 'package:datafire/src/widgets/proyectosCard/cardProyecto.dart';
import 'package:datafire/src/widgets/colors.dart';
import 'package:flutter/material.dart';

class AltaProyectos extends StatefulWidget {
  const AltaProyectos({Key? key}) : super(key: key);

  @override
  _AltaProyectosState createState() => _AltaProyectosState();
}

class _AltaProyectosState extends State<AltaProyectos> {
  late Future<List<dynamic>> _proyectosFuture;

  @override
  void initState() {
    super.initState();
    _proyectosFuture = obtenerProyectos();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Proyectos',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            ),
            Text(
              'En esta sección se mostrarán sus Proyectos o poder dar de alta Proyectos',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
        backgroundColor: accentCanvasColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Al presionar el botón, navegar a la página AltaClientePage
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AltaProyectoPage(),
            ),
          );
        },
        icon: const Icon(Icons.receipt),
        elevation: 4,
        label: const Row(children: [
          Text('Agregar Proyecto', style: TextStyle(fontSize: 15))
        ]),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _proyectosFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error al cargar los clientes'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay clientes disponibles'));
          } else {
            // Mostrar la lista de clientes en la UI
            final proyectos = snapshot.data as List<dynamic>;
            return GridView.builder(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 15),
              itemCount: proyectos.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: size.width > 800 ? 2 : 1,
                childAspectRatio: size.width / (size.width > 800 ? 500 : 255),
                crossAxisSpacing: 25,
                mainAxisSpacing: 20,
              ),
              itemBuilder: (_, int index) {
                final proyecto = proyectos[index];
                return ProyectoCard(proyecto: proyecto);
              },
            );
          }
        },
      ),
    );
  }
}
