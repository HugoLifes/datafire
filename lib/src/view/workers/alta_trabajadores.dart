import 'package:datafire/src/forms%20alta/alta_form_trabajadores.dart';
import 'package:datafire/src/model/data.dart';
import 'package:datafire/src/view/workers/trabajadores/cardTrabajadores.dart';
import 'package:datafire/src/widgets/appBar.dart';
import 'package:flutter/material.dart';

class AltaTrabajadores extends StatefulWidget {
  const AltaTrabajadores({Key? key}) : super(key: key);

  @override
  _AltaTrabajadoresState createState() => _AltaTrabajadoresState();
}

class _AltaTrabajadoresState extends State<AltaTrabajadores> {
  late Future<List<dynamic>> _trabajadoresFuture;

  @override
  void initState() {
    super.initState();
    _trabajadoresFuture = obtenerTrabajadores();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
            appBar: const PreferredSize(
              preferredSize: Size.fromHeight(kToolbarHeight),
              child: AppBarDatafire(title: "Trabajadores", description: "Administra y da de alta tu trabajadores")
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AltaTrabajadorPage(),
            ),
          );
        },
        icon: const Icon(Icons.receipt),
        elevation: 4,
        label: const Row(children: [
          Text('Agregar Trabajador', style: TextStyle(fontSize: 15))
        ]),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _trabajadoresFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(
                child: Text('Error al cargar los trabajadores'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay trabajadores disponibles'));
          } else {
            final trabajadores = snapshot.data as List<dynamic>;
            return GridView.builder(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 15),
              itemCount: trabajadores.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: size.width > 800 ? 2 : 1,
                childAspectRatio: size.width / (size.width > 800 ? 500 : 255),
                crossAxisSpacing: 25,
                mainAxisSpacing: 20,
              ),
              itemBuilder: (context, index) {
                final trabajador = trabajadores[index];
                return TrabajadorCard(trabajador: trabajador);
              },
            );
          }
        },
      ),
    );
  }
}
